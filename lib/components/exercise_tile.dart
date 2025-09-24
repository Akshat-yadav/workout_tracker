import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCompleted ? Colors.green : Color(0xFFDBDBDB),
      ),
      child: Center(
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              exerciseName.toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          subtitle: Row(
            children: [
              //weight
              Transform.scale(
                scale: 0.85,
                child: Chip(
                  label: Text("$weight kg"),
                  backgroundColor: Color(0xFF414040),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),

              //reps
              Transform.scale(
                scale: 0.85,
                child: Chip(
                  label: Text("$reps reps"),
                  backgroundColor: Color(0xFF414040),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),

              //sets
              Transform.scale(
                scale: 0.85,
                child: Chip(
                  label: Text("$sets sets"),
                  backgroundColor: Color(0xFF414040),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          trailing: Checkbox(
            value: isCompleted,
            onChanged: (value) => onCheckBoxChanged!(value),
          ),
        ),
      ),
    );
  }
}
