import 'package:BetaFitness/controllers/active_workout_controller.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActiveWorkoutPage extends StatefulWidget {
  ActiveWorkoutPage({Key? key, required this.workout}) : super(key: key);

  final WeightWorkout workout;
  final ActiveWorkoutController controller = ActiveWorkoutController();

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, List<int>> _weightValues = {};

  ActiveWorkoutController controller = ActiveWorkoutController();

  @override
  void initState() {
    super.initState();
    //Initialize _weightValues to be the proper size with keys
    widget.workout.exercises.forEach((exercise) {
      _weightValues[exercise.name] = List<int>.filled(exercise.setCount, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.workout.exercises.length,
                    itemBuilder: (context, index) {
                      return _buildExerciseCard(
                        widget.workout.exercises[index],
                        index
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
              Navigator.pop(context);
              Navigator.pop(context);
              // Add workout here
              controller.addCompletedWorkout(_weightValues); 
            }
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

  Widget _buildExerciseCard(SavedExercise exercise, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "${index + 1}. ${exercise.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(            
          shrinkWrap: true,
          itemCount: exercise.setCount,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('Set ${index+1}'),
                ),
                SizedBox(
                  width: 80,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Weight'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty || int.parse(value) < 0) {
                          return 'Not a valid weight';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                        _weightValues[exercise.name]![index] = int.parse(value!),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
