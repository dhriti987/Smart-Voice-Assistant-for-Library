from pymongo import MongoClient
from decouple import config
from datetime import datetime as dt
from bson import ObjectId


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

    def borrow_book(self, user_id, book_id):
        pass
