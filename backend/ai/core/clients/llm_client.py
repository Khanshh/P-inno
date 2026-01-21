from abc import ABC, abstractmethod
from typing import List, Optional

from ..config import ai_settings, get_openai_api_key


class LLMMessage(dict):
    """
    Simple dict-based message structure to avoid extra dependencies.

    Keys:
    - role: "system" | "user" | "assistant"
    - content: message content
    """

    role: str
    content: str


class BaseLLMClient(ABC):
    """Abstract base for LLM clients."""

    @abstractmethod
    async def generate(
        self,
        messages: List[LLMMessage],
        *,
        max_tokens: Optional[int] = None,
        temperature: Optional[float] = None,
    ) -> str:
        ...


class MockLLMClient(BaseLLMClient):
    """
    Very simple mock client for development.

    This allows you to test the API without configuring a real provider yet.
    """

    async def generate(
        self,
        messages: List[LLMMessage],
        *,
        max_tokens: Optional[int] = None,
        temperature: Optional[float] = None,
    ) -> str:
        user_message = next(
            (m["content"] for m in reversed(messages) if m.get("role") == "user"),
            "",
        )
        return (
            "🤖 (MOCK AI) Mình đã nhận được tin nhắn của bạn: "
            f'"{user_message}". Khi tích hợp provider thật, câu trả lời sẽ thông minh hơn nhé!'
        )


class OpenAILLMClient(BaseLLMClient):
    """
    OpenAI implementation of the LLM client.

    Uses the official `openai` Python SDK (v1.x) with the Chat Completions API.
    """

    def __init__(self) -> None:
        from openai import AsyncOpenAI  # type: ignore

        api_key = get_openai_api_key()
        if not api_key:
            raise RuntimeError(
                "OPENAI_API_KEY is not set. Please configure it before using OpenAI provider.",
            )

        client_kwargs = {"api_key": api_key}
        if ai_settings.OPENAI_BASE_URL:
            client_kwargs["base_url"] = ai_settings.OPENAI_BASE_URL

        self._client = AsyncOpenAI(**client_kwargs)

    async def generate(
        self,
        messages: List[LLMMessage],
        *,
        max_tokens: Optional[int] = None,
        temperature: Optional[float] = None,
    ) -> str:
        req_messages = [{"role": m["role"], "content": m["content"]} for m in messages]
        req_temperature = temperature if temperature is not None else ai_settings.TEMPERATURE
        req_max = max_tokens if max_tokens is not None else ai_settings.MAX_TOKENS

        # Newer OpenAI models (gpt-4o, o1, o3, etc.) require `max_completion_tokens`
        # Older models (gpt-3.5-turbo, gpt-4, etc.) use `max_tokens`
        model_name = ai_settings.MODEL_NAME.lower()
        use_max_completion_tokens = any([
            "gpt-4o" in model_name,
            "o1" in model_name,
            "o3" in model_name,
            model_name.startswith("gpt-4o"),
        ])

        try:
            if use_max_completion_tokens:
                response = await self._client.chat.completions.create(
                    model=ai_settings.MODEL_NAME,
                    messages=req_messages,
                    max_completion_tokens=req_max,
                    temperature=req_temperature,
                )
            else:
                response = await self._client.chat.completions.create(
                    model=ai_settings.MODEL_NAME,
                    messages=req_messages,
                    max_tokens=req_max,
                    temperature=req_temperature,
                )
        except Exception as e:
            # If we got it wrong, try the opposite parameter
            error_msg = str(e)
            if "max_tokens" in error_msg or "max_completion_tokens" in error_msg:
                try:
                    if use_max_completion_tokens:
                        # Try with max_tokens instead
                        response = await self._client.chat.completions.create(
                            model=ai_settings.MODEL_NAME,
                            messages=req_messages,
                            max_tokens=req_max,
                            temperature=req_temperature,
                        )
                    else:
                        # Try with max_completion_tokens instead
                        response = await self._client.chat.completions.create(
                            model=ai_settings.MODEL_NAME,
                            messages=req_messages,
                            max_completion_tokens=req_max,
                            temperature=req_temperature,
                        )
                except Exception as e2:
                    raise RuntimeError(f"OpenAI API call failed: {e2}") from e2
            else:
                raise RuntimeError(f"OpenAI API call failed: {e}") from e

        choice = response.choices[0]
        content = choice.message.content or ""
        return content


def is_valid_openai_key(api_key: str | None) -> bool:
    """Check if OpenAI API key looks valid (best-effort)."""
    if not api_key:
        return False

    key = api_key.strip()
    # Remove surrounding quotes if user put OPENAI_API_KEY="sk-..."
    if (key.startswith('"') and key.endswith('"')) or (key.startswith("'") and key.endswith("'")):
        key = key[1:-1].strip()

    # Common placeholders
    lowered = key.lower()
    if lowered.startswith("sk-xxx") or "replace_me" in lowered or "replace" in lowered:
        return False

    # OpenAI keys typically start with sk- (including sk-proj-*)
    if not key.startswith("sk-"):
        return False

    # Very small sanity check on length
    return len(key) >= 20


def get_llm_client() -> BaseLLMClient:
    """
    Factory to return the appropriate LLM client.

    For now we support:
    - mock: MockLLMClient (default)
    - openai: OpenAILLMClient (falls back to mock if API key invalid)
    """
    if ai_settings.PROVIDER == "openai":
        api_key = get_openai_api_key()
        if not is_valid_openai_key(api_key):
            print(
                "⚠️  Warning: OpenAI API key is invalid or missing. "
                "Falling back to MockLLMClient. "
                "Please set a valid OPENAI_API_KEY in .env file."
            )
            # Helpful (safe) debug: don't print the key, only metadata
            if api_key:
                print(
                    f"   Debug: OPENAI_API_KEY length={len(api_key)}, prefix={api_key[:7]}..., startswith_sk={api_key.startswith('sk-')}"
                )
            else:
                print("   Debug: OPENAI_API_KEY is empty / not loaded into process env.")
            return MockLLMClient()
        try:
            return OpenAILLMClient()
        except Exception as e:
            print(
                f"⚠️  Warning: Failed to initialize OpenAI client: {e}. "
                "Falling back to MockLLMClient."
            )
            return MockLLMClient()

    # Default / fallback to mock client
    return MockLLMClient()


