import pytest
from main import app

@pytest.fixture
def client():
    app.testing = True
    return app.test_client()

def test_root_returns_hello_world(client):
    response = client.get("/")
    assert response.status_code == 200
    assert b"Hello, World!" in response.data
