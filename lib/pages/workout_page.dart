import 'package:BetaFitness/utilities/create_workout_arguments.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';

import '../controllers/workout_controller.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // Handles all database related functionality
  late WorkoutController controller = new WorkoutController();
  bool _isLoading = true;

  void getWorkoutData() async {
    await controller.setup();
    _isLoading = false;
    // Do this to load the workout data, what about changing data though?
    setState(() {});
  }

  void updateList() async {
    await controller.updateList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getWorkoutData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: _isLoading
        ? const Center()
        : SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.runningWorkouts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/8,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.runningWorkouts[index].workoutName),
                            Text(controller.runningWorkouts[index].distance.toString()),
                          ],
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
                                controller: controller,
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
                      ElevatedButton(
                          onPressed: () {
                            final args = CreateWorkoutArguments(
                                pageType: 'weight_train',
                                controller: controller,
                                updateList: updateList
                            );
                            Navigator.pushNamed(
                              context, 
                              createWorkoutRoute,
                              arguments: args);
                          },
                          child: const Text("Weight Training",
                            style: TextStyle(
                              fontSize: 30,
                          )
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width/1, MediaQuery.of(context).size.height/15),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
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
