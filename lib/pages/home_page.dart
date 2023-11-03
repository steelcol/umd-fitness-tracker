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
              icon: Icon(Icons.account_circle_sharp))
        ],
      ),
      body: _loading
          ? LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              colors: const [Colors.white],
            )
          : Center(
              child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    elevation: 10,
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Activity",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, schedulePageRoute, arguments: args),
                      child: Icon(Icons.access_alarm_outlined),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                        Navigator.pushNamed(context, statsPageRoute, arguments: args),
                      child: Icon(Icons.data_thresholding_sharp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                        Navigator.pushNamed(context, workoutPageRoute, arguments: args),
                      child: Icon(Icons.fitness_center_sharp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, eventsPageRoute, arguments: args),
                      child: Icon(Icons.event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                  ],
                )
              ],
            )),
    );
  }
}
