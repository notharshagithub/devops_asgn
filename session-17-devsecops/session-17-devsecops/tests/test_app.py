import json
from app.app import app


def test_home_endpoint_returns_application_status():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    payload = json.loads(response.data)
    assert payload["application"] == "session-17-devsecops-demo"
    assert payload["status"] == "ok"


def test_health_endpoint_is_healthy():
    response = app.test_client().get("/healthz")
    assert response.status_code == 200
    assert response.get_json() == {"status": "healthy"}


def test_version_endpoint_uses_default_version(monkeypatch):
    monkeypatch.setattr("app.app.APP_VERSION", "dev")
    response = app.test_client().get("/api/version")
    assert response.status_code == 200
    assert response.get_json() == {"version": "dev"}
