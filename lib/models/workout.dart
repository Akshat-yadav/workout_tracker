import 'package:workout_app/models/excercise.dart';

class Workout {
  String name;
  final List<Exercise> exercises;

  Workout({required this.name, required this.exercises});
}
