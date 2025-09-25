import 'package:flutter/material.dart';
import 'package:workout_app/pages/home_page.dart';

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 150),
          //image
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Image.asset(
              'assets/icons/splashpage.png',
              height: 400,
              width: 400,
            ),
          ),
          //SizedBox(height: 10),
          //text
          Column(
            children: [
              const Text(
                "Your Workout",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Companion",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              const Text("Track your daily workouts & monitor your"),
              const Text('progress'),
            ],
          ),

          //button
          SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
