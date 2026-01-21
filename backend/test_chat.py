#!/usr/bin/env python3
"""
Quick test script for the chat API.

Usage:
    python test_chat.py
"""

import asyncio
import json
from ai.features.chat_assistant.service import generate_chat_reply
from ai.features.chat_assistant.schemas import ChatRequest, ChatMessage


async def test_chat():
    """Test the chat endpoint."""
    print("🤖 Testing Chat Assistant...")
    print("-" * 50)

    # Test 1: Simple chat without RAG
    print("\n📝 Test 1: Simple chat (no RAG)")
    request1 = ChatRequest(
        messages=[
            ChatMessage(role="user", content="Chào bạn, bạn có thể giúp gì cho tôi?")
        ],
        use_rag=False,
    )
    response1 = await generate_chat_reply(request1)
    print(f"User: {request1.messages[0].content}")
    print(f"Assistant: {response1.reply.content}")
    print(f"Session ID: {response1.session_id}")

    # Test 2: Chat with conversation history
    print("\n📝 Test 2: Chat with conversation history")
    request2 = ChatRequest(
        messages=[
            ChatMessage(role="user", content="Xin chào!"),
            ChatMessage(role="assistant", content="Chào bạn! Tôi có thể giúp gì?"),
            ChatMessage(role="user", content="Bạn có thể tư vấn về sức khỏe không?"),
        ],
        use_rag=False,
        session_id="test-session-123",
    )
    response2 = await generate_chat_reply(request2)
    print(f"User: {request2.messages[-1].content}")
    print(f"Assistant: {response2.reply.content}")
    print(f"Session ID: {response2.session_id}")

    print("\n" + "=" * 50)
    print("✅ All tests completed!")
    print("\n💡 Note: If you see mock responses, that's normal.")
    print("   Set a valid OPENAI_API_KEY in .env to use real AI.")


if __name__ == "__main__":
    asyncio.run(test_chat())

