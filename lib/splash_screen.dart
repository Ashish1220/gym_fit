import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled/data_heirarcy.dart';
import 'database_connector.dart';
import 'data_heirarcy.dart'; // Ensure this import matches your actual file name
import 'main.dart'; // Adjust import if needed

// Function to read data from database and return as JSON string
Future<String> readDataFromDatabase() async {
  DatabaseHelper helper = DatabaseHelper();
  List<Map<String, dynamic>> items = await helper.fetchItems();

  if (items.length == 0) {
    helper.insertItem(
        '{"total_estimated_time":0,"weekdays":[{"name":"Monday","stratergy_name":"MI","exercises":[{"name":"Bench-Press","Sets":[{"reps":16,"max":50},{"reps":8,"max":200}],"max_value_of_exersice":200,"max_value_of_reps":16,"last_time_sets":2},{"name":"Shoulder-press","Sets":[{"reps":16,"max":50},{"reps":8,"max":102}],"max_value_of_exersice":102,"max_value_of_reps":16,"last_time_sets":2},{"name":"Lats PullDown","Sets":[{"reps":12,"max":54},{"reps":6,"max":120}],"max_value_of_exersice":120,"max_value_of_reps":12,"last_time_sets":2}],"workout_time":3}],"workout_routines":["STRENGTH","STAMINA","ENDURANCE","BOXING","TIMEPASS"]}');
    items = await helper.fetchItems();
  }
  String jsonString = items[0]['value'];
  return jsonString;
}

// Function to fetch all data from database and parse it into data object
Future<data> fetchAllData() async {
  var jsonString = await readDataFromDatabase();
  return data.fromJsonString(jsonString);
}

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<Splash> {
  Future<data>? _dataFuture; // Future to hold the fetched data
  var i = 0;

  @override
  void initState() {
    super.initState();

    _dataFuture = fetchAllData();

    _dataFuture!.then((data) {
      // Navigate to home screen after data is fetched
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage('Flutter Demo Home Page', data)),
      );
    }); // Start fetching data on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Splash Screen'),
        ),
        body: Center(child: CircularProgressIndicator()));
  }
}
