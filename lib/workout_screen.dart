import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'cooldown_workout_start.dart';
import 'main.dart';
import 'progress.dart';
import 'data_heirarcy.dart';
import 'database_connector.dart';

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
    Container(

    child: Text("Gym-Fit",
    style: TextStyle(fontSize: 25, fontFamily: 'CustomFont',color: Colors.cyan.shade800)),
    ),
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
                  margin: EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 0),
                  width: 412,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400, width: 2.0),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(4),
                                child: Text(
                                  "${data.weekdays[day_workout].name}'s Workout",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                child: Text(
                                  "${data.weekdays[day_workout].stratergy_name}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                child: Text(
                                  "No of Exercises: ${data.weekdays[day_workout].exercises.length}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Adjust the width as needed for spacing
                        Center(
                          child: Container(
                            width: 130, // Adjust the width of the logo container as needed
                            height: 100, // Adjust the height of the logo container as needed
                            decoration: BoxDecoration(
                              color: Colors.white, // Example background color for the logo container
                              border: Border.all(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10), // Optional: Add border radius
                            ),
                            child: Center(
                              child: Icon(
                                Icons.query_stats, // Example icon (replace with your logo)
                                color: Colors.grey,
                                size: 90,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(top:20,bottom:20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                               style:ElevatedButton.styleFrom(
                                 backgroundColor: Colors.green.shade600,
                               ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                cooldown(data, day_workout)));
                                  });

                                },
                                child: Row(
                                  children: [Container(margin: EdgeInsets.only(right: 5),child: Icon(Icons.play_arrow,color: Colors.white,)),
                                    Text("Start Workout !",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                  ],
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    setState(() {
                                      opacity_main = 0.3;
                                      is_visible_box = true;
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20), // Rounded corners
                                    side: BorderSide(color: Colors.green, width: 2), // Border color & width
                                  ),

                                ),
                                child: Row(
                                  children: [Container(margin: EdgeInsets.only(right: 12),child: Icon(Icons.add,color: Colors.green,)),
                                    Text("Add New Exersice",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                                  ],
                                ))
                          ],
                        ),
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
                                        Expanded(
                                          flex:4,
                                          child: Container(
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
                                                      "PR: ${data.weekdays[day_workout].exercises[index].max_value_of_exersice} kg" ),
                                                  Text(
                                                      "Max reps: ${data.weekdays[day_workout].exercises[index].max_value_of_reps}")
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 2),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>progress(data,day_workout,index)));
                                                },
                                                child: Text("Open Stats")),
                                          ),
                                        )
                                      ,Expanded(
                                          flex: 1,
                                        child: IconButton(onPressed: (){data.weekdays[day_workout].exercises.remove(data.weekdays[day_workout].exercises[index]); setState(() {
                                            DatabaseHelper helper2 = DatabaseHelper();
                                            helper2.updateFirstItem(data.toJsonString());
                                          });}, icon: Icon(Icons.delete)),
                                      ),],
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
              width: 340,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.cyan.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            is_visible_box = false;
                            opacity_main = 1;
                          });
                        },
                        icon: Icon(Icons.close),
                        color: Colors.black45,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Add New Workout",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: get_new_exercise_controller,
                    decoration: InputDecoration(
                      hintText: "Enter workout name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    warning,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (get_new_exercise_controller.text.isEmpty) {
                          warning = "Please enter the name of the workout!";
                        } else {
                          data.weekdays[day_workout].exercises.add(
                            exercise_info(
                              get_new_exercise_controller.text,
                              [],
                              0,
                            ),
                          );
                          get_new_exercise_controller.clear();
                          warning = "";
                          DatabaseHelper helper2 = DatabaseHelper();
                          helper2.updateFirstItem(data.toJsonString());
                        }
                      });
                    },
                    child: Text("Add Workout",style: TextStyle(color: Colors.cyan.shade800),),
                  ),
                ],
              ),
            ),
          ),
        )

        ]));
  }
}
