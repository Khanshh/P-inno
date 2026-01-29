from pydantic import BaseModel

class DailyTipResponse(BaseModel):
    title: str
    content: str

    class Config:
        from_attributes = True
