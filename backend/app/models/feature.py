from dataclasses import dataclass
from typing import Optional


@dataclass
class Feature:
    id: str
    title: str
    icon: str  # Icon name or identifier
    description: Optional[str] = None
    route: Optional[str] = None  # Frontend route if applicable
    order: int = 0  # Display order

