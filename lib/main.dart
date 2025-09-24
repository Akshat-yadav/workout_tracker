import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/theme/material_black.dart';
import 'package:workout_app/data/workout_data.dart';
import 'package:workout_app/pages/home_page.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //opening the hive box
  await Hive.openBox("workout_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: customGreySwatch,
          scaffoldBackgroundColor: Color(0xFFC7C7C7),
        ),
      ),
    );
  }
}
