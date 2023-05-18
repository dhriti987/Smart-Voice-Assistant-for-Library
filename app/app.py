import utils
from flask import Flask, request
from db import LibraryDatabase
import json

app = Flask(__name__)
database = LibraryDatabase()


@app.route('/resolve-query', methods=['POST'])
def resolve_query():
    text = request.form.get('text', 'abra cadabra')
    result = utils.engine.get_results(text)
    reply = ''
    if result['status'] == utils.Status.SUCCESSFULL:
        reply = utils.query_successfull(result)

    elif result['status'] == utils.Status.INTENT_NOT_FOUND:
        reply = utils.query_intent_not_found()

    elif result['status'] == utils.Status.SLOT_NOT_FOUND:
        if result['intent'] == 'searchByGenre':
            slot = 'genre'

        elif result['intent'] == 'searchByAuthor':
            slot = 'author name'

        else:
            slot = 'book name'

        reply = utils.query_slot_not_found(slot)

    result['reply'] = reply
    result['status'] = result['status'].value
    return result


@app.route('/sign-up', methods=['POST'])
def sign_up():
    name = request.form.get('name', '')
    username = request.form.get('username', '')
    password = request.form.get('password', '')
    print(name, username, password)
    user = database.add_user(name, username, password)
    if user:
        return {
            "user_id": str(user['_id']),
            "name": user['name'],
        }, 200
    return {'msg': f'User with Username "{username}" already exists'}, 400


@app.route('/login', methods=['POST'])
def login():
    username = request.form.get('username', '')
    password = request.form.get('password', '')
    print(username, password)
    status, msg = database.check_username_password(username, password)
    if status:
        return msg, 200
    else:
        return {'msg': msg}, 403

@app.route('/get-user-books/<string:username>')
def get_user_books(username):
    return database.get_all_read_books(username)


@app.route('/get-issued-books/<string:username>')
def get_issued_books(username):
    return json.dumps(database.get_all_issued_books(username), default=str)

@app.route('/issue-book', methods=['POST'])
def issue_book():
    data = request.form.to_dict()
    status, msg = database.issue_book(**data)
    return {'msg':msg}, 200 if status else 404

@app.route('/return-book', methods=['POST'])
def return_book():
    data = request.form.to_dict()
    database.returned_book(**data)
    return {}

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
