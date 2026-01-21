from abc import ABC, abstractmethod
import os
from typing import List

from ..config import ai_settings


class BaseEmbeddingsClient(ABC):
    """Abstract base for embeddings clients."""

    @abstractmethod
    async def embed_text(self, text: str) -> List[float]:
        """Generate embedding for a single text."""
        ...

    @abstractmethod
    async def embed_batch(self, texts: List[str]) -> List[List[float]]:
        """Generate embeddings for multiple texts."""
        ...


class OpenAIEmbeddingsClient(BaseEmbeddingsClient):
    """
    OpenAI implementation of the embeddings client.

    Uses the official `openai` Python SDK with the Embeddings API.
    """

    def __init__(self) -> None:
        from openai import AsyncOpenAI  # type: ignore

        if not ai_settings.OPENAI_API_KEY:
            raise RuntimeError(
                "OPENAI_API_KEY is not set. Please configure it before using OpenAI embeddings.",
            )

        client_kwargs = {"api_key": ai_settings.OPENAI_API_KEY}
        if ai_settings.OPENAI_BASE_URL:
            client_kwargs["base_url"] = ai_settings.OPENAI_BASE_URL

        self._client = AsyncOpenAI(**client_kwargs)
        # Use text-embedding-3-small by default (cheaper and good quality)
        self._model = os.getenv("AI_EMBEDDINGS_MODEL", "text-embedding-3-small")

    async def embed_text(self, text: str) -> List[float]:
        """Generate embedding for a single text."""
        response = await self._client.embeddings.create(
            model=self._model,
            input=text,
        )
        return response.data[0].embedding

    async def embed_batch(self, texts: List[str]) -> List[List[float]]:
        """Generate embeddings for multiple texts."""
        response = await self._client.embeddings.create(
            model=self._model,
            input=texts,
        )
        return [item.embedding for item in response.data]


class MockEmbeddingsClient(BaseEmbeddingsClient):
    """
    Mock embeddings client for development/testing.

    Returns random embeddings of dimension 1536 (same as OpenAI text-embedding-3-small).
    """

    def __init__(self, dimension: int = 1536) -> None:
        self._dimension = dimension

    async def embed_text(self, text: str) -> List[float]:
        """Generate mock embedding."""
        import random

        # Simple hash-based "embedding" for consistency
        random.seed(hash(text) % 2**32)
        return [random.random() for _ in range(self._dimension)]

    async def embed_batch(self, texts: List[str]) -> List[List[float]]:
        """Generate mock embeddings for multiple texts."""
        return [await self.embed_text(text) for text in texts]


def get_embeddings_client() -> BaseEmbeddingsClient:
    """
    Factory to return the appropriate embeddings client.

    Uses the same provider as LLM client for consistency.
    """
    if ai_settings.PROVIDER == "openai":
        return OpenAIEmbeddingsClient()

    # Default / fallback to mock client
    return MockEmbeddingsClient()

