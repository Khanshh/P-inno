from pydantic import BaseModel
from typing import Optional


class UserBase(BaseModel):
    username: str
    full_name: str
    patient_code: str


class UserProfile(UserBase):
    email: Optional[str] = None
    phone: Optional[str] = None
    age: Optional[int] = None
    address: Optional[str] = None



