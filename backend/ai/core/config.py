from dataclasses import dataclass
import os
from pathlib import Path

# Load .env file if it exists
from dotenv import load_dotenv

# Try to load .env from backend directory
env_path = Path(__file__).parent.parent.parent / ".env"
if env_path.exists():
    load_dotenv(env_path, override=True)
else:
    # Fallback: try current directory
    load_dotenv(override=True)


@dataclass
class AISettings:
    """
    AI-specific configuration.

    For now we keep it simple and read from environment variables.
    This can be migrated to Pydantic BaseSettings later if needed.
    """

    PROVIDER: str = os.getenv("AI_PROVIDER", "mock")  # e.g. "openai", "gemini"
    MODEL_NAME: str = os.getenv("AI_MODEL_NAME", "gpt-4.1-mini")
    MAX_TOKENS: int = int(os.getenv("AI_MAX_TOKENS", "512"))
    TEMPERATURE: float = float(os.getenv("AI_TEMPERATURE", "0.7"))

    # OpenAI specific
    OPENAI_API_KEY: str | None = os.getenv("OPENAI_API_KEY")
    OPENAI_BASE_URL: str | None = os.getenv(
        "OPENAI_BASE_URL",  # optional, for custom endpoints / proxies
    )


ai_settings = AISettings()


def get_openai_api_key() -> str | None:
    """
    Read OPENAI_API_KEY from environment at call time.

    This helps when .env is loaded after module import or when env vars change
    between reloads. Also strips surrounding quotes and whitespace.
    """
    raw = os.getenv("OPENAI_API_KEY")
    if not raw:
        return None
    key = raw.strip()
    if (key.startswith('"') and key.endswith('"')) or (key.startswith("'") and key.endswith("'")):
        key = key[1:-1].strip()
    return key or None


