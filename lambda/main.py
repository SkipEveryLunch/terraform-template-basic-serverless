from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()


@app.get("/")
def root():
    return {"message": "Hello from serverless-basic Lambda!", "version": "2026-02-16 20:51"}


@app.get("/health")
def health():
    return {"status": "ok"}


lambda_handler = Mangum(app)
