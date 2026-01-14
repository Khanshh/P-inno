import os
from typing import List


class Settings:
    """Central application settings.

    In a real project, you might want to load these values from environment
    variables or a `.env` file (using `python-dotenv` or Pydantic's BaseSettings).
    For the hackathon we keep it simple but flexible.
    """

    PROJECT_NAME: str = "Hackathon Backend API"
    API_V1_PREFIX: str = "/api/v1"

    # CORS origins – for now we allow all, but this can be restricted later.
    BACKEND_CORS_ORIGINS: List[str] = [
        os.getenv("CORS_ORIGIN", "*"),
    ]

    # Mock auth configuration
    MOCK_ACCESS_TOKEN: str = os.getenv("MOCK_ACCESS_TOKEN", "mock-access-token")


settings = Settings()



