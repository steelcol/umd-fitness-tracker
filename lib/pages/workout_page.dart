import 'package:BetaFitness/arguments/create_workout_arguments.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  final WorkoutController _workoutController = new WorkoutController();

  void updateList() async {
    // Updates the page when the list of workouts is changed
    await widget.storage.updateRunData();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.storage.runningWorkouts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/8,
                      child: Card(
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.storage.runningWorkouts[index].workoutName),
                                Text(widget.storage.runningWorkouts[index].distance.toString()),

                              ],
                            ),
                            IconButton(
                              onPressed: () =>
                                  _workoutController.removeRunningWorkout(index),
                              icon: Icon(Icons.delete)
                            ),
                          ]
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // Dialog to select the workout type and navigate to that page
        onPressed: () async {
          await showDialog(context: context,
              builder: (context) => AlertDialog(
                title: const Text("Select Workout Type"),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height/5,
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            final args = CreateWorkoutArguments(
                                pageType: 'cardio',
                                updateList: updateList
                            );
                            Navigator.pushNamed(
                              context, 
                              createWorkoutRoute, 
                              arguments: args);
                          },
                          child: const Text("Cardio",
                            style: TextStyle(
                              fontSize: 30
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width/1, MediaQuery.of(context).size.height/15),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
          );
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Add Workout",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
