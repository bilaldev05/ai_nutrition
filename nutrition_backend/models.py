from pydantic import BaseModel

class UserProfile(BaseModel):
    name: str
    age: int
    weight: float
    height: float
    activity_level: str
    diet_preference: str
    health_condition: str
    goal: str  # 'lose', 'maintain', 'gain'