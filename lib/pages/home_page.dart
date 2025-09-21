import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/heat_map.dart';
import 'package:workout_app/data/workout_data.dart';
import 'package:workout_app/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
    super.initState();
  }

  //text editing controller
  final newWorkoutNameController = TextEditingController();

  //creating new workout
  void createNewWorkoutDialogue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: TextField(controller: newWorkoutNameController),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              Provider.of<WorkoutData>(
                context,
                listen: false,
              ).addWorkout(newWorkoutNameController.text);
              Navigator.of(context).pop();
              newWorkoutNameController.clear();
            },
            child: const Text("Save"),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              newWorkoutNameController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: const Text("Workout Tracker")),
        backgroundColor: Colors.grey[500],
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkoutDialogue,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            //heat map
            MyHeatMap(
              datasets: value.heatMapDataSet,
              startDateYYYYMMDD: value.getStartDate(),
            ),

            //workout list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              //above 2 are used because the there is list view present inside of list view
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name),
                trailing: IconButton(
                  onPressed: () {
                    //goto new workout page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutPage(
                          workoutName: value.workoutList[index].name,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
