from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import json
import pandas as pd

app = FastAPI()
model = joblib.load("model.pkl")
try:
    scaler = joblib.load("scaler.pkl")
except Exception:
    class Passthrough:
        def transform(self, X):
            return X.values
    scaler = Passthrough()
config = json.load(open("feature_config.json"))

class Payload(BaseModel):
    datetime: str
    suhu_c: float
    curah_hujan_mm: float
    kode_cuaca: int

@app.post("/predict")
def predict(p: Payload):
    dt = pd.to_datetime(p.datetime)
    row = {
        "suhu_c": p.suhu_c,
        "curah_hujan_mm": p.curah_hujan_mm,
        "kode_cuaca": p.kode_cuaca,
        "hour": dt.hour,
        "dayofweek": dt.dayofweek,
        "is_weekend": 1 if dt.dayofweek >= 5 else 0
    }
    X = pd.DataFrame([row])[config["features"]]
    try:
        Xs = scaler.transform(X)
    except Exception:
        Xs = X.values
    y_pred = float(model.predict(Xs)[0])
    return {"y_pred": y_pred, "unit": "permintaan/jam"}
