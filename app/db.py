from pymongo import MongoClient
from decouple import config
from bson import ObjectId
from datetime import datetime
from pprint import pprint

class LibraryDatabase():
    USERNAME = config('DB_USERNAME')
    PASSWORD = config('DB_PASSWORD')
    connection_string = config('CONNECT_STRING')

    def __init__(self):
        self.client = MongoClient(
            self.connection_string.format(self.USERNAME, self.PASSWORD))

        self.database = self.client.Library

    def get_books_collection(self):
        return self.database.Books

    def get_user_collection(self):
        return self.database.users

    def get_borrow_collection(self):
        return self.database.borrow
    

    def get_user(self, username):
        collection = self.get_user_collection()
        return collection.find_one({"username": username})
    
    def get_book(self, isbn):
        collection = self.get_books_collection()
        return collection.find_one({"ISBN":isbn},{
                    "_id": 1,
                    "ISBN": 1,
                    "title": 1,
                    "description": 1,
                    "number_of_ratings": 1,
                    "genre": 1,
                    "year": 1,
                    "publisher": 1,
                    "author": 1,
                    "copies": 1,
                    "location": 1,
                    "image": 1,
                    })

    def find_book(self, book_name):
        query = [
            {
                "$search": {
                    "index": "book_index",
                    "text": {
                        "query": book_name,
                        "path": "title"
                    }
                }
            },
            {
                "$project": {
                    "_id": 1,
                    "ISBN": 1,
                    "title": 1,
                    "description": 1,
                    "number_of_ratings": 1,
                    "genre": 1,
                    "year": 1,
                    "publisher": 1,
                    "author": 1,
                    "copies": 1,
                    "location": 1,
                    "image": 1,
                    "score": {"$meta": "searchScore"}
                }
            },
            {
                "$match": {
                    "score": {
                        "$gte": 3,
                    }
                }
            },
            {
                "$limit": 1
            }
        ]
        collection = self.get_books_collection()
        try:
            return collection.aggregate(query).next()
        except StopIteration:
            return None

    def find_books_by_author(self, author_name, count):
        query = [
            {
                "$search": {
                    "index": "book_index",
                    "text": {
                        "query": author_name,
                        "path": "author"
                    }
                }
            },
            {
                "$project": {
                    "_id": 1,
                    "ISBN": 1,
                    "title": 1,
                    "description": 1,
                    "number_of_ratings": 1,
                    "genre": 1,
                    "year": 1,
                    "publisher": 1,
                    "author": 1,
                    "copies": 1,
                    "location": 1,
                    "image": 1,
                    "score": {"$meta": "searchScore"}
                }
            },
            {
                "$limit": count
            }
        ]
        collection = self.get_books_collection()
        return list(collection.aggregate(query))

    def find_books_by_genre(self, genre, count):
        query = {
            "$text": {
                "$search": f"\"{genre}\""
            }
        }
        collection = self.get_books_collection()
        return list(collection.find(query, {
                    "_id": 1,
                    "ISBN": 1,
                    "title": 1,
                    "description": 1,
                    "number_of_ratings": 1,
                    "genre": 1,
                    "year": 1,
                    "publisher": 1,
                    "author": 1,
                    "copies": 1,
                    "location": 1,
                    "image": 1,
                    }).limit(count))

    def add_user(self, fullname, username, password):
        collection = self.get_user_collection()
        if collection.count_documents({"username": username}) > 0:
            return None
        user = collection.insert_one({
            "name": fullname,
            "username": username,
            "password": password,
        })
        return collection.find_one({'_id': user.inserted_id})

    def check_username_password(self, username, password):
        collection = self.get_user_collection()
        user = collection.find_one({"username": username})
        if user:
            if user['password'] == password:
                return True, {"user_id": str(user["_id"]), "name": user['name']}
            return False, "Incorrect Password"
        return False, "Incorrect Username"

    def issue_book(self, username, book_isbn, return_date):
        date_format = "%d/%m/%Y"
        user = self.get_user(username)
        if not user:
            return False, "User with username {} not found".format(username)
        book = self.get_book(book_isbn)
        if not book or (book['copies']==0):
            return False, "Book with ISBN {} not available".format(book_isbn)
        issue_date = datetime.today()
        due_date = datetime.strptime(return_date, date_format)

        collection = self.get_borrow_collection()
        collection.insert_one({
            'username':username,
            'book':book_isbn,
            'issue_date': issue_date,
            'due': due_date,
        })
        return True, 'Book with ISBN {} Issued to {}'.format(book_isbn, username)


    def get_all_issued_books(self, username):
        collection = self.get_borrow_collection()
        return list(collection.aggregate([
            {
                "$match":{
                    "username":username,
                }
            },
            
            {
                "$lookup":{
                    "from":"Books",
                    "localField":"book",
                    "foreignField":"ISBN",
                    "as":'book'
                }
            },
            {
                "$unwind":"$book"
            },
            {
                "$project":{
                    "_id": "$book._id",
                    "ISBN": "$book.ISBN",
                    "title": "$book.title",
                    "description": "$book.description",
                    "number_of_ratings": "$book.number_of_ratings",
                    "genre": "$book.genre",
                    "year": "$book.year",
                    "publisher": "$book.publisher",
                    "author": "$book.author",
                    "copies": "$book.copies",
                    "location": "$book.location",
                    "image": "$book.image",
                    "issue_date":1,
                    "due":1
                }
            }

        ]))


    def add_book(self, **book_details):
        pass

    def returned_book(self, username, book_isbn):
        collection = self.get_borrow_collection()
        collection.delete_one({'username':username, 'book':book_isbn}).deleted_count
        return True
    
    def get_all_read_books(self, username):
        collection = self.get_user_collection()
        result = list(collection.aggregate([
            {
                "$match":{
                    "username":username,
                }
            },
            
            {
                "$lookup":{
                    "from":"Books",
                    "localField":"books",
                    "foreignField":"ISBN",
                    "as":'book'
                }
            },
            {
                "$project":{
                    "book":1
                }
            }
        ]))
        if result:
            result = result[0]['book']
        return result

# pprint(LibraryDatabase().issue_book('dhriti987', '0060930535', '30/04/2023'))
# pprint(LibraryDatabase().get_all_issued_books('a'))