#def suma(a,b):
    #return a + b
from flask import request, jsonify, Flask

app = Flask(__name__)

@app.route("/", methods=["GET"])
def suma():
    a = int(request.args.get("a", 0))
    b = int(request.args.get("b", 0))
    return jsonify({"resultado": a + b})