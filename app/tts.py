import pyttsx3
import random


class Reply():
    INTENT_NOT_FOUND = [
        "Sorry didn't understood what you have said",
        "I am sorry, can you repeat your request?"
    ]
    SLOTS_NOT_FOUND = [
        "Sorry, unable to recognise the {slot_name}",
    ]
    BOOK_FOUND = [
        "You can Find {book_name} at shelf {shelf} {section}",
        "Your Book {book_name} is at shelf {shelf} {section}",
    ]
    BOOK_NOT_AVAILABLE = [
        "Sorry Your Requested Book {book_name} is not currently available",
    ]
    BOOK_NOT_FOUND = [
        "We Don't Have {book_name} in our Library",
    ]
    FOUND_BOOK_BY_AUTHOR = [
        "Here are some books related to author {author_name}",
    ]
    NOT_FOUND_BOOk_BY_AUTHOR = [
        "Sorry no books found related to author {author_name}"
    ]
    FOUND_BOOK_BY_GENRE = [
        "Here are some Books of {genre} catagory you will like"
    ]
    NOT_FOUND_BOOk_BY_GENRE = [
        "Sorry No books of {genre} catagory found"
    ]
    SUMMARIZE_BOOK = [
        "Book Name {book_name}, Authored By {author_name}, Synopsis {description}"
    ]


class TTS(Reply):
    def __init__(self, voice_index=0) -> None:
        self.engine = pyttsx3.init('sapi5')

        self.voices = self.engine.getProperty('voices')
        self.engine.setProperty('rate', 150)
        self.engine.setProperty('voice', self.voices[voice_index].id)

    def speak(self, text):
        self.engine.say(text)
        self.engine.runAndWait()

    def resolve(self, resolve, **kwargs):
        sentence = random.choice(getattr(self, resolve))
        return sentence.format(**kwargs)

    def resolve_and_say(self, resolve, **kwargs):
        self.speak(self.resolve(resolve, **kwargs))
