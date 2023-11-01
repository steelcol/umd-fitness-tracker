import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This page more than likely will need to be split up
class CreateWorkoutPage extends StatefulWidget {
  CreateWorkoutPage({Key? key,
    required this.pageType,
    required  this.controller,
    required this.updateList})
      : super(key: key);

  final String pageType;
  final WorkoutController controller;
  final Function updateList;

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  // Key for our form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _runningNameController = new TextEditingController();
  final TextEditingController _distanceController = new TextEditingController();

  // Holds our text fields for our weight training form
  List<Exercise> exercises = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.pageType) {
      case 'cardio':
        return Scaffold(
          appBar: AppBar(
            title: const Text("BetaFitness"),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    controller: _runningNameController,
                      decoration: const InputDecoration(
                        labelText: "Workout Name",
                        hintText: "Enter name of your workout",
                      ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a workout name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _distanceController,
                    decoration: const InputDecoration(
                      labelText: "Distance",
                      hintText: "Enter your desired distance",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a distance';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Submit to database here for the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                         // Create new object and send to database
                        RunningWorkout workout = new RunningWorkout(
                            workoutName: _runningNameController.text,
                            distance: double.parse(_distanceController.text)
                        );
                        await widget.controller.addRunningWorkout(workout);
                        await widget.updateList();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Create Workout"),
                  )
                ],
              ),
            ),
          ),
        );
      case 'weight_train':
        return Scaffold(
          appBar: AppBar(
            title: const Text("BetaFitness"),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: TextFormField(
                                          controller: exercises[index].exerciseNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Exercise',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter exercise name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: exercises[index].setAmountController,
                                          decoration: InputDecoration(
                                            hintText: 'Sets',
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter set count';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: exercises[index].repAmountController,
                                          decoration: InputDecoration(
                                            hintText: 'Reps',
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter rep count';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                              )
                          );
                        }),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      // Add another entry to the list
                      setState(() {
                        exercises.add(Exercise(
                            exerciseNameController: new TextEditingController(),
                            setAmountController: new TextEditingController(),
                            repAmountController: new TextEditingController()
                        )
                        );
                      });
                    },
                    child: const Text("Add Exercise"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && exercises.length != 0) {
                        // Submit to database here for the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text("Create Workout"),
                  )
                ],
              ),
            ),
          ),
        );
      default:
        return Scaffold(
            // We should never get here
            );
    }
  }
}

class Exercise {
  TextEditingController exerciseNameController = new TextEditingController();
  TextEditingController setAmountController = new TextEditingController();
  TextEditingController repAmountController = new TextEditingController();

  Exercise({
    required this.exerciseNameController,
    required this.setAmountController,
    required this.repAmountController
  });
}
