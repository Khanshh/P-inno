from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import List, Optional


@dataclass
class Document:
    """
    Represents a document stored in the vector store.

    Attributes:
        id: Unique identifier for the document
        content: The text content of the document
        metadata: Optional metadata (e.g., title, category, source_id)
        embedding: Optional pre-computed embedding vector
    """

    id: str
    content: str
    metadata: dict = None
    embedding: Optional[List[float]] = None

    def __post_init__(self):
        if self.metadata is None:
            self.metadata = {}


class BaseVectorStore(ABC):
    """Abstract base for vector stores."""

    @abstractmethod
    async def add_documents(self, documents: List[Document]) -> None:
        """Add documents to the vector store."""
        ...

    @abstractmethod
    async def similarity_search(
        self,
        query_embedding: List[float],
        top_k: int = 5,
        filter_metadata: Optional[dict] = None,
    ) -> List[Document]:
        """
        Search for similar documents using cosine similarity.

        Args:
            query_embedding: The embedding vector of the query
            top_k: Number of top results to return
            filter_metadata: Optional metadata filters (e.g., {"category": "Sức khỏe"})

        Returns:
            List of documents sorted by similarity (most similar first)
        """
        ...

    @abstractmethod
    async def clear(self) -> None:
        """Clear all documents from the vector store."""
        ...


class InMemoryVectorStore(BaseVectorStore):
    """
    Simple in-memory vector store using cosine similarity.

    Suitable for development and small datasets.
    For production, consider using pgvector, Pinecone, or Weaviate.
    """

    def __init__(self) -> None:
        self._documents: List[Document] = []

    async def add_documents(self, documents: List[Document]) -> None:
        """Add documents to the vector store."""
        self._documents.extend(documents)

    async def similarity_search(
        self,
        query_embedding: List[float],
        top_k: int = 5,
        filter_metadata: Optional[dict] = None,
    ) -> List[Document]:
        """Search for similar documents using cosine similarity."""
        if not self._documents:
            return []

        # Filter by metadata if provided
        candidates = self._documents
        if filter_metadata:
            candidates = [
                doc
                for doc in self._documents
                if all(
                    doc.metadata.get(k) == v for k, v in filter_metadata.items()
                )
            ]

        if not candidates:
            return []

        # Calculate cosine similarity
        def cosine_similarity(vec1: List[float], vec2: List[float]) -> float:
            if not vec1 or not vec2:
                return 0.0
            dot_product = sum(a * b for a, b in zip(vec1, vec2))
            norm1 = sum(a * a for a in vec1) ** 0.5
            norm2 = sum(b * b for b in vec2) ** 0.5
            if norm1 == 0 or norm2 == 0:
                return 0.0
            return dot_product / (norm1 * norm2)

        # Calculate similarities
        scored_docs = []
        for doc in candidates:
            if doc.embedding:
                similarity = cosine_similarity(query_embedding, doc.embedding)
                scored_docs.append((similarity, doc))

        # Sort by similarity (descending) and return top_k
        scored_docs.sort(key=lambda x: x[0], reverse=True)
        return [doc for _, doc in scored_docs[:top_k]]

    async def clear(self) -> None:
        """Clear all documents from the vector store."""
        self._documents.clear()

