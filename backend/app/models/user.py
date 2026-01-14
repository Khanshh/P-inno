from dataclasses import dataclass
from typing import Optional


@dataclass
class User:
    username: str
    full_name: str
    patient_code: str
    email: Optional[str] = None
    phone: Optional[str] = None
    age: Optional[int] = None
    address: Optional[str] = None



