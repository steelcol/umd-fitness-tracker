import 'package:BetaFitness/arguments/storage_arguments.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SingletonStorage storage;
  bool _loading = true;
  late StorageArguments args;

  void initializeSingletonStorage() async {
    storage = await SingletonStorage.create();
    args = StorageArguments(storage: storage);
    _loading = false;

    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    initializeSingletonStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, profileRoute),
            icon: Icon(Icons.account_circle_sharp),
          ),
        ],
      ),
      body: _loading
          ? Center(
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: [Theme
              .of(context)
              .primaryColor
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Today's Activity",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Add content related to today's activity here
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.access_alarm_outlined,
                  label: "Schedule",
                  route: schedulePageRoute,
                ),
                _buildActionButton(
                  icon: Icons.data_usage,
                  label: "Stats",
                  route: statsPageRoute,
                ),
                _buildActionButton(
                  icon: Icons.fitness_center_sharp,
                  label: "Workout",
                  route: workoutPageRoute,
                ),
                _buildActionButton(
                  icon: Icons.event,
                  label: "Events",
                  route: eventsPageRoute,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required String route}) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route, arguments: args),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(0), // Remove padding
        fixedSize: Size(80, 80), // Set a smaller fixed size for all buttons
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow the column to shrink
        children: [
          Container(
            width: 40, // Adjust the icon size
            height: 40,
            child: Icon(icon, size: 24),
          ),
          SizedBox(height: 4), // Adjust the spacing
          Text(
            label,
            style: TextStyle(fontSize: 10), // Adjust the label font size
          ),
        ],
      ),
    );
  }
}
