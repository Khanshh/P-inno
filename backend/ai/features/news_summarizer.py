"""
News Summarization Service using OpenAI.

This module provides AI-powered summarization for news articles.
"""

from typing import Optional
from ai.core.clients.llm_client import get_llm_client, LLMMessage


SUMMARIZATION_PROMPT = """Bạn là một trợ lý AI chuyên tóm tắt tin tức y tế và sức khỏe bằng tiếng Việt.

Nhiệm vụ của bạn:
- Đọc và hiểu nội dung bài viết
- Tóm tắt thành 2-3 câu ngắn gọn, súc tích
- Giữ nguyên các thông tin y tế quan trọng
- Sử dụng ngôn ngữ dễ hiểu, thân thiện
- Viết bằng tiếng Việt có dấu

Lưu ý:
- Không thêm thông tin không có trong bài gốc
- Tập trung vào ý chính và lợi ích cho người đọc
- Độ dài: 2-3 câu (khoảng 50-100 từ)
"""


async def summarize_news_content(
    title: str,
    content: str,
    max_tokens: int = 200,
) -> Optional[str]:
    """
    Generate an AI summary for a news article.
    
    Args:
        title: The news article title
        content: The full content of the news article
        max_tokens: Maximum tokens for the summary (default: 200)
    
    Returns:
        A concise 2-3 sentence summary in Vietnamese, or None if generation fails
    
    Example:
        >>> summary = await summarize_news_content(
        ...     title="Lợi ích của yoga cho bà bầu",
        ...     content="Yoga là môn thể thao nhẹ nhàng..."
        ... )
        >>> print(summary)
        "Yoga giúp bà bầu giảm căng thẳng, cải thiện sức khỏe..."
    """
    if not content or len(content.strip()) < 20:
        # Content too short to summarize
        return None
    
    try:
        llm_client = get_llm_client()
        
        # Prepare the user message with article content
        user_message = f"""Tiêu đề: {title}

Nội dung:
{content}

Hãy tóm tắt bài viết trên thành 2-3 câu ngắn gọn bằng tiếng Việt."""
        
        messages = [
            LLMMessage(role="system", content=SUMMARIZATION_PROMPT),
            LLMMessage(role="user", content=user_message),
        ]
        
        # Generate summary
        summary = await llm_client.generate(
            messages=messages,
            max_tokens=max_tokens,
            temperature=0.5,  # Lower temperature for more focused summaries
        )
        
        # Clean up the summary
        summary = summary.strip()
        
        # Validate summary
        if not summary or len(summary) < 10:
            print(f"⚠️  Generated summary too short: {summary}")
            return None
        
        return summary
        
    except Exception as e:
        print(f"❌ Error generating summary: {e}")
        # Return None on error - the news creation should still succeed
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
