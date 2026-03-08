from dataclasses import dataclass, field
from typing import Optional
from datetime import datetime
import uuid


@dataclass
class Patient:
    """Patient data model."""
    id: str = field(default_factory=lambda: f"PT-{uuid.uuid4().hex[:8].upper()}")
    full_name: str = ""
    dob: str = ""  # DD/MM/YYYY format
    gender: str = "Nam"
    cccd: str = ""  # Citizen ID
    bhyt: Optional[str] = None  # Health insurance code
    ethnicity: Optional[str] = None
    phone: str = ""
    email: Optional[str] = None
    address: str = ""
    created_at: str = field(default_factory=lambda: datetime.now().isoformat())
