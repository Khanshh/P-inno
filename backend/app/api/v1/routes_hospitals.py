from fastapi import APIRouter
from typing import List, Dict, Any
import json
from pathlib import Path

router = APIRouter()

# Get the path to the data folder
DATA_DIR = Path(__file__).parent.parent.parent.parent / "data"

@router.get("", response_model=List[Dict[str, Any]])
async def get_hospitals():
    """
    Get the list of all available hospitals.
    """
    hospitals_file = DATA_DIR / "hospitals.json"
    
    if not hospitals_file.exists():
        return []
        
    with open(hospitals_file, "r", encoding="utf-8") as f:
        hospitals = json.load(f)
        
    return hospitals
