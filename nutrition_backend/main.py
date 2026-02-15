from fastapi import FastAPI
from models import UserProfile
from database import users_collection
from ai_engine import generate_nutrition_plan
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # for development only
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/recommend")
def recommend_nutrition(user: UserProfile):
    nutrition_plan = generate_nutrition_plan(user)
    users_collection.insert_one({
        **user.dict(),
        "plan": nutrition_plan
    })
    return nutrition_plan

# python -m uvicorn main:app --reload