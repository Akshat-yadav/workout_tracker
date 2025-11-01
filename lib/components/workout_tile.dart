import 'package:flutter/material.dart';
import 'package:workout_app/data/workout_data.dart';
import 'package:workout_app/pages/workout_page.dart';

class WorkoutTile extends StatefulWidget {
  final WorkoutData value;
  final int index;
  const WorkoutTile({super.key, required this.value, required this.index});

  @override
  State<WorkoutTile> createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF292929),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: ListTile(
          leading: Image.asset(
            'assets/icons/workout.png',
            width: 40,
            height: 40,
          ),
          title: Text(
            widget.value.getWorkoutList()[widget.index].name.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          trailing: IconButton(
            onPressed: () {
              //goto new workout page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutPage(
                    workoutName: widget.value.workoutList[widget.index].name,
                  ),
                ),
              );
            },
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
