## FastAPI Backend for ENA App

This folder contains a minimal but production-ready **FastAPI** backend (ENA backend)
that can be connected to the existing Flutter frontend app.

### 1. Quick start (API server)

```bash
cd "/home/khanshhh/Documents/Code/Hackathon/(P-inno)/backend"
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Run the API server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

### 2. Run PostgreSQL + pgAdmin with Docker (for later DB usage)

You can start a local PostgreSQL instance using Docker Compose:

```bash
cd "/home/khanshhh/Documents/Code/Hackathon/(P-inno)/backend"

# 1) Create your .env file (based on this example)
cat > .env << 'EOF'
POSTGRES_DB=ENA_db
POSTGRES_USER=ENA_user
POSTGRES_PASSWORD=ENA_password
POSTGRES_PORT=5432

DATABASE_URL=postgresql+psycopg2://ENA_user:ENA_password@postgres:5432/ENA_db
EOF

# 2) Start Postgres + pgAdmin in the background
docker compose up -d
```

Notes:
- PostgreSQL:
  - Database: `ENA_db`
  - User: `ENA_user`
  - Password: `ENA_password`
  - Port (host): `localhost:5432`
- pgAdmin:
  - URL: `http://localhost:5050`
  - Default email: `admin@ena.local`
  - Default password: `ena_admin`
- The FastAPI app currently uses **mock data only**, but it already has
  a `DATABASE_URL` setting (`settings.DATABASE_URL`) ready for when you
  start integrating a real database layer.

### 3. Main endpoints (v1)

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

### 4. CORS (for Flutter Web / Mobile)

The backend is configured with permissive CORS so that both **mobile** and
**web** versions of the Flutter app can call the API without issues during
development.

You can restrict allowed origins later inside `app/main.py`.

### 5. Project structure

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
which is enough for demos and ENA usage. You can later:

- Plug in a real database (PostgreSQL, MySQL, etc.) using SQLModel / SQLAlchemy.
- Replace the mock auth logic with JWT or OAuth2.
- Add more endpoints under `app/api/v1`.



