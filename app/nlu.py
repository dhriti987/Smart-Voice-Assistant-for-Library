from snips_nlu import SnipsNLUEngine
from db import LibraryDatabase
from enum import Enum


class Status(Enum):
    SUCCESSFULL = 1
    INTENT_NOT_FOUND = 2
    SLOT_NOT_FOUND = 3


class NLUEngine():
    def __init__(self):
        self.engine = SnipsNLUEngine.from_path('model')
        self.intents = {
            'searchBook': {'slots_required': True, 'function': self.search_book},
            'searchByAuthor': {'slots_required': True, 'function': self.search_books_by_author},
            'summarizeBook': {'slots_required': True, 'function': self.search_book},
            'searchByGenre': {'slots_required': True, 'function': self.search_books_by_genre}
        }
        self.db = LibraryDatabase()

    def parse(self, text):
        return self.engine.parse(text)

    def get_results(self, text):
        parsed_text = self.parse(text)
        if parsed_text['intent']['intentName']:
            intent = parsed_text['intent']['intentName']
            if self.intents[intent]['slots_required']:
                if parsed_text['slots']:
                    intent_func = self.intents[intent]['function']
                    value = parsed_text['slots'][0]['value']['value']
                    return {
                        'intent': intent,
                        'result': intent_func(value),
                        'value': value,
                        'status': Status.SUCCESSFULL
                    }
                else:
                    return {
                        'intent': intent,
                        'result': None,
                        'status': Status.SLOT_NOT_FOUND
                    }
            else:
                intent_func = self.intents[intent]
                return {
                    'intent': intent,
                    'result': intent_func(),
                    'status': Status.SUCCESSFULL
                }

        else:
            return {"intent": None, 'data': None, 'status': Status.INTENT_NOT_FOUND}

    def search_book(self, book_name):
        return self.db.find_book(book_name)

    def search_books_by_author(self, author_name, count=10):
        return self.db.find_books_by_author(author_name, count)

    def search_books_by_genre(self, genre, count=10):
        return self.db.find_books_by_genre(genre, count)


# print(NLUEngine().get_results('abra cadabra'))
