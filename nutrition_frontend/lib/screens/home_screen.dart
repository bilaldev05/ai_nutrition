import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  String activityLevel = 'medium';
  String dietPreference = 'veg';
  String healthCondition = 'none';
  String goal = 'maintain';

  Map<String, dynamic>? result;
  bool isLoading = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await ApiService.getRecommendation({
      "name": nameController.text,
      "age": int.parse(ageController.text),
      "weight": double.parse(weightController.text),
      "height": double.parse(heightController.text),
      "activity_level": activityLevel,
      "diet_preference": dietPreference,
      "health_condition": healthCondition,
      "goal": goal,
    });

    setState(() {
      result = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: const Text('AI Nutrition Advisor'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _headerSection(),

            const SizedBox(height: 20),

            // Form Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Enter Your Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeColor),
                      ),
                      const SizedBox(height: 20),
                      _inputField(nameController, 'Name', icon: Icons.person),
                      _inputField(ageController, 'Age', isNumber: true, icon: Icons.cake),
                      _inputField(weightController, 'Weight (kg)', isNumber: true, icon: Icons.monitor_weight),
                      _inputField(heightController, 'Height (cm)', isNumber: true, icon: Icons.height),
                      const SizedBox(height: 12),
                      _dropdown('Activity Level', activityLevel, ['low', 'medium', 'high'], (val) => setState(() => activityLevel = val), icon: Icons.directions_run),
                      _dropdown('Diet Preference', dietPreference, ['veg', 'non-veg'], (val) => setState(() => dietPreference = val), icon: Icons.restaurant),
                      _dropdown('Health Condition', healthCondition, ['none', 'diabetes', 'hypertension'], (val) => setState(() => healthCondition = val), icon: Icons.health_and_safety),
                      _dropdown('Goal', goal, ['lose', 'maintain', 'gain'], (val) => setState(() => goal = val), icon: Icons.flag),
                      const SizedBox(height: 20),
                      _submitButton(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Result Section
            if (result != null) _resultCard(),

            // Placeholder for weekly summary or charts
            const SizedBox(height: 24),
            if (result != null)
              _weeklyPlanPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
          ),
          SizedBox(height: 12),
          Text(
            'Welcome to AI Nutrition Advisor',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Get your personalized meal plan and health insights',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label, {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.deepPurple), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, Function(String) onChanged, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => onChanged(val!),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.deepPurple), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : submit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Get Recommendation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _resultCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Your Personalized Nutrition Plan',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _resultItem('BMI', '${result!['bmi']}'),
            _resultItem('Status', '${result!['bmi_status']}'),
            _resultItem('Daily Calories', '${result!['daily_calories']} kcal'),
            _resultItem('Goal', '${result!['goal']}'),

            const Divider(height: 30, thickness: 1.5),

            Text('Recommendation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 8),
            Text(result!['recommendation'], style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 12),
            Text('Meals:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            ...List<Widget>.from(result!['meals'].map((m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $m', style: const TextStyle(fontSize: 14)),
                ))),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _weeklyPlanPlaceholder() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.deepPurple[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Text('Weekly Plan (Coming Soon)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            SizedBox(height: 8),
            Text('Get your personalized 7-day meal plan and track your calories & macros daily.'),
          ],
        ),
      ),
    );
  }
}