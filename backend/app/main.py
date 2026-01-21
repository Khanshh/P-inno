from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pathlib import Path
import os
from dotenv import load_dotenv

# Load .env file from backend directory
env_path = Path(__file__).parent.parent / ".env"
if env_path.exists():
    load_dotenv(env_path, override=True)
else:
    # Fallback: try current directory
    load_dotenv(override=True)

from app.api.v1.routes_auth import router as auth_router
from app.api.v1.routes_profile import router as profile_router
from app.api.v1.routes_medical_records import router as medical_records_router
from app.api.v1.routes_home import router as home_router
from app.api.v1.routes_news import router as news_router
from app.api.v1.routes_discover import router as discover_router
from app.api.v1.routes_ai_chat import router as ai_chat_router
from app.core.config import settings


def create_app() -> FastAPI:
    """
    Application factory.

    This keeps the setup clean and makes it easier to test or create
    multiple application instances if needed.
    """
    app = FastAPI(
        title="ENA Backend API",
        description="FastAPI backend for the fertility/medical Flutter app.",
        version="1.0.0",
    )

    # CORS configuration
    # For ENA / development we allow all origins.
    # You can restrict this later by editing `settings.BACKEND_CORS_ORIGINS`.
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.BACKEND_CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Health check
    @app.get("/health", tags=["system"])
    async def health_check() -> dict:
        return {"status": "ok", "service": "ENA-backend"}

    # Startup: Load news articles into vector store for RAG
    @app.on_event("startup")
    async def startup_load_news() -> None:
        """
        Load news articles into the vector store on startup.

        This enables RAG functionality for the chat assistant.
        Only loads if OpenAI API key is valid (needed for embeddings).
        """
        # Allow disabling RAG indexing entirely (default off)
        enable_rag = os.getenv("AI_ENABLE_RAG", "false").strip().lower() in ("1", "true", "yes", "on")
        if not enable_rag:
            print("ℹ️  RAG indexing disabled (AI_ENABLE_RAG=false). Skipping vector store loading.")
            return

        try:
            from ai.core.config import ai_settings, get_openai_api_key
            from ai.core.clients.llm_client import is_valid_openai_key
            
            # Only load if we have a valid OpenAI API key (needed for embeddings)
            if not is_valid_openai_key(get_openai_api_key()):
                print(
                    "ℹ️  Skipping RAG news loading: OpenAI API key not configured or invalid. "
                    "Chatbot will work without RAG."
                )
                return
            
            from ai.core.retrieval.news_loader import reload_news_from_mock_data

            count = await reload_news_from_mock_data()
            print(f"✅ Loaded {count} news articles into vector store for RAG")
        except Exception as e:
            print(f"⚠️  Warning: Could not load news into vector store: {e}")
            print("   Chatbot will still work, but RAG is disabled.")

    # API v1 routers
    app.include_router(auth_router, prefix="/api/v1", tags=["auth"])
    app.include_router(profile_router, prefix="/api/v1", tags=["profile"])
    app.include_router(
        medical_records_router,
        prefix="/api/v1",
        tags=["medical-records"],
    )
    app.include_router(home_router, prefix="/api/v1", tags=["home"])
    app.include_router(news_router, prefix="/api/v1", tags=["news"])
    app.include_router(discover_router, prefix="/api/v1", tags=["discover"])
    app.include_router(ai_chat_router, prefix="/api/v1", tags=["ai-chat"])

    return app


app = create_app()



