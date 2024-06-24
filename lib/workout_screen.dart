import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:Gym_Fit/cooldown_workout_start.dart';
import 'package:Gym_Fit/main.dart';
import 'progress.dart';
import 'data_heirarcy.dart';

class workout extends StatefulWidget {
  var day_workout;
  var data;
  workout(this.day_workout, this.data);
  @override
  State<StatefulWidget> createState() {
    return workout_screen(day_workout, data);
  }
}


class workout_screen extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
    setState((){});
  }

  var opacity_main = 1.0;
  var is_visible_box = false;
  var day_workout;
  var data;
  var get_new_exercise_controller = TextEditingController();
  var warning = "";
  var stack = 0;
  DateTime now = DateTime.now();
  workout_screen(this.day_workout, this.data);

  @override
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
                    style:
                        TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
                Container(
                    height: 50, child: Image.asset('assets/images/logo.png')),
              ],
            ),
          ),
        ),
        body: Stack(children: [
          Opacity(
            opacity: opacity_main,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 7, right: 7, top: 3, bottom: 0),
                          width: 412,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.all(4),
                                      child: Text(
                                        "${data.weekdays[day_workout].name}'s Workout",
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  Container(
                                    margin: EdgeInsets.all(4),
                                    child: Text(
                                      "${data.weekdays[day_workout].stratergy_name}",
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(4),
                                      child: Text(
                                          "No of Exercises: ${data.weekdays[day_workout].exercises.length}")),
                                ]),
                          ))),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              cooldown(data, day_workout)));
                                });

                              },
                              child: Text("Start Workout Now!")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  setState(() {
                                    opacity_main = 0.3;
                                    is_visible_box = true;
                                  });
                                });
                              },
                              child: Text("Add New Exersice"))
                        ],
                      )),
                  Expanded(
                      flex: 8,
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                                height: 100,
                                child: Card(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 17, top: 13, bottom: 13),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ""
                                                  "${index + 1}. ${data.weekdays[day_workout].exercises[index].name}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                    "Max: ${data.weekdays[day_workout].exercises[index].max_value_of_exersice}"),
                                                Text(
                                                    "Max reps: ${data.weekdays[day_workout].exercises[index].max_value_of_reps}")
                                              ],
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(right: 30),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>progress(data,day_workout,index)));
                                              },
                                              child: Text("Open Stats")),
                                        )
                                      ],
                                    )));
                          },
                          itemCount:
                              data.weekdays[day_workout].exercises.length))
                ],
              ),
            ),
          ),
          Visibility(
            visible: is_visible_box,
            child: Center(
                child: Container(
              color: Colors.orange,
              width: 340,
              height: 300,
              child: Column(
                children: [
                  Expanded(
                      child: Column(

                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                            color: Colors.red,
                            padding: EdgeInsets.only(left: 5),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    is_visible_box = false;
                                    opacity_main = 1;
                                  });
                                },
                                icon: Icon(Icons.arrow_back)))
                      ])),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("drgv"),
                        ),
                        Container(
                          child: Container(
                              width: 200,
                              child: TextField(
                                controller: get_new_exercise_controller,
                              )),
                        ),
                        Text(
                          warning,
                          style: TextStyle(color: Colors.red),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (get_new_exercise_controller.text
                                        .toString() ==
                                    "") {
                                  warning = "Please enter name of workout!";
                                } else {
                                  print(get_new_exercise_controller.text
                                      .toString());
                                  warning = "";
                                }
                                data.weekdays[day_workout].exercises.add(
                                    exercise_info(
                                        get_new_exercise_controller.text
                                            .toString(),
                                        [],
                                        0));
                                for (int i = 0;
                                    i <
                                        data.weekdays[day_workout].exercises
                                            .length;
                                    i++) {
                                  print(
                                      "${data.weekdays[day_workout].exercises[i]}\n");
                                }
                              });
                            },
                            child: Text("Add workout"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
        ]));
  }
}
