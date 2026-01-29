from fastapi import APIRouter, HTTPException, status
from typing import List

from app.schemas.discover import (
    DiscoverMethodResponse,
    DiscoverMethodDetailResponse,
    InfertilityInfoResponse,
)
from app.models.discover import DiscoverMethod, InfertilityInfo

router = APIRouter()

# Mock data for discover methods
_mock_methods: List[DiscoverMethod] = [
    DiscoverMethod(
        id="method-ivf",
        title="IVF",
        subtitle="Thụ tinh trong ống nghiệm",
        icon="science_outlined",
        color="#2196F3",
        description="Phương pháp thụ tinh trong ống nghiệm (IVF) là kỹ thuật hỗ trợ sinh sản hiện đại...",
        content="""
# IVF - Thụ tinh trong ống nghiệm

## Tổng quan
IVF là phương pháp hỗ trợ sinh sản được sử dụng rộng rãi nhất hiện nay. 
Quy trình bao gồm việc lấy trứng từ buồng trứng của người phụ nữ và tinh trùng từ người đàn ông, 
sau đó thụ tinh trong phòng thí nghiệm.

## Quy trình
1. Kích thích buồng trứng
2. Lấy trứng
3. Thụ tinh trong phòng lab
4. Nuôi cấy phôi
5. Chuyển phôi vào tử cung

## Tỷ lệ thành công
Tỷ lệ thành công của IVF phụ thuộc vào nhiều yếu tố như tuổi tác, 
sức khỏe của cả hai vợ chồng, và chất lượng phôi.
        """,
        order=1,
    ),
    DiscoverMethod(
        id="method-iui",
        title="IUI",
        subtitle="Bơm tinh trùng vào tử cung",
        icon="medical_services_outlined",
        color="#009688",
        description="Phương pháp bơm tinh trùng đã được lọc rửa trực tiếp vào buồng tử cung...",
        content="""
# IUI - Bơm tinh trùng vào tử cung

## Tổng quan
IUI là phương pháp đơn giản hơn IVF, phù hợp với các trường hợp nhẹ.

## Quy trình
1. Theo dõi rụng trứng
2. Lọc rửa tinh trùng
3. Bơm tinh trùng vào tử cung

## Ưu điểm
- Đơn giản, ít xâm lấn
- Chi phí thấp hơn IVF
- Thời gian ngắn
        """,
        order=2,
    ),
    DiscoverMethod(
        id="method-icsi",
        title="ICSI",
        subtitle="Tiêm tinh trùng vào bào tương",
        icon="biotech_outlined",
        color="#9C27B0",
        description="Kỹ thuật tiêm tinh trùng trực tiếp vào bào tương của trứng...",
        content="""
# ICSI - Tiêm tinh trùng vào bào tương

## Tổng quan
ICSI là kỹ thuật tiên tiến, được sử dụng khi chất lượng tinh trùng kém.

## Quy trình
1. Lấy trứng và tinh trùng
2. Chọn tinh trùng tốt nhất
3. Tiêm trực tiếp vào trứng
4. Nuôi cấy phôi
5. Chuyển phôi

## Chỉ định
- Tinh trùng yếu hoặc ít
- Thất bại với IVF thông thường
- Tinh trùng từ phẫu thuật
        """,
        order=3,
    ),
    DiscoverMethod(
        id="method-egg-freezing",
        title="Đông trứng",
        subtitle="Bảo tồn khả năng sinh sản",
        icon="ac_unit_outlined",
        color="#00BCD4",
        description="Kỹ thuật đông lạnh trứng để bảo tồn khả năng sinh sản...",
        content="""
# Đông trứng - Bảo tồn khả năng sinh sản

## Tổng quan
Đông trứng giúp phụ nữ bảo tồn khả năng sinh sản cho tương lai.

## Quy trình
1. Kích thích buồng trứng
2. Lấy trứng
3. Đông lạnh trứng
4. Lưu trữ
5. Rã đông và thụ tinh khi cần

## Chỉ định
- Phụ nữ muốn trì hoãn sinh con
- Trước khi điều trị ung thư
- Bảo tồn trứng chất lượng tốt
        """,
        order=4,
    ),
    DiscoverMethod(
        id="method-ovulation-stimulation",
        title="Kích trứng",
        subtitle="Kích thích phóng noãn",
        icon="bubble_chart_outlined",
        color="#FF9800",
        description="Phương pháp sử dụng thuốc để kích thích buồng trứng sản xuất và giải phóng trứng...",
        content="""
# Kích thích phóng noãn

## Định nghĩa
Kích thích phóng noãn là phương pháp sử dụng thuốc để kích thích buồng trứng sản xuất và giải phóng trứng. Đây thường là bước điều trị đầu tiên cho những phụ nữ có vấn đề về rụng trứng.

## Chỉ định
- Rối loạn phóng noãn
- Hội chứng buồng trứng đa nang (PCOS)
- Chu kỳ kinh không đều hoặc vô kinh
- Buồng trứng không tạo trứng tự nhiên
- Chuẩn bị cho IUI hoặc quan hệ có kế hoạch

## Ưu điểm
- Phương pháp đơn giản, ít xâm lấn
- Chi phí thấp nhất
- Có thể kết hợp với quan hệ tự nhiên
- Tác dụng phụ ít, dễ thực hiện
        """,
        order=5,
    ),
]

# Mock data for infertility info
_mock_infertility_info = InfertilityInfo(
    id="infertility-info-1",
    title="Tìm hiểu về hiếm muộn",
    content="""
# Hiếm muộn là gì?

Hiếm muộn được định nghĩa là tình trạng một cặp vợ chồng không thể có thai sau 
một năm quan hệ tình dục đều đặn mà không sử dụng biện pháp tránh thai.

## Nguyên nhân

### Nguyên nhân từ phía nữ
- Rối loạn rụng trứng
- Tắc vòi trứng
- Lạc nội mạc tử cung
- Tuổi tác

### Nguyên nhân từ phía nam
- Chất lượng tinh trùng kém
- Số lượng tinh trùng thấp
- Tắc ống dẫn tinh

### Nguyên nhân không rõ ràng
Khoảng 15-20% các trường hợp không tìm được nguyên nhân cụ thể.

## Giải pháp

Có nhiều phương pháp hỗ trợ sinh sản hiện đại như IVF, IUI, ICSI 
giúp các cặp đôi hiếm muộn có cơ hội làm cha mẹ.
    """,
    sections=[
        {
            "title": "Định nghĩa",
            "content": "Hiếm muộn là tình trạng không thể có thai sau một năm..."
        },
        {
            "title": "Nguyên nhân",
            "content": "Có nhiều nguyên nhân dẫn đến hiếm muộn..."
        },
        {
            "title": "Giải pháp",
            "content": "Các phương pháp hỗ trợ sinh sản hiện đại..."
        }
    ]
)


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

