import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';

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
import 'data_heirarcy.dart';
import 'splash_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String title;
  var app_data;
  MyHomePage(this.title, this.app_data);
  @override
  State<MyHomePage> createState() => _MyHomePageState(app_data);
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
  var remove_data;
  var app_data;
  var new_routine_visible = false;
  _MyHomePageState(this.app_data);
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
            child: Center(
                child: Text(
              "GYM FIT",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'title_font'),
            ))),
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
                                color: Colors.purple.shade50,
                                border: Border.all(
                                    width: 2, color: Colors.deepPurpleAccent),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${app_data.workout_routines[index]}",
                                  style: TextStyle(
                                    fontSize: 15,
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
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            print("Workout started");
                            setState(() {
                              get_new_routine();
                              DatabaseHelper helper2 = DatabaseHelper();
                              helper2.updateFirstItem(app_data.toJsonString());
                            });
                          },
                          child: Text(
                            "ADD WORKOUT!",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.purple))),
                    ),
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
                              builder: (context) =>
                                  workout(index, app_data))).then((_) {
                        DatabaseHelper helper2 = DatabaseHelper();
                        helper2.updateFirstItem(app_data.toJsonString());
                      });
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
                                  remove_data = index;
                                  new_routine_visible = true;
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
            child: Center(
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(10),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.question_mark,
                        size: 70,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                        child:
                            Text("Do You Really Want to remove this routine?",style: TextStyle(fontSize: 17),)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                print("Clicked on added");
                                setState(() {
                                  new_routine_visible = false;

                                });
                              },
                              child: Text("No")),
                        ),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                print("Clicked on added");
                                setState(() {
                                  app_data.weekdays.removeAt(remove_data);
                                  remove_data = -1;
                                  new_routine_visible = false;
                                  DatabaseHelper helper2 = DatabaseHelper();
                                  helper2.updateFirstItem(app_data.toJsonString());
                                });
                              },
                              child: Text("Remove")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
      ]),
    );
  }
}
