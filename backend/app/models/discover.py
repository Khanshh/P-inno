from dataclasses import dataclass
from typing import Optional, List


@dataclass
class DiscoverMethod:
    id: str
    title: str
    subtitle: str
    icon: str
    color: str  # Color code like "#2196F3"
    description: Optional[str] = None
    content: Optional[str] = None  # Full content for detail page
    order: int = 0


@dataclass
class InfertilityInfo:
    id: str
    title: str
    content: str
    sections: Optional[List[dict]] = None  # Structured content sections

