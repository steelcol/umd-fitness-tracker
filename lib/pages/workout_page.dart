import 'package:BetaFitness/arguments/workout_arguments.dart';
import 'package:BetaFitness/arguments/workout_view_arguments.dart';
import 'package:BetaFitness/storage/workout_exercise_storage.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key, 
  required this.storage,
  required this.info
  }) : super(key: key);

  final SingletonStorage storage;
  final WorkoutInformation info;

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  final WorkoutController _workoutController = new WorkoutController();
  void addWorkout(List<SavedExercise> createdWorkout, String workoutName) async { 
    await _workoutController.addWeightWorkout(createdWorkout, workoutName);   
  }

  void updateList() async {
    // Updates the page when the list of workouts is changed
    await widget.storage.updateWeightData();
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
                itemCount: widget.storage.weightWorkouts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              savedWorkoutViewPageRoute,
                              arguments: WorkoutViewArguments(
                                workout: widget.storage.weightWorkouts[index]        
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                               child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.storage.weightWorkouts[index].workoutName)
                                    ],
                                  ),
                                ],
                               )
                              ),
                              IconButton(
                                onPressed: () {
                                  _workoutController.deleteWeightWorkout(widget.storage.weightWorkouts[index]);
                                  updateList();
                                },
                                icon: Icon(Icons.delete)
                              ),
                            ]
                          ),
                        )
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
        onPressed: () {
          Navigator.pushNamed(
          context,
            createWorkoutRoute,
            arguments: WorkoutArguments(
                updateList: updateList,
                addWorkout: addWorkout,
                info: widget.info
            )
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text('Create a workout',
          style: TextStyle(
            color: Colors.white,
            ),
          ),
      ),
    );
  }
}
