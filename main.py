#def suma(a,b):
    #return a + b
import functions_framework
from flask import jsonify, Flask

app = Flask(__name__)
def suma(a,b):
    return jsonify({"resultado": a + b})