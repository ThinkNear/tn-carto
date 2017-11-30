from flask import Flask, render_template, request, session, redirect, url_for
from functools import wraps
from datetime import timedelta
import os

USERNAME = os.getenv('LOGIN_USERNAME', 'admin')
PASSWORD = os.getenv('LOGIN_PASSWORD', 'thinknear')
PORT = int(os.getenv('PORT', 8080))
# Set this to True in the console to enter flask Debug Mode
DEBUG_FLAG = os.getenv('DEBUG', False)

application = Flask(__name__)
application.secret_key = os.urandom(12)


def login_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            return redirect(url_for('do_login', next=request.endpoint))

    return wrap


@application.before_request
def before_request():
    session.permanent = True
    application.permanent_session_lifetime = timedelta(days=1)
    session.modified = True


@application.route('/')
@login_required
def home():
    return render_template('index.html')


@application.route('/login', methods=['POST', 'GET'])
def do_login():

    invalid_login = False
    if request.method == 'POST':
        if request.form['password'] == PASSWORD and request.form['username'] == USERNAME:
            session['logged_in'] = True
            return redirect(url_for(request.values.get('next')))
        else:
            invalid_login = True

    if request.values.get('next'):
        next_value = request.values.get('next')
    else:
        next_value = 'home'

    return render_template('login.html', next=next_value, invalid_login=invalid_login)

if __name__ == "__main__":
    # Swap below to debug locally
    application.run(port=PORT, debug=DEBUG_FLAG)
