import json
import os
from dataclasses import asdict, is_dataclass
from datetime import datetime
from typing import List, Type, TypeVar, Any

T = TypeVar("T")

def serialize_datetime(obj: Any) -> Any:
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError(f"Type {type(obj)} not serializable")

def save_to_json(data: List[Any], file_path: str):
    """Save a list of dataclasses to a JSON file."""
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    
    serializable_data = []
    for item in data:
        if is_dataclass(item):
            serializable_data.append(asdict(item))
        else:
            serializable_data.append(item)
            
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(serializable_data, f, indent=4, ensure_ascii=False, default=serialize_datetime)

def load_from_json(file_path: str, model_class: Type[T]) -> List[T]:
    """Load a list of objects from a JSON file and convert to dataclasses."""
    if not os.path.exists(file_path):
        return []
        
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)
        
    result = []
    for item in data:
        # Convert isoformat dates back to datetime objects
        for key, value in item.items():
            if isinstance(value, str):
                try:
                    # Very simple ISO format check
                    if len(value) >= 19 and (value[4] == "-" and value[7] == "-" and "T" in value):
                        item[key] = datetime.fromisoformat(value)
                except (ValueError, TypeError):
                    pass
        
        if is_dataclass(model_class):
            result.append(model_class(**item))
        else:
            result.append(item)
            
    return result
