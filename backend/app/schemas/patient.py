from pydantic import BaseModel
from typing import Optional


class PatientCreateRequest(BaseModel):
    """Schema for creating a new patient."""
    full_name: str
    dob: str  # DD/MM/YYYY format from the Flutter date picker
    gender: str = "Nam"
    cccd: str
    bhyt: Optional[str] = None
    ethnicity: Optional[str] = None
    phone: str
    email: Optional[str] = None
    address: str


class PatientResponse(BaseModel):
    """Schema for patient response."""
    id: str
    full_name: str
    dob: str
    gender: str
    cccd: str
    bhyt: Optional[str] = None
    ethnicity: Optional[str] = None
    phone: str
    email: Optional[str] = None
    address: str
    created_at: str
