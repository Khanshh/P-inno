from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.routes_auth import router as auth_router
from app.api.v1.routes_profile import router as profile_router
from app.api.v1.routes_medical_records import router as medical_records_router
from app.core.config import settings


def create_app() -> FastAPI:
    """
    Application factory.

    This keeps the setup clean and makes it easier to test or create
    multiple application instances if needed.
    """
    app = FastAPI(
        title="Hackathon Backend API",
        description="FastAPI backend for the fertility/medical Flutter app.",
        version="1.0.0",
    )

    # CORS configuration
    # For hackathon / development we allow all origins.
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
        return {"status": "ok", "service": "hackathon-backend"}

    # API v1 routers
    app.include_router(auth_router, prefix="/api/v1", tags=["auth"])
    app.include_router(profile_router, prefix="/api/v1", tags=["profile"])
    app.include_router(
        medical_records_router,
        prefix="/api/v1",
        tags=["medical-records"],
    )

    return app


app = create_app()



