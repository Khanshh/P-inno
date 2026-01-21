from typing import List, Optional

from .vector_store import BaseVectorStore, Document, InMemoryVectorStore
from ..clients.embeddings_client import get_embeddings_client


class Retriever:
    """
    High-level retriever that combines embeddings and vector search.

    This is the main interface for RAG retrieval operations.
    """

    def __init__(
        self,
        vector_store: Optional[BaseVectorStore] = None,
    ) -> None:
        """
        Initialize the retriever.

        Args:
            vector_store: Optional vector store instance. If None, uses InMemoryVectorStore.
        """
        self._vector_store = vector_store or InMemoryVectorStore()
        self._embeddings_client = get_embeddings_client()

    async def add_documents(self, documents: List[Document]) -> None:
        """
        Add documents to the vector store and generate embeddings if needed.

        Args:
            documents: List of documents to add. If embeddings are not provided,
                      they will be generated automatically.
        """
        # Generate embeddings for documents that don't have them
        docs_to_embed = [doc for doc in documents if not doc.embedding]
        if docs_to_embed:
            texts = [doc.content for doc in docs_to_embed]
            embeddings = await self._embeddings_client.embed_batch(texts)
            for doc, embedding in zip(docs_to_embed, embeddings):
                doc.embedding = embedding

        await self._vector_store.add_documents(documents)

    async def retrieve(
        self,
        query: str,
        top_k: int = 5,
        filter_metadata: Optional[dict] = None,
    ) -> List[Document]:
        """
        Retrieve relevant documents for a query.

        Args:
            query: The search query text
            top_k: Number of top results to return
            filter_metadata: Optional metadata filters

        Returns:
            List of relevant documents sorted by similarity
        """
        # Generate query embedding
        query_embedding = await self._embeddings_client.embed_text(query)

        # Search vector store
        results = await self._vector_store.similarity_search(
            query_embedding,
            top_k=top_k,
            filter_metadata=filter_metadata,
        )

        return results

    async def clear(self) -> None:
        """Clear all documents from the vector store."""
        await self._vector_store.clear()


# Global retriever instance (singleton pattern)
_retriever: Optional[Retriever] = None


def get_retriever() -> Retriever:
    """
    Get or create the global retriever instance.

    This ensures we reuse the same vector store across requests.
    """
    global _retriever
    if _retriever is None:
        _retriever = Retriever()
    return _retriever

