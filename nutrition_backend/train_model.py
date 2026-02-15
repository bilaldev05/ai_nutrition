import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import LabelEncoder
import joblib

# Sample training data (can be expanded)
data = {
    "age": [20, 25, 30, 35, 40],
    "weight": [55, 70, 80, 90, 100],
    "height": [160, 170, 175, 180, 185],
    "activity": ["low", "medium", "medium", "high", "high"],
    "calories": [1800, 2200, 2400, 2800, 3000]
}

df = pd.DataFrame(data)

# Encode activity level
encoder = LabelEncoder()
df["activity"] = encoder.fit_transform(df["activity"])

X = df[["age", "weight", "height", "activity"]]
y = df["calories"]

model = LinearRegression()
model.fit(X, y)

# Save model and encoder
joblib.dump(model, "calorie_model.pkl")
joblib.dump(encoder, "activity_encoder.pkl")

print("✅ ML model trained & saved")