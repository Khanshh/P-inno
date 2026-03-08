import os
from typing import List

from fastapi import APIRouter, HTTPException, status

from app.models.patient import Patient
from app.schemas.patient import PatientCreateRequest, PatientResponse
from app.core.json_storage import save_to_json, load_from_json


router = APIRouter()

PATIENTS_STORAGE_PATH = os.path.join(os.getcwd(), "data", "patients.json")

# In-memory patient list
_patients: List[Patient] = []


def _load_patients():
    """Load patients from JSON file on startup."""
    global _patients
    if os.path.exists(PATIENTS_STORAGE_PATH):
        try:
            import json
            with open(PATIENTS_STORAGE_PATH, "r", encoding="utf-8") as f:
                data = json.load(f)
            _patients = [Patient(**item) for item in data]
            print(f"✅ Loaded {len(_patients)} patients from disk")
        except Exception as e:
            print(f"⚠️  Could not load patients: {e}")
            _patients = []
    else:
        _patients = []


def _save_patients():
    """Save current patients to JSON file."""
    save_to_json(_patients, PATIENTS_STORAGE_PATH)


# Load on module import
_load_patients()


@router.post("/patients", response_model=PatientResponse, status_code=status.HTTP_201_CREATED)
async def create_patient(payload: PatientCreateRequest) -> PatientResponse:
    """
    Register a new patient.

    Creates a new patient record and saves it to the data store.
    Returns the created patient with a generated ID.
    """
    # Check for duplicate CCCD
    existing = next((p for p in _patients if p.cccd == payload.cccd), None)
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Bệnh nhân với CCCD {payload.cccd} đã tồn tại.",
        )

    # Create new patient
    new_patient = Patient(
        full_name=payload.full_name,
        dob=payload.dob,
        gender=payload.gender,
        cccd=payload.cccd,
        bhyt=payload.bhyt or "",
        ethnicity=payload.ethnicity,
        phone=payload.phone,
        email=payload.email or "",
        address=payload.address,
    )

    _patients.append(new_patient)
    _save_patients()

    print(f"✅ New patient registered: {new_patient.full_name} (ID: {new_patient.id})")

    return PatientResponse(**new_patient.__dict__)


@router.get("/patients", response_model=List[PatientResponse])
async def list_patients() -> List[PatientResponse]:
    """
    Get all registered patients.

    Returns the full list of patient records.
    """
    return [PatientResponse(**p.__dict__) for p in _patients]


@router.get("/patients/{patient_id}", response_model=PatientResponse)
async def get_patient(patient_id: str) -> PatientResponse:
    """
    Get a specific patient by ID.
    """
    patient = next((p for p in _patients if p.id == patient_id), None)

    if not patient:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Patient with id {patient_id} not found",
        )

    return PatientResponse(**patient.__dict__)
