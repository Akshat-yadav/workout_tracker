import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/exercise_tile.dart';
import 'package:workout_app/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkBox was tapped on
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).checkOffExercise(workoutName, exerciseName);
  }

  //text controllers
  final exerciseNameTextController = TextEditingController();
  final weightTextController = TextEditingController();
  final repsTextController = TextEditingController();
  final setsTextController = TextEditingController();

  //create a new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //exercise name
            TextField(
              controller: exerciseNameTextController,
              decoration: InputDecoration(hintText: "Exercise name"),
            ),

            //weight
            TextField(
              controller: weightTextController,
              decoration: InputDecoration(hintText: "weight"),
            ),

            //reps
            TextField(
              controller: repsTextController,
              decoration: InputDecoration(hintText: "reps"),
            ),

            //sets
            TextField(
              controller: setsTextController,
              decoration: InputDecoration(hintText: "sets"),
            ),
          ],
        ),
        actions: [
          //save
          MaterialButton(
            onPressed: () {
              Provider.of<WorkoutData>(context, listen: false).addExercise(
                widget.workoutName,
                exerciseNameTextController.text,
                weightTextController.text,
                repsTextController.text,
                setsTextController.text,
              );
              Navigator.of(context).pop();
              exerciseNameTextController.clear();
              weightTextController.clear();
              repsTextController.clear();
              setsTextController.clear();
            },
            child: const Text("Save"),
          ),

          //cancel
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              exerciseNameTextController.clear();
              weightTextController.clear();
              repsTextController.clear();
              setsTextController.clear();
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
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .sets,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.workoutName,
              value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name,
            ),
          ),
        ),
      ),
    );
  }
}
