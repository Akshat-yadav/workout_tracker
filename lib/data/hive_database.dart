import 'package:hive/hive.dart';
import 'package:workout_app/datetime/date_time.dart';
import 'package:workout_app/models/excercise.dart';
import 'package:workout_app/models/workout.dart';

class HiveDatabase {
  //reference the box
  final _myBox = Hive.box("workout_database");

  //check if data is stored, if not record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put("START_DATE", todayDateYYYYMMDD());
      return false;
    } else {
      return true;
    }
  }

  //return the start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout objects to list of strings to save in hive(hive can store data in form of primary datatypes and lists)
    final workoutList = convertObjectsToWorkoutList(workouts);
    final exerciseList = convertObjectsToExerciseList(workouts);

    /* 
    
      check if any exercise is done
      put 0 or 1 accordingly in each yyyymmdd date
    
    
    */

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 0);
    } // COMPLETION_STATUS_20250920 -> 1

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data (return a list of workouts)
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //creating workout objects from the above 2 lists
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have multiple exercises soo
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //adding each workout to list
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      //create individual workouts
      Workout individualWorkout = Workout(
        name: workoutNames[i],
        exercises: exercisesInEachWorkout,
      );

      //add individual workout to overall list
      mySavedWorkouts.add(individualWorkout);
    }
    return mySavedWorkouts;
  }

  //check if any exercise is done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // stored keys look like "COMPLETION_STATUS_20250922"
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    //return 0 or 1 and 0 for null i.e user didnt use app on that date
    return completionStatus;
  }
}

//convert workout objects into a list. eg -> [ upperbody, lowerbody ]
List<String> convertObjectsToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //eg. [ upperbody, lowerbody ]
  ];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }

  return workoutList;
}

//converts the exercise in a workout object into a list of strings
List<List<List<String>>> convertObjectsToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /* 
      DATA STORAGE FORMAT OF EXERCISES
      [

        Upper Body
        [ [ biceps, 10kg, 10 reps], [ triceps, 10kg, 10 reps] ],
      
      
        Lower Body
        [ [ squats, 10kg, 10 reps], [ leg raise, 10kg, 10 reps], [ calf, 10kg, 3 reps]],

      ]
    */
  ];

  //iterating each workout from the list
  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [
      //Upper Body
      // [ [biceps, 10kg, 10reps, 3sets], [triceps, 20kg, 10reps, 3sets] ]
    ];

    //iterating each exercise from the workout
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
