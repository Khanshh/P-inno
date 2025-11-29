class ChatbotService {
  // Simulated AI responses - In production, this would connect to a real AI service
  Future<String> getResponse(String userMessage, String? userGender) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final message = userMessage.toLowerCase();
    
    // IVF/IUI related queries
    if (message.contains('ivf') || message.contains('thụ tinh ống nghiệm')) {
      return _getIVFResponse();
    }
    
    if (message.contains('iui') || message.contains('bơm tinh trùng')) {
      return _getIUIResponse();
    }
    
    // General fertility questions
    if (message.contains('mang thai') || message.contains('thụ thai')) {
      return _getPregnancyResponse();
    }
    
    if (message.contains('chu kỳ') || message.contains('kinh nguyệt')) {
      return _getCycleResponse();
    }
    
    if (message.contains('tinh trùng') || message.contains('sperm')) {
      return _getMaleFertilityResponse();
    }
    
    // Default response
    return _getDefaultResponse();
  }

  String _getIVFResponse() {
    return '''Thụ tinh ống nghiệm (IVF) là một kỹ thuật hỗ trợ sinh sản phổ biến. 

Quy trình thường bao gồm:
1. Kích thích buồng trứng bằng thuốc nội tiết
2. Lấy trứng từ buồng trứng
3. Thụ tinh trứng với tinh trùng trong phòng thí nghiệm
4. Chuyển phôi vào tử cung

Tỷ lệ thành công phụ thuộc vào nhiều yếu tố như tuổi tác, chất lượng trứng/tinh trùng, và tình trạng sức khỏe tổng thể.

Bạn có muốn tìm hiểu thêm về quy trình cụ thể hoặc các bước chuẩn bị không?''';
  }

  String _getIUIResponse() {
    return '''Bơm tinh trùng vào tử cung (IUI) là phương pháp ít xâm lấn hơn so với IVF.

Quy trình:
1. Theo dõi rụng trứng
2. Xử lý và làm sạch tinh trùng
3. Bơm tinh trùng trực tiếp vào tử cung vào thời điểm rụng trứng

IUI phù hợp cho các trường hợp:
- Chất lượng tinh trùng nhẹ
- Vấn đề về cổ tử cung
- Không rõ nguyên nhân vô sinh

Bạn có muốn biết thêm về điều kiện để thực hiện IUI không?''';
  }

  String _getPregnancyResponse() {
    return '''Để tăng khả năng thụ thai, bạn nên:

1. Theo dõi chu kỳ kinh nguyệt để xác định thời điểm rụng trứng
2. Quan hệ tình dục đều đặn, đặc biệt trong thời điểm rụng trứng
3. Duy trì lối sống lành mạnh: ăn uống đầy đủ, tập thể dục, ngủ đủ giấc
4. Tránh stress, hút thuốc, uống rượu
5. Bổ sung axit folic và các vitamin cần thiết

Nếu sau 1 năm cố gắng (6 tháng nếu trên 35 tuổi) mà chưa có thai, nên tham khảo ý kiến bác sĩ chuyên khoa.

Bạn có muốn tìm hiểu thêm về cách theo dõi chu kỳ không?''';
  }

  String _getCycleResponse() {
    return '''Chu kỳ kinh nguyệt bình thường kéo dài 21-35 ngày, trung bình 28 ngày.

Thời điểm rụng trứng thường xảy ra khoảng 14 ngày trước kỳ kinh tiếp theo. Các dấu hiệu:
- Tăng nhiệt độ cơ thể
- Dịch nhầy cổ tử cung trong và dai
- Đau nhẹ một bên bụng dưới

Bạn có thể theo dõi chu kỳ trong phần hồ sơ sức khỏe của ứng dụng để dự đoán chính xác hơn thời điểm rụng trứng.

Bạn có muốn tôi hướng dẫn cách nhập thông tin chu kỳ không?''';
  }

  String _getMaleFertilityResponse() {
    return '''Sức khỏe sinh sản nam giới phụ thuộc vào nhiều yếu tố:

1. Chất lượng tinh trùng: số lượng, khả năng di chuyển, hình dạng
2. Lối sống: tránh hút thuốc, uống rượu, stress
3. Chế độ ăn: bổ sung kẽm, vitamin C, E, axit folic
4. Nhiệt độ: tránh tắm nước nóng, mặc quần quá chật
5. Tập thể dục đều đặn nhưng không quá sức

Nên đi khám nếu:
- Sau 1 năm quan hệ đều đặn mà vợ chưa có thai
- Có tiền sử bệnh lý liên quan

Bạn có muốn biết thêm về các xét nghiệm đánh giá chất lượng tinh trùng không?''';
  }

  String _getDefaultResponse() {
    return '''Cảm ơn bạn đã liên hệ! Tôi là chatbot tư vấn về sức khỏe thai sản.

Tôi có thể hỗ trợ bạn về:
- Thông tin về IVF và IUI
- Theo dõi chu kỳ kinh nguyệt
- Tư vấn về khả năng thụ thai
- Sức khỏe sinh sản nam và nữ
- Chế độ dinh dưỡng và lối sống

Bạn muốn tìm hiểu về chủ đề nào? Hãy đặt câu hỏi cụ thể để tôi có thể hỗ trợ tốt hơn!''';
  }
}

