import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/heat_map.dart';
import 'package:workout_app/components/textfield.dart';
import 'package:workout_app/components/workout_tile.dart';
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
        backgroundColor: Color(0xFF292929),
        content: MyTextField(
          controller: newWorkoutNameController,
          hint: "New Exercise",
          isNum: false,
        ),
        actions: [
          //save button
          MaterialButton(
            color: Colors.black26,
            textColor: Colors.white,
            onPressed: () {
              if (newWorkoutNameController.text != "") {
                Provider.of<WorkoutData>(
                  context,
                  listen: false,
                ).addWorkout(newWorkoutNameController.text);
              }

              Navigator.of(context).pop();
              newWorkoutNameController.clear();
            },
            child: const Text("Save"),
          ),

          //cancel button
          MaterialButton(
            color: Colors.black26,
            textColor: Colors.white,
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
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkoutDialogue,
          backgroundColor: Color(0xFF292929),
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            SizedBox(height: 10),
            //heat map
            Padding(
              padding: const EdgeInsets.all(25),
              child: MyHeatMap(
                datasets: value.heatMapDataSet,
                startDateYYYYMMDD: value.getStartDate(),
              ),
            ),

            const SizedBox(height: 50),

            //workout list
            SlidableAutoCloseBehavior(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                //above 2 are used because the there is list view present inside of list view
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      bottom: 20,
                    ),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutPage(
                                    workoutName: value.workoutList[index].name,
                                  ),
                                ),
                              );
                            },
                            icon: Icons.settings,
                            backgroundColor: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          SlidableAction(
                            onPressed: (context) {},
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ),
                      child: WorkoutTile(value: value, index: index),
                    ),
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
