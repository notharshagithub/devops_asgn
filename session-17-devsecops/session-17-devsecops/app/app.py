import os
from flask import Flask, jsonify

app = Flask(__name__)
APP_VERSION = os.getenv("APP_VERSION", "dev")


@app.get("/")
def index():
    return jsonify(
        application="session-17-devsecops-demo",
        status="ok",
        version=APP_VERSION,
        message="Build, test, scan, ship, and deploy securely.",
    )


@app.get("/healthz")
def healthz():
    return jsonify(status="healthy"), 200


@app.get("/api/version")
def version():
    return jsonify(version=APP_VERSION), 200
