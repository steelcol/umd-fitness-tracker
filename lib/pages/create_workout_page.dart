import 'package:flutter/material.dart';

class CreateWorkoutPage extends StatefulWidget{
  CreateWorkoutPage({Key? key, required this.pageType}) : super(key: key);

  final String pageType;

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch(widget.pageType) {
      case 'cardio':
        return Scaffold(
          appBar: AppBar(
            title: const Text("BetaFitness"),
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                          Icons.run_circle_outlined,
                          size: 40
                      ),
                      labelText: "Distance",
                      hintText: "Enter your desired distance",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a distance';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      case 'weight_train':
        return Scaffold(
          appBar: AppBar(
            title: const Text("BetaFitness"),
          ),
          body: Center(
            child: Text(widget.pageType),
          ),
        );
      default:
        return Scaffold(

        );
    }
  }
}
