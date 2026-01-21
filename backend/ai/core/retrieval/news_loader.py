"""
Utility to load news articles into the vector store for RAG.

This module provides functions to index news articles so they can be retrieved
during RAG-based chat conversations.
"""

from typing import List

from app.models.news import News
from .retriever import get_retriever
from .vector_store import Document


async def load_news_into_vector_store(news_list: List[News]) -> int:
    """
    Load news articles into the vector store.

    Args:
        news_list: List of News objects to index

    Returns:
        Number of documents successfully indexed
    """
    retriever = get_retriever()

    # Convert News objects to Document objects
    documents: List[Document] = []
    for news in news_list:
        # Combine title, description, and content for better retrieval
        content_parts = [news.title]
        if news.description:
            content_parts.append(news.description)
        if news.content:
            content_parts.append(news.content)

        full_content = "\n\n".join(content_parts)

        doc = Document(
            id=f"news-{news.id}",
            content=full_content,
            metadata={
                "source": "news",
                "news_id": news.id,
                "title": news.title,
                "category": news.category or "",
            },
        )
        documents.append(doc)

    # Add documents to vector store (embeddings will be generated automatically)
    await retriever.add_documents(documents)

    return len(documents)


async def reload_news_from_mock_data() -> int:
    """
    Helper function to reload news from mock data.

    This is useful for development. In production, you'd load from database.
    """
    from app.api.v1.routes_news import _mock_news

    # Clear existing documents
    retriever = get_retriever()
    await retriever.clear()

    # Load news articles
    count = await load_news_into_vector_store(_mock_news)
    return count

