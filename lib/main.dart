import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'connect_to_database.dart';
import 'progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/progress.dart';
import 'package:untitled/rest.dart';
import 'workout_screen.dart';
import 'start_workout.dart';
import 'cooldown_workout_start.dart';
import 'add_new_routine.dart';
import 'database_connector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYM FIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Sets_ins {
  var reps;
  var max;
  Sets_ins(this.reps, this.max);

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'max': max,
    };
  }

  factory Sets_ins.fromJson(Map<String, dynamic> json) {
    return Sets_ins(
      json['reps'],
      json['max'],
    );
  }
}

class exercise_info {
  var name;
  var Sets;
  var max_value_of_exersice = 0;
  var max_value_of_reps = 0;
  var last_time_sets = 2;
  exercise_info(this.name, var set_instance, this.last_time_sets) {
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'Sets': Sets.map((set) => set.toJson()).toList(),
      'max_value_of_exersice': max_value_of_exersice,
      'max_value_of_reps': max_value_of_reps,
      'last_time_sets': last_time_sets,
    };
  }

  factory exercise_info.fromJson(Map<String, dynamic> json) {
    return exercise_info(
      json['name'],
      (json['Sets'] as List)
          .map((setJson) => Sets_ins.fromJson(setJson))
          .toList(),
      json['last_time_sets'],
    );
  }
}

class Weekdays {
  var name;
  var stratergy_name;
  var exercises;
  var workout_time = 0;
  Weekdays(this.name, this.stratergy_name, this.exercises, this.workout_time);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stratergy_name': stratergy_name,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'workout_time': workout_time,
    };
  }

  factory Weekdays.fromJson(Map<String, dynamic> json) {
    return Weekdays(
      json['name'],
      json['stratergy_name'],
      (json['exercises'] as List)
          .map((exerciseJson) => exercise_info.fromJson(exerciseJson))
          .toList(),
      json['workout_time'],
    );
  }
}

class data {
  var total_estimated_time;
  var weekdays;
  var workout_routines;
  data(this.weekdays, this.workout_routines) {
    for (int i = 0; i < weekdays.length; i++) {
      total_estimated_time += weekdays[i].workout_time;
    }
  }
  Map<String, dynamic> make_map() {
    Map<String, dynamic> map = {};
    map['total_estimated_time'] = total_estimated_time;
    map['weekdays'] = weekdays.map((weekday) => weekday.toJson()).toList();
    map['workout_routines'] = workout_routines;
    return map;
  }

  data.fetch_data(Map<String, dynamic>? map) {
    total_estimated_time = map?['total_estimated_time'];
    weekdays = (map?['weekdays'] as List)
        .map((weekdayJson) => Weekdays.fromJson(weekdayJson))
        .toList();
    workout_routines = (map?['workout_routines'] as List).cast<String>();
  }
  String toJsonString() {
    return jsonEncode(make_map());
  }

  static data fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return data.fetch_data(jsonMap);
  }

  @override
  String toString() {
    return 'Data{total_estimated_time: $total_estimated_time, weekdays: $weekdays, workout_routines: $workout_routines}';
  }
}

Future<String> read_data_drom_Database() async {
  DatabaseHelper helper = DatabaseHelper();
  await helper.insertItem(
      '{"total_estimated_time":0,"weekdays":[{"name":"Monday","stratergy_name":"MI","exercises":[{"name":"Bench-Press","Sets":[{"reps":16,"max":50},{"reps":8,"max":200}],"max_value_of_exersice":200,"max_value_of_reps":16,"last_time_sets":2},{"name":"Shoulder-press","Sets":[{"reps":16,"max":50},{"reps":8,"max":102}],"max_value_of_exersice":102,"max_value_of_reps":16,"last_time_sets":2},{"name":"Lats PullDown","Sets":[{"reps":12,"max":54},{"reps":6,"max":120}],"max_value_of_exersice":120,"max_value_of_reps":12,"last_time_sets":2}],"workout_time":3}],"workout_routines":["STRENGTH","STAMINA","ENDURANCE","BOXING","TIMEPASS"]}');
  print("added");
  List<Map<String, dynamic>> items = await helper.fetchItems();
  String json_str = items[items.length - 1]['value'];
  return json_str;
}

class _MyHomePageState extends State<MyHomePage> {
  // var app_data = data([
  //   Weekdays(
  //       "Monday",
  //       "MIX",
  //       [
  //         exercise_info("Bench-Press", [Sets_ins(16, 50), Sets_ins(8, 200)], 2),
  //         exercise_info("Shoulder-press", [Sets_ins(16, 50), Sets_ins(8, 102)], 2),
  //         exercise_info("Lats PullDown", [Sets_ins(12, 54), Sets_ins(6, 120)], 2)
  //       ],
  //       3)
  // ],[
  //   "STRENGTH",
  //   "STAMINA",
  //   "ENDURANCE",
  //   "BOXING",
  //   "TIMEPASS"
  // ]
  // );

  var app_data;
  var new_routine_visible = false;

  print_json(data app_data) {
    print(app_data.toJsonString());
  }

   get_data() async {
    this.app_data =
        data.fromJsonString('''${await read_data_drom_Database()}''');
  }

  _MyHomePageState() {
    get_data();
  }
  get_new_routine() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => add_new_routine(app_data)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
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
                            get_new_routine();
                          });
                        },
                        child: Text(
                          "Add a new workout",
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
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Column(
                                children: [
                                  Text(
                                    "${index + 1}.${app_data.weekdays[index].name} 's workout",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                      "${app_data.weekdays[index].stratergy_name}"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                child: Text(
                                    "Average Time: \n${app_data.weekdays[index].workout_time} Hrs"),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  app_data.weekdays.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Visibility(
            visible: new_routine_visible,
            child: Container(
              child: Column(
                children: [
                  TextField(),
                  ElevatedButton(
                      onPressed: () {
                        print("Clicked on added");
                        setState(() {
                          new_routine_visible = false;
                        });
                      },
                      child: Text("Add new Routine"))
                ],
              ),
            ))
      ]),
    );
  }
}
