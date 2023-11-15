import 'package:BetaFitness/controllers/active_workout_controller.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';

class ActiveWorkoutPage extends StatefulWidget {
  ActiveWorkoutPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;
  final ActiveWorkoutController controller = ActiveWorkoutController();

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  @override
  void initState() {
    // TODO: initialize your data or perform any necessary actions
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Workout"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // TODO: Implement user profile action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Implement the components for the active workout page
            // For example, you can have a timer, progress tracker, etc.

            // Placeholder for Active Workout Components
            Text(
              'Active Workout Components',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // TODO: Add components like timer, progress tracker, etc.

            SizedBox(height: 20.0),

            // Placeholder for Exercise List
            Text(
              'Exercise List',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with the actual number of exercises
                itemBuilder: (context, index) {
                  // TODO: Create a widget to display each exercise in the list
                  return ListTile(
                    title: Text('Exercise $index'),
                    // Add more details as needed
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement actions when the user completes the workout
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text('Finish Workout'),
        ),
      ),
    );
  }
}
