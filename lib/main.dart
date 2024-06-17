import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/rest.dart';
import 'workout_screen.dart';
import 'start_workout.dart';
import 'cooldown_workout_start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: rest(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Sets {
  var reps;
  var max;
  Sets(this.reps, this.max);
}

class exercise_info {
  var name;
  var Sets;
  var max_value_of_exersice = 0;
  var max_value_of_reps = 0;
  var last_time_sets = 2;
  exercise_info(this.name, var set_instance,this.last_time_sets) {
    this.Sets = set_instance;

    for (var i = 0; i < Sets.length; i++) {
      if (max_value_of_exersice < Sets[i].max) {
        max_value_of_exersice = Sets[i].max;
      }
      if (max_value_of_reps < Sets[i].reps) {
        max_value_of_reps = Sets[i].reps;
      }

      print("New max lift : $max_value_of_exersice\n");
      print("New max reps : $max_value_of_reps");
    }
  }
  update_max_min_val() {
    for (var i = 0; i < Sets.length; i++) {
      if (max_value_of_exersice < Sets[i].max) {
        max_value_of_exersice = Sets[i].max;
      }
      if (max_value_of_reps < Sets[i].reps) {
        max_value_of_reps = Sets[i].reps;
      }
      //
    }
  }
}

class Weekdays {
  var name;
  var stratergy_name;
  var exercises;
  var workout_time = 0;
  Weekdays(this.name, this.stratergy_name, this.exercises, this.workout_time);
}

class data {
  var total_estimated_time = 0;
  var weekdays = [
    Weekdays(
        "Monday",
        "MIX",
        [
          exercise_info("Bench-Press", [Sets(16, 50), Sets(8, 200)],2),
          exercise_info("Shoulder-press", [Sets(16, 50), Sets(8, 102)],2),
          exercise_info("Lats PullDown", [Sets(12, 54), Sets(6, 120)],2)

        ],
        3)
  ];
  var workout_routines = [
    "STRENGTH",
    "STAMINA",
    "ENDURANCE",
    "BOXING",
    "TIMEPASS"
  ];

  data() {
    for (int i = 0; i < weekdays.length; i++) {
      total_estimated_time += weekdays[i].workout_time;
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var app_data = data();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Container(
          width: 411,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Gym-Fit",
                  style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
              Container(
                  height: 50, child: Image.asset('assets/images/logo.png')),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    print("Clicked On Add new");
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 70,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                      itemCount: app_data.workout_routines.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print("Clicked On routines");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${app_data.workout_routines[index]}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        print("Workout started");
                        setState(() {
                          print(app_data.weekdays[0].exercises);
                        });
                      },
                      child: Text(
                        "Start Routine",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.green))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Total routine-time: "),
                      Text("${app_data.total_estimated_time} Hours"),
                    ],
                  )
                ],
              )),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: app_data.weekdays.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print("CLICKED ON WORKOUT");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => workout(index, app_data)));
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(width: 0.5),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Column(
                            children: [
                              Text(
                                "${index + 1}.${app_data.weekdays[index].name} 's workout",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                  "${app_data.weekdays[index].stratergy_name}"),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Text(
                              "Average Time: \n${app_data.weekdays[index].workout_time} Hrs"),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
