import socket
from flask import Flask, request

app = Flask(__name__)


@app.route('/')
def hello():
    return 'Hello, World!'

@app.route("/k8s")
def get_hostname():
    hostname = socket.gethostname()
    return f"This pod's hostname is: {hostname}"

@app.route('/whoami')
def whoami():
    return {
        "request": request
    }