"""
Retrieval components for RAG (Retrieval-Augmented Generation).

This module provides:
- VectorStore: Storage and similarity search for document embeddings
- Retriever: High-level retrieval logic that combines embeddings and vector search
"""

from .vector_store import BaseVectorStore, InMemoryVectorStore, Document
from .retriever import Retriever, get_retriever

__all__ = [
    "BaseVectorStore",
    "InMemoryVectorStore",
    "Document",
    "Retriever",
    "get_retriever",
]

