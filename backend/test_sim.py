import sys
import os
sys.path.append("/home/khanshhh/Documents/Code/Hackathon/P-inno/backend")
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

payload = {
  "model_id": "hunault",
  "user_id": "string",
  "profile": {
    "female": {
      "age": 30,
      "height": 160,
      "weight": 55,
      "trying_duration": "1-2 năm",
      "pregnancy_count": "1",
      "live_births": "0",
      "miscarriages": "1",
      "done_ivf": "Chưa",
      "menstrual_cycle": "Đều",
      "tracking_ovulation": "Có",
      "amh_level": "Bình thường",
      "afc_count": "Bình thường",
      "hsg_result": "Bình thường",
      "has_pcos": "Không",
      "has_endometriosis": "Không",
      "has_thyroid_issues": "Không",
      "smoking": "Không",
      "alcohol": "Không",
      "exercise": "Thường xuyên",
      "stress": "Ít"
    },
    "male": {
      "age": 32,
      "has_children": "Không",
      "semen_test": "Bình thường",
      "testosterone": "Bình thường",
      "testicular_issues": "Không",
      "varicocele": "Không",
      "erectile_dysfunction": "Không",
      "ejaculation_issues": "Không",
      "smoking": "Không",
      "alcohol": "Không",
      "exercise": "Thường xuyên",
      "environment": "Văn phòng",
      "stress": "Ít"
    }
  }
}

try:
    response = client.post("/api/v1/simulation/unified", json=payload)
    print("STATUS:", response.status_code)
    print("BODY:", response.text)
except Exception as e:
    import traceback
    traceback.print_exc()
