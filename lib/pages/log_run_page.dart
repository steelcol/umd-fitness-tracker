import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:flutter/material.dart';

class LogRunPage extends StatelessWidget {
  LogRunPage({Key? key, required this.updateList}) : super(key: key);

  final Function updateList;

  final _formKey = GlobalKey<FormState>();
  final _runningNameController = new TextEditingController();
  final _distanceController = new TextEditingController();
  final controller = new WorkoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: _runningNameController,
                decoration: const InputDecoration(
                  labelText: "Workout Name",
                  hintText: "Give your run a unique name",
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please give your run a unique name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance',
                  hintText: 'Enter your distance in miles',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a distance in miles';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                 if (_formKey.currentState!.validate()) {
                   // Submit to database for the user
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Processing Data')),
                   );
                   // Create new object and send to database
                   RunningWorkout workout = new RunningWorkout(
                       workoutName: _runningNameController.text,
                       distance: double.parse(_distanceController.text)
                   );
                   await controller.addRunningWorkout(workout);
                   await updateList();
                   Navigator.pop(context);
                 }
                },
                child: const Text('Log Run'),
              )
            ],
          ),
        ),
      )
    );
  }
}