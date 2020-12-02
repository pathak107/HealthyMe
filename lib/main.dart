import 'package:flutter/material.dart';
import 'package:healthy_me/Screens/BMIScreen.dart';
import 'package:healthy_me/Screens/HomeScreen.dart';
import 'package:healthy_me/Screens/calorieScreen.dart';
import 'package:healthy_me/Screens/factsScreen.dart';

void main() => runApp(HealthyMe());

class HealthyMe extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthy Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF171624),
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        accentColor: Colors.tealAccent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/bmi_screen':(context)=> BMIScreen(),
        '/calorie_screen':(context)=> CalorieScreen(),
        '/facts_Screen':(context)=>FactsScreen(title: 'Network Error',description: "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
      },
    );
  }
}
