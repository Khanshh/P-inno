"""
Prompt templates for the chat assistant.

For now we keep it simple with a single system prompt.
Later you can add more templates and versioning here.
"""

BASE_SYSTEM_PROMPT = (
    "Bạn là một trợ lý ảo thân thiện, nói tiếng Việt, hỗ trợ người dùng về "
    "sức khỏe tổng quát và đời sống lành mạnh. "
    "Bạn không thay thế bác sĩ và luôn khuyến khích người dùng gặp chuyên gia "
    "y tế khi có vấn đề nghiêm trọng."
)


def build_rag_system_prompt(retrieved_docs: list[str]) -> str:
    """
    Build system prompt with RAG context injected.

    Args:
        retrieved_docs: List of retrieved document contents

    Returns:
        Enhanced system prompt with context
    """
    if not retrieved_docs:
        return BASE_SYSTEM_PROMPT

    context_section = "\n\n=== TÀI LIỆU THAM KHẢO ===\n"
    for i, doc_content in enumerate(retrieved_docs, 1):
        context_section += f"\n[{i}] {doc_content}\n"

    context_section += (
        "\n=== HƯỚNG DẪN ===\n"
        "Dựa trên các tài liệu tham khảo ở trên, hãy trả lời câu hỏi của người dùng "
        "một cách chính xác và hữu ích. Nếu thông tin trong tài liệu không đủ để trả lời, "
        "hãy nói rõ và đưa ra lời khuyên tổng quát dựa trên kiến thức của bạn. "
        "Luôn nhắc nhở người dùng tham khảo ý kiến bác sĩ cho các vấn đề y tế cụ thể."
    )

    return BASE_SYSTEM_PROMPT + context_section


