"""
News Summarization Service using OpenAI.

This module provides AI-powered summarization for news articles.
"""

import json
from typing import Optional, Dict
from ai.core.clients.llm_client import get_llm_client, LLMMessage


SUMMARIZATION_PROMPT = """Bạn là trợ lý AI tóm tắt tin tức sức khỏe cho app về hiếm muộn và thai kỳ.

Đối tượng người dùng: nam và nữ đang tìm hiểu về hiếm muộn, bà bầu, mẹ đã sinh.
Tone: thân thiện, dễ hiểu, không gây lo lắng hay panic.

Nhiệm vụ của bạn:
1. Đọc toàn bộ bài viết sau đây
2. Phân loại bài viết vào đúng 1 category: [Thai kỳ / Tập luyện / Sức khỏe / Dinh dưỡng]
3. Tóm tắt thành 2-3 câu ngắn gọn, súc tích (khoảng 50-100 từ)

Quy tắc:
- Giữ nguyên các thông tin y tế quan trọng
- Không thêm thông tin không có trong bài gốc
- Sử dụng ngôn ngữ dễ hiểu, thân thiện
- Viết bằng tiếng Việt có dấu
- Nếu bài viết không liên quan đến bất kỳ category nào ở trên, trả về: {"category": "Không xác định", "summary": "Bài viết này không thuộc phạm vi chủ đề của app."}

Output format (chỉ trả về JSON, không thêm text khác):
{
  "category": "<category>",
  "summary": "<tóm tắt>"
}"""


async def summarize_news_content(
    title: str,
    content: str,
    max_tokens: int = 512,
) -> Optional[Dict[str, str]]:
    """
    Generate an AI summary and category for a news article.
    
    Args:
        title: The news article title
        content: The full content of the news article
        max_tokens: Maximum tokens for the response
    
    Returns:
        A dictionary with 'category' and 'summary', or None if generation fails
    """
    if not content or len(content.strip()) < 20:
        return None
    
    try:
        llm_client = get_llm_client()
        
        user_message = f"""Bài viết:
Tiêu đề: {title}
Nội dung: {content}"""
        
        messages = [
            LLMMessage(role="system", content=SUMMARIZATION_PROMPT),
            LLMMessage(role="user", content=user_message),
        ]
        
        response_text = await llm_client.generate(
            messages=messages,
            max_tokens=max_tokens,
            temperature=0.3,
        )
        
        # Log raw response for debugging
        print(f"DEBUG: Raw AI response: '{response_text}'")
        
        if not response_text:
            print("❌ AI returned empty response")
            return None

        # Robust JSON extraction
        clean_text = response_text.strip()
        
        # Handle code blocks
        if "```" in clean_text:
            # Try to find content inside ```json ... ``` or just ``` ... ```
            import re
            json_match = re.search(r'```(?:json)?\s*(\{.*?\})\s*```', clean_text, re.DOTALL)
            if json_match:
                clean_text = json_match.group(1)
            else:
                # If no code block found but ``` exists, maybe it's just one block
                clean_text = clean_text.replace("```json", "").replace("```", "").strip()
        
        # If it's still not starting with {, try to find the start of JSON
        if not clean_text.startswith("{") and "{" in clean_text:
            clean_text = clean_text[clean_text.find("{"):]
        if not clean_text.endswith("}") and "}" in clean_text:
            clean_text = clean_text[:clean_text.rfind("}")+1]

        try:
            data = json.loads(clean_text)
            return {
                "category": data.get("category", "Sức khỏe"),
                "summary": data.get("summary", "")
            }
        except json.JSONDecodeError as je:
            print(f"❌ JSON Decode Error: {je} with text: '{clean_text}'")
            # If it's not JSON, maybe AI just returned the text directly (fallback)
            if not clean_text.startswith("{"):
                return {
                    "category": "Sức khỏe",
                    "summary": response_text[:300]
                }
            return None
        
    except Exception as e:
        print(f"❌ Error generating summary/category: {e}")
        return None


async def generate_fallback_summary(content: str, max_sentences: int = 2) -> str:
    """
    Generate a simple fallback summary by extracting first N sentences.
    
    This is used when AI summarization fails or is unavailable.
    
    Args:
        content: The full content
        max_sentences: Maximum number of sentences to extract (default: 2)
    
    Returns:
        First N sentences from the content
    """
    if not content:
        return "Chưa có bản tóm tắt cho bài viết này."
    
    # Simple sentence splitting (works for Vietnamese)
    sentences = []
    for delimiter in ['. ', '! ', '? ', '.\n', '!\n', '?\n']:
        if delimiter in content:
            parts = content.split(delimiter)
            sentences = [s.strip() + delimiter.strip() for s in parts if s.strip()]
            break
    
    if not sentences:
        # No sentence delimiters found, just take first 200 chars
        return content[:200].strip() + "..."
    
    # Take first N sentences
    summary = ' '.join(sentences[:max_sentences])
    
    # Limit length
    if len(summary) > 300:
        summary = summary[:297] + "..."
    
    return summary
