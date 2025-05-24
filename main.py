#def suma(a,b):
    #return a + b
import functions_framework
from flask import jsonify


@functions_framework.http
def suma(a,b):
    return jsonify({"resultado": a + b})