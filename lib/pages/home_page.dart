import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, profileRoute),
              icon: Icon(Icons.account_circle_sharp)
          )
        ],
      ),
      body: Center(
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
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    const Text("Today's Activity",
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
                  onPressed: () => Navigator.pushNamed(context, statsPageRoute),
                  child: Icon(Icons.data_thresholding_sharp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, workoutPageRoute),
                  child: Icon(Icons.fitness_center_sharp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, eventsPageRoute),
                  child: Icon(Icons.event),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}