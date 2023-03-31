from nlu import NLUEngine, Status
from tts import TTS
from pprint import PrettyPrinter

speech = TTS(3)
printer = PrettyPrinter()
engine = NLUEngine()


def get_input():  # will change
    return input("Enter your Query: ")


def query_intent_not_found():
    speech.resolve_and_say('INTENT_NOT_FOUND')


def query_slot_not_found(slot_name):
    speech.resolve_and_say('SLOTS_NOT_FOUND', slot_name=slot_name)


def query_search_book(data: dict):
    if data['result']:
        if data["result"]['copies']:
            speech.resolve_and_say(
                'BOOK_FOUND',
                book_name=data['result']['title'],
                shelf=data['result']['location']['shelf'],
                section=data['result']['location']['section']
            )
        else:
            speech.resolve_and_say(
                'BOOK_NOT_AVAILABLE',
                book_name=data['result']['title'],
            )
    else:
        speech.resolve_and_say(
            'BOOK_NOT_FOUND',
            book_name=data['value']
        )


def query_summarize_book(data):
    if data['result']:
        speech.resolve_and_say(
            'SUMMARIZE_BOOK',
            book_name=data['result']['title'],
            author_name=data['result']['author'],
            description=data['result']['description'],
        )
        printer.pprint(data['result'])
    else:
        query_search_book(data)


def query_search_by_author(data: dict):
    if data['result']:
        speech.resolve_and_say(
            'FOUND_BOOK_BY_AUTHOR',
            author_name=data['value']
        )
        printer.pprint(data['result'])

    else:
        speech.resolve_and_say(
            'NOT_FOUND_BOOk_BY_AUTHOR',
            author_name=data['value'],
        )


def query_search_by_genre(data: dict):
    if data['result']:
        speech.resolve_and_say(
            'FOUND_BOOK_BY_GENRE',
            genre=data['value']
        )
        printer.pprint(data['result'])

    else:
        speech.resolve_and_say(
            'NOT_FOUND_BOOk_BY_GENRE',
            genre=data['value'],
        )


def query_successfull(data: dict):
    if data['intent'] == 'searchBook':
        query_search_book(data)

    elif data['intent'] == 'summarizeBook':
        query_summarize_book(data)

    elif data['intent'] == 'searchByAuthor':
        query_search_by_author(data)

    elif data['intent'] == 'searchByGenre':
        query_search_by_genre(data)


# print(query_search_book(NLUEngine().get_results('Where can I find Goblet of Fire')))
if __name__ == "__main__":
    while True:
        query = get_input()
        result = engine.get_results(query)
        if result['status'] == Status.SUCCESSFULL:
            query_successfull(result)

        elif result['status'] == Status.INTENT_NOT_FOUND:
            query_intent_not_found()

        elif result['status'] == Status.SLOT_NOT_FOUND:
            if result['intent'] == 'searchByGenre':
                slot = 'genre'

            elif result['intent'] == 'searchByAuthor':
                slot = 'author name'

            else:
                slot = 'book name'

            query_slot_not_found(slot)
