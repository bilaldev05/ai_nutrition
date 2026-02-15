import joblib

model = joblib.load("calorie_model.pkl")
encoder = joblib.load("activity_encoder.pkl")


def calculate_bmi(weight, height_cm):
    height_m = height_cm / 100
    bmi = weight / (height_m ** 2)

    if bmi < 18.5:
        status = "Underweight"
    elif bmi < 25:
        status = "Normal"
    elif bmi < 30:
        status = "Overweight"
    else:
        status = "Obese"

    return round(bmi, 2), status


def predict_calories_ml(user):
    activity_encoded = encoder.transform([user.activity_level])[0]

    calories = model.predict([[
        user.age,
        user.weight,
        user.height,
        activity_encoded
    ]])

    return int(calories[0])


def generate_nutrition_plan(user):
    # BMI & calories
    bmi, bmi_status = calculate_bmi(user.weight, user.height)
    calories = predict_calories_ml(user)

    # Adjust calories based on goal
    if user.goal == "lose":
        target_calories = int(calories * 0.8)  # 20% deficit
    elif user.goal == "gain":
        target_calories = int(calories * 1.2)  # 20% surplus
    else:
        target_calories = calories  # maintain

    # AI/Rule-Based diet recommendation
    plan = {
        "bmi": bmi,
        "bmi_status": bmi_status,
        "daily_calories": target_calories,
        "goal": user.goal
    }

    # Example logic based on health, goal, activity
    if user.health_condition == "diabetes":
        plan["recommendation"] = "Low sugar, high fiber diet"
        plan["meals"] = ["Oats breakfast", "Grilled Veggies lunch", "Salad dinner"]

    elif user.goal == "lose":
        plan["recommendation"] = "Calorie deficit, high protein & fiber"
        plan["meals"] = ["Salad breakfast", "Grilled Chicken lunch", "Vegetables dinner"]

    elif user.goal == "gain":
        plan["recommendation"] = "Calorie surplus, high protein & carbs"
        plan["meals"] = ["Oats + Milk breakfast", "Rice + Chicken lunch", "Pasta dinner"]

    elif user.activity_level == "high":
        plan["recommendation"] = "High protein diet"
        plan["meals"] = ["Eggs breakfast", "Chicken + Rice lunch", "Brown Rice dinner"]

    else:
        plan["recommendation"] = "Balanced diet"
        plan["meals"] = ["Rice + Veg lunch", "Vegetables + Fruits dinner", "Snacks healthy"]

    return plan