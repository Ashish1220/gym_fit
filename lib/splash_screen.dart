import 'dart:async';

import 'package:flutter/material.dart';
import 'data_heirarcy.dart';
import 'database_connector.dart';
import 'main.dart'; // Adjust import if needed
import 'ml_regression.dart';
// Function to read data from database and return as JSON string
Future<String> readDataFromDatabase() async {
  try {
    DatabaseHelper helper = DatabaseHelper();
    List<Map<String, dynamic>> items = await helper.fetchItems();

    // Handle case where items is empty or null
    if (items.isNotEmpty) {
      return items[0]['value'];
    } else {
      helper.insertItem('{"total_estimated_time":0,"weekdays":[{"name":"Monday","stratergy_name":"MI","exercises":[{"name":"Bench-Press","Sets":[{"reps":16,"max":50},{"reps":8,"max":200}],"max_value_of_exersice":200,"max_value_of_reps":16,"last_time_sets":2},{"name":"Shoulder-press","Sets":[{"reps":16,"max":50},{"reps":8,"max":102}],"max_value_of_exersice":102,"max_value_of_reps":16,"last_time_sets":2},{"name":"Lats PullDown","Sets":[{"reps":12,"max":54},{"reps":6,"max":120}],"max_value_of_exersice":120,"max_value_of_reps":12,"last_time_sets":2}],"workout_time":3}],"workout_routines":["STRENGTH","STAMINA","ENDURANCE","BOXING","TIMEPASS"]}');
      return await readDataFromDatabase(); // Return empty string if no data found
    }
  } catch (e) {
    print('Error fetching data from database: $e');
    return ''; // Return empty string on error
  }
}

// Function to fetch all data from database and parse it into data object
Future<data> fetchAllData() async {
  var jsonString = await readDataFromDatabase();

  // If jsonString is null or empty, provide a fallback JSON string
  if (jsonString.isEmpty) {
    jsonString =
    '{"total_estimated_time":0,"weekdays":[{"name":"Monday","strategy_name":"MI","exercises":[{"name":"Bench-Press","Sets":[{"reps":16,"max":50},{"reps":8,"max":200}],"max_value_of_exercise":200,"max_value_of_reps":16,"last_time_sets":2},{"name":"Shoulder-press","Sets":[{"reps":16,"max":50},{"reps":8,"max":102}],"max_value_of_exercise":102,"max_value_of_reps":16,"last_time_sets":2},{"name":"Lats PullDown","Sets":[{"reps":12,"max":54},{"reps":6,"max":120}],"max_value_of_exercise":120,"max_value_of_reps":12,"last_time_sets":2}],"workout_time":3}],"workout_routines":["STRENGTH","STAMINA","ENDURANCE","BOXING","TIMEPASS"]}';
  }

  print("Data is:");
  print(jsonString);

  return data.fromJsonString(jsonString);
}

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<Splash> {
  late Future<data> _dataFuture; // Future to hold the fetched data

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchAllData();

    _dataFuture.then((data) {
      // Navigate to home screen after data is fetched
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage("Homepage",data),
        ),
      );
    }).catchError((error) {
      // Handle error if necessary
      print('Error fetching data: $error');
      // Example: Show error message or fallback UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash Screen'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
}
