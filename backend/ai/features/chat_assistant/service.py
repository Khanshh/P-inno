from typing import Optional, List

from .prompts import BASE_SYSTEM_PROMPT, build_rag_system_prompt
from .schemas import ChatRequest, ChatResponse, ChatMessage
from ...core.clients.llm_client import get_llm_client, LLMMessage
from ...core.retrieval import get_retriever


async def generate_chat_reply(payload: ChatRequest) -> ChatResponse:
    """
    Core business logic for the chat assistant feature.

    - If RAG is enabled, retrieves relevant documents and injects them into the prompt.
    - Builds a message list including a system prompt (with or without RAG context).
    - Delegates actual text generation to the LLM client.
    - Wraps the result into a ChatResponse.
    """
    llm = get_llm_client()

    # Get the last user message for RAG retrieval
    last_user_message = next(
        (msg.content for msg in reversed(payload.messages) if msg.role == "user"),
        "",
    )

    retrieved_context: Optional[List[str]] = None
    system_prompt = BASE_SYSTEM_PROMPT

    # RAG: Retrieve relevant documents if enabled
    if payload.use_rag and last_user_message:
        retriever = get_retriever()
        retrieved_docs = await retriever.retrieve(
            query=last_user_message,
            top_k=3,  # Get top 3 most relevant documents
        )

        if retrieved_docs:
            retrieved_context = [doc.content for doc in retrieved_docs]
            system_prompt = build_rag_system_prompt(retrieved_context)

    messages: list[LLMMessage] = [
        LLMMessage(role="system", content=system_prompt),
    ]

    # Append conversation history from client
    for msg in payload.messages:
        messages.append(LLMMessage(role=msg.role, content=msg.content))

    try:
        llm_reply: str = await llm.generate(messages)
    except Exception as e:
        # Fallback to mock if OpenAI fails
        from ...core.clients.llm_client import MockLLMClient
        
        print(f"⚠️  Warning: LLM generation failed: {e}. Falling back to MockLLMClient.")
        mock_llm = MockLLMClient()
        llm_reply = await mock_llm.generate(messages)

    reply_message = ChatMessage(role="assistant", content=llm_reply)

    # For now we simply echo back any provided session_id
    session_id: Optional[str] = payload.session_id

    return ChatResponse(
        reply=reply_message,
        session_id=session_id,
        retrieved_context=retrieved_context if payload.use_rag else None,
    )


