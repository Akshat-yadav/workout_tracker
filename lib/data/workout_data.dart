import 'package:flutter/material.dart';
import 'package:workout_app/data/hive_database.dart';
import 'package:workout_app/datetime/date_time.dart';
import 'package:workout_app/models/excercise.dart';
import 'package:workout_app/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  /*

    WORKOUT DATA STRUCTURE

    - This overall list contains list of all the workouts
    - Inside of each workout, there is a list of excercises

  */

  List<Workout> workoutList = [
    //default workout
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: "Biceps", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "Squats", weight: "15", reps: "20", sets: "2"),
      ],
    ),
  ];

  //if this the first time firing uo the app in lifetime of app
  //if there are workouts already in database then get workout list, else just the default list
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
    //loding heat map
    loadHeatMap();
  }

  //get the list of workouts
  List<Workout> getWorkoutList() => workoutList;

  //get the length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  //add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    //updating last active date of app
    db.updateLastActiveDate();

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //delete a workout
  void deleteWWorkout(String name) {
    //deleting workout
    workoutList.removeWhere((item) => item.name == name);

    //updating last active date of app
    db.updateLastActiveDate();

    //save to database
    db.saveToDatabase(workoutList);

    loadHeatMap();

    notifyListeners();
  }

  //add an excercise in a workout
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    //finding the workout from the list to add excercise to
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );

    //updating last active date of app
    db.updateLastActiveDate();

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //delete exercise in a workout
  void deleteExercise(String workoutName, String exerciseName) {
    //finding the workout from the list to add excercise to
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.removeWhere((item) => item.name == exerciseName);

    //updating last active date of app
    db.updateLastActiveDate();

    //save to database
    db.saveToDatabase(workoutList);

    loadHeatMap();

    notifyListeners();
  }

  //check off the excercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //finding the workout from the list to check off its status
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    //updating last active date of app
    db.updateLastActiveDate();

    //save to database first so db has the latest completion status
    db.saveToDatabase(workoutList);
    //reload heat map dataset from db
    loadHeatMap();
    //then notify UI listeners to rebuild with updated heatmap and lists
    notifyListeners();
  }

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String name) {
    Workout relevantWorkout = workoutList.firstWhere(
      (workout) => workout.name == name,
    );
    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name and exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //finding relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then parsing the workout for the given exercise
    Exercise relevantExercise = relevantWorkout.exercises.firstWhere(
      (exercise) => exercise.name == exerciseName,
    );

    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  /* 
  
    HEAT MAP
  
  
  */
  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    // clear existing entries so reloading doesn't duplicate or keep stale values
    heatMapDataSet = {};

    //calculating number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //iterate from start date to today and add each completion status to the dataset
    //"COMPLETION_STATUS_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertdateTimeObjectToyyyymmdd(
        startDate.add(Duration(days: i)),
      );

      //completion status : 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;

      //month
      int month = startDate.add(Duration(days: i)).month;

      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus,
      };

      //add to heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

  //if the app is loaded for the first time for a date then check off all the exercises to false
  void initializeExercise() {
    if (db.lastActiveDataExists()) {
      final today = todayDateYYYYMMDD();
      final lastDate = db.getLastActiveDate();
      if (today != lastDate) {
        checkOffAllWorkouts();
      }
    }
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

  void checkOffAllWorkouts() {
    for (var workout in workoutList) {
      for (var exercise in workout.exercises) {
        exercise.isCompleted = false;
      }
    }
  }
}
