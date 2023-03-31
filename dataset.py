
import pandas as pd
import requests
import pickle
google_books_url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:'


def get_book_info(isbn):
    response = requests.get(google_books_url+isbn)
    return response.json()


def update_book(book, items):
    genre = []
    des = ''

    for item in items:

        info = item['volumeInfo']
        if info.get('categories'):
            genre = info['categories']
        if info.get('description'):
            des = info['description']
    book['genre'] = genre
    book['description'] = des
    return book


def update_books_info(books):
    updated_books = []
    for i in range(len(books)):
        isbn = books[i]['ISBN']
        book_info = get_book_info(isbn)
        if book_info.get('totalItems', None):
            try:
                print(i)
                updated_books.append(update_book(
                    books[i], book_info['items']))
            except:
                print('error on', isbn)
        else:
            print('Book not Found\n', books[i])
            books[i]['genre'] = input('Enter Genre: ').split(',')
            books[i]['description'] = input('Enter Description: ')
            updated_books.append(books[i])

    return updated_books


books_data = pd.read_excel('books-database.xlsx')
books_data = update_books_info(books_data.to_dict('records'))
f = open('books-data.pkl', 'wb')
pickle.dump(books_data, f)
print('Done!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
