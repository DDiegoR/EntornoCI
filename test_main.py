#from main import suma

#def test_suma () :
#    assert suma (3,3) == 6
#    assert suma (-1,1) == 0


from api.suma import app

def test_suma():
    client = app.test_client()
    response = client.get('/?a=2&b=3')
    json_data = response.get_json()
    assert response.status_code == 200
    assert json_data["resultado"] == 5
