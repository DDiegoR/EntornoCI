#from main import suma

#def test_suma () :
#    assert suma (3,3) == 6
#    assert suma (-1,1) == 0


from api.suma import app, suma
from flask import request

def test_suma():
    with app.test_request_context('/?a=2&b=3'):
        response = suma(request)
        assert response.get_json() == {"resultado es": 5}