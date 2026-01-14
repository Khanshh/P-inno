## FastAPI Backend for Hackathon App

This folder contains a minimal but production-ready **FastAPI** backend that can be
connected to the existing Flutter frontend app.

### 1. Quick start

```bash
cd "/home/khanshhh/Documents/Code/Hackathon/(P-inno)/backend"
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Run the API server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

### 2. Main endpoints (v1)

All versioned endpoints are under the prefix: `/api/v1`

- **Health check**
  - `GET /health`

- **Auth**
  - `POST /api/v1/auth/login`
    - Body: `{ "username": "...", "password": "..." }`
    - Returns a **fake token** and mock user profile for now.

- **Profile**
  - `GET /api/v1/profile/me`
    - Header: `Authorization: Bearer <token>`
    - Returns the mock profile associated with that token.

- **Medical Records**
  - `GET /api/v1/medical-records`
    - Header: `Authorization: Bearer <token>`
    - Returns a list of mock medical records.

These mock endpoints are designed so the Flutter app can start integrating
network calls immediately, and can be replaced later with real database logic.

### 3. CORS (for Flutter Web / Mobile)

The backend is configured with permissive CORS so that both **mobile** and
**web** versions of the Flutter app can call the API without issues during
development.

You can restrict allowed origins later inside `app/main.py`.

### 4. Project structure

```text
backend/
  requirements.txt
  README.md
  app/
    __init__.py
    main.py
    core/
      __init__.py
      config.py
    api/
      __init__.py
      v1/
        __init__.py
        routes_auth.py
        routes_profile.py
        routes_medical_records.py
    schemas/
      __init__.py
      auth.py
      user.py
      medical_record.py
    models/
      __init__.py
      user.py
      medical_record.py
```

The current implementation uses **in-memory mock data only** (no database),
which is enough for demos and hackathon usage. You can later:

- Plug in a real database (PostgreSQL, MySQL, etc.) using SQLModel / SQLAlchemy.
- Replace the mock auth logic with JWT or OAuth2.
- Add more endpoints under `app/api/v1`.



