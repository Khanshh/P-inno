import json
import os
from fastapi import APIRouter, HTTPException, status
from typing import List

from app.schemas.discover import (
    DiscoverMethodResponse,
    DiscoverMethodDetailResponse,
    InfertilityInfoResponse,
)
from app.models.discover import DiscoverMethod, InfertilityInfo
from app.core.json_storage import load_from_json

router = APIRouter()

# Load data from JSON files
_methods_path = os.path.join(os.getcwd(), "data", "discover_methods.json")
_mock_methods: List[DiscoverMethod] = load_from_json(_methods_path, DiscoverMethod)

_info_path = os.path.join(os.getcwd(), "data", "infertility_info.json")
try:
    with open(_info_path, "r", encoding="utf-8") as f:
        _info_data = json.load(f)
        _mock_infertility_info = InfertilityInfo(**_info_data)
except Exception as e:
    print(f"Error loading infertility info: {e}")
    # Fallback required if file missing, but typically we assume file exists
    _mock_infertility_info = None



@router.get("/discover/methods", response_model=List[DiscoverMethodResponse])
async def get_discover_methods() -> List[DiscoverMethodResponse]:
    """
    Get list of fertility treatment methods (IVF, IUI, ICSI, etc.).
    """
    methods = sorted(_mock_methods, key=lambda x: x.order)
    return [DiscoverMethodResponse(**method.__dict__) for method in methods]


@router.get("/discover/methods/{method_id}", response_model=DiscoverMethodDetailResponse)
async def get_discover_method_detail(method_id: str) -> DiscoverMethodDetailResponse:
    """
    Get detailed information about a specific fertility treatment method.
    """
    method = next((m for m in _mock_methods if m.id == method_id), None)
    
    if not method:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Method with id {method_id} not found",
        )
    
    return DiscoverMethodDetailResponse(**method.__dict__)


@router.get("/discover/infertility-info", response_model=InfertilityInfoResponse)
async def get_infertility_info() -> InfertilityInfoResponse:
    """
    Get general information about infertility.
    """
    return InfertilityInfoResponse(**{k: v for k, v in _mock_infertility_info.__dict__.items()})

