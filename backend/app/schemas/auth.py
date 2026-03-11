from pydantic import BaseModel


class LoginRequest(BaseModel):
    username: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class LoginResponse(BaseModel):
    token: TokenResponse
    user_full_name: str
    patient_code: str
    role: str

class RegisterRequest(BaseModel):
    fullname: str
    username: str
    password: str
    phone: str
    gender: str = ""
    dob: str = ""
    email: str = ""
