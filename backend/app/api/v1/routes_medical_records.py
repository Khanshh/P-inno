from datetime import date
from typing import List

from fastapi import APIRouter, Depends, Header, HTTPException, status

from app.core.config import settings
from app.schemas.medical_record import MedicalRecord


router = APIRouter()


def _verify_token(authorization: str = Header(default="")) -> None:
    prefix = "Bearer "
    if not authorization.startswith(prefix):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing Authorization header.",
        )

    token = authorization[len(prefix) :]
    if token != settings.MOCK_ACCESS_TOKEN:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token.",
        )


@router.get("/medical-records", response_model=List[MedicalRecord])
async def list_medical_records(_: None = Depends(_verify_token)) -> List[MedicalRecord]:
    """
    Return a list of mock medical records for the current user.
    """
    mock_records: List[MedicalRecord] = [
        MedicalRecord(
            id="MR-2024-001",
            hospital_name="Bệnh viện Phụ Sản Trung ương",
            department="Khoa Hiếm Muộn",
            diagnosis="Khám tư vấn vô sinh hiếm muộn",
            visit_date=date(2024, 11, 10),
            note="Đã tư vấn phác đồ IVF, hẹn tái khám sau 2 tuần.",
        ),
        MedicalRecord(
            id="MR-2024-002",
            hospital_name="Bệnh viện Phụ Sản Trung ương",
            department="Khoa Sản",
            diagnosis="Khám sức khỏe tiền thai",
            visit_date=date(2024, 12, 1),
            note="Kết quả xét nghiệm trong giới hạn cho phép.",
        ),
    ]
    return mock_records



