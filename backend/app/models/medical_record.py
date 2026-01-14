from dataclasses import dataclass
from datetime import date
from typing import Optional


@dataclass
class MedicalRecordModel:
    id: str
    hospital_name: str
    department: str
    diagnosis: str
    visit_date: date
    note: Optional[str] = None



