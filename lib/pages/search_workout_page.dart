import 'package:flutter/material.dart';
import '../arguments/exercise_template_arguments.dart';
import '../models/exercise_model.dart';
import '../storage/workout_exercise_storage.dart';
import '../utilities/routes.dart';

class WorkoutSearchPage extends StatefulWidget {
  final WorkoutInformation info;

  WorkoutSearchPage({Key? key, required this.info}) : super(key: key);

  @override
  State<WorkoutSearchPage> createState() => _WorkoutSearchPageState();
}

class _WorkoutSearchPageState extends State<WorkoutSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Exercise> allWorkoutList;
  List<Exercise> _searchResults = [];

  @override
  void initState() {
    super.initState();
    appendWorkoutLists();
    _searchResults = List.from(allWorkoutList);
  }

  void appendWorkoutLists() {
    allWorkoutList = []
      ..addAll(widget.info.upperBodyExercises)
      ..addAll(widget.info.lowerBodyExercises)
      ..addAll(widget.info.coreExercises);
    // print("LIST APPENDED: ${allWorkoutList.length}");
  }

  void _performSearch() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _searchResults = List.from(allWorkoutList); // CASE: display workouts if search is empty
    } else {
      _searchResults = allWorkoutList
          .where((exercise) => exercise.name.toLowerCase().contains(query))
          .toList();
    }

    // check
    print("Search results: ${_searchResults.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BetaFitness'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for workouts',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onChanged: (value) => _performSearch(), // Search on text change
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return _buildExerciseCard(_searchResults[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            exerciseTemplatePageRoute,
            arguments: ExerciseTemplateArguments(
              exerciseName: exercise.name,
              description: exercise.description,
              videoURL: exercise.videoURL,
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(exercise.name),
                subtitle: Text(exercise.description),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () { // TODO: Add workout to previous page
                print("Add ${exercise.name} to workout");
              },
            ),
          ],
        ),
      ),
    );
  }
}
