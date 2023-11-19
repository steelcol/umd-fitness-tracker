import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:BetaFitness/arguments/run_workout_arguments.dart';
import 'package:flutter/material.dart';

class RunWorkoutPage extends StatefulWidget {
  RunWorkoutPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  @override
  State<RunWorkoutPage> createState() => _RunWorkoutPageState();
}

class _RunWorkoutPageState extends State<RunWorkoutPage> {
  final WorkoutController _workoutController = new WorkoutController();

  void updateList() async {
    // Updates the page when the list of logged runs is changed
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
        title: const Text('BetaFitness'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
             child: const Text(
               'Logged Runs',
               style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.bold,
               ),
             ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.storage.runningWorkouts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: SizedBox(
                        height: 80,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(widget.storage
                                            .runningWorkouts[index].workoutName)
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(widget.storage
                                                .runningWorkouts[index].distance
                                                .toString() +
                                            " miles"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _workoutController.deleteRunningWorkout(
                                      widget.storage.runningWorkouts[index]
                                    );
                                        updateList();
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
                context,
                logRunPageRoute,
                arguments: RunWorkoutArguments(updateList: updateList)
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text('Log a run',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
    );
  }
}
