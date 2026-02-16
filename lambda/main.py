from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()


@app.get("/")
def root():
    return {"message": "Hello from serverless-basic Lambda!"}


@app.get("/health")
def health():
    return {"status": "ok"}


lambda_handler = Mangum(app)
