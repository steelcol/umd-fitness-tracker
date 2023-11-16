import 'package:BetaFitness/controllers/active_workout_controller.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:flutter/material.dart';

import '../storage/workout_exercise_storage.dart';

class WorkoutSearchPage extends StatefulWidget {
  const WorkoutSearchPage({Key? key, required this.info}) : super(key: key);

  final WorkoutInformation info;

  @override
  State<WorkoutSearchPage> createState() => _WorkoutSearchPageState();
}

class _WorkoutSearchPageState extends State<WorkoutSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<WorkoutInformation> _searchResults = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  void _performSearch() {
    String query = _searchController.text;

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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final workout = _searchResults[index];
                  return ListTile(
                    title: Text('test')
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
