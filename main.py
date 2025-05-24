#def suma(a,b):
    #return a + b
import functions_framework
from flask import request, jsonify, Flask

app = Flask(__name__)

@functions_framework.http
def suma(request):
    a = int(request.args.get("a", 0))
    b = int(request.args.get("b", 0))
    return jsonify({"resultado es": a + b})