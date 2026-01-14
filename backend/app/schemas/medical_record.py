from datetime import date
from pydantic import BaseModel
from typing import Optional


class MedicalRecord(BaseModel):
    id: str
    hospital_name: str
    department: str
    diagnosis: str
    visit_date: date
    note: Optional[str] = None



