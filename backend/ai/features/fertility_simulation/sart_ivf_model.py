"""
SART IVF Model - Dự đoán khả năng thành công của IVF (Thụ tinh trong ống nghiệm).

Dựa trên các nghiên cứu thống kê tương tự công cụ SART Patient Predictor 
(Mỹ), kết hợp các yếu tố: Tuổi người vợ, BMI, tiền sử IVF, mức AMH, 
và các nguyên nhân chẩn đoán vô sinh (PCOS, Lạc nội mạc tử cung, Tắc vòi trứng, ...).

⚠️ DISCLAIMER: Đây là mô hình tính toán xác suất gần đúng dựa trên các nghiên cứu y khoa chung,
không phải công thức mã nguồn đóng của bộ công cụ SART gốc, 
với mục đích cung cấp số liệu sát thực tế nhất cho người dùng.
"""

from typing import Dict, Any

def predict_ivf_success(sart_input: Dict[str, Any]) -> float:
    """
    Tính ước lượng xác suất (% thành công) của 1 chu kỳ IVF.
    """
    age = sart_input.get("female_age", 30)
    bmi = sart_input.get("bmi", 22.0)
    is_first_cycle = sart_input.get("is_first_cycle", True)
    diagnosis = sart_input.get("diagnosis", {})
    amh = sart_input.get("amh_estimated")

    # 1. Base Probability theo tuổi (Yếu tố quan trọng hàng đầu trong IVF theo CDC/SART)
    if age < 30:
        base_prob = 55.0
    elif age < 35:
        base_prob = 50.0
    elif age < 38:
        base_prob = 38.0
    elif age < 40:
        base_prob = 26.0
    elif age < 42:
        base_prob = 15.0
    elif age <= 44:
        base_prob = 7.0
    else:
        base_prob = 3.0

    # 2. Điều chỉnh dựa trên BMI
    if bmi < 18.5:
        base_prob *= 0.95  # Thiếu cân
    elif 30 < bmi <= 35:
        base_prob *= 0.90  # Béo phì độ 1
    elif bmi > 35:
        base_prob *= 0.80  # Béo phì độ 2, 3
    
    # 3. Điều chỉnh theo tiền sử làm IVF
    if not is_first_cycle:
        # Nếu đã từng làm IVF mà thất bại, xác suất của chu kỳ này thường giảm đi đôi chút
        base_prob *= 0.85

    # 4. Điều chỉnh theo các Yếu tố chẩn đoán ảnh hưởng (từ AI Mapping)
    if diagnosis.get("tubal_factor"):
        # Tắc vòi trứng: IVF vốn được sinh ra để điều trị trường hợp này (bypass vòi trứng)
        # Giữ nguyên Base Prob
        pass
    
    if diagnosis.get("endometriosis"):
        # Lạc nội mạc tử cung: có thể ảnh hưởng nhỏ đến chất lượng trứng/làm tổ
        base_prob *= 0.90
        
    if diagnosis.get("ovulatory_dysfunction") or diagnosis.get("pcos"):
        # PCOS: thu được nhiều trứng, tỷ lệ thành công IVF khá tốt
        base_prob *= 1.05
        
    if amh == "Thấp":
        # AMH thấp biểu thị suy giảm dự trữ buồng trứng
        base_prob *= 0.65
    elif amh == "Cao":
        base_prob *= 1.10
        
    # Chuẩn hoá kết quả trong khoảng 1% đến 85% (không bao giờ 100%)
    final_prob = max(1.0, min(85.0, base_prob))
    
    return round(final_prob, 1)
