import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'workout_screen.dart';

import 'add_new_routine.dart';
import 'database_connector.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class DoubleBorderDecoration extends BoxDecoration {
  DoubleBorderDecoration({
    Color? color,
    double thickness = 1.0,
    BorderStyle style = BorderStyle.solid,
    BorderRadiusGeometry? borderRadius,

  }) : super(
          border: Border.fromBorderSide(
            BorderSide(
              color: color ?? Colors.black,
              width: thickness,
              style: style,
            ),
          ),
          borderRadius: borderRadius,
        );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYM FIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
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

  var app_data;
  var body_opacity = 1.0;
  var new_routine_visible = false;
  var remove_routine = -1;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left:24),
                child: Text("Gym-Fit",
                    style: TextStyle(fontSize: 25, fontFamily: 'CustomFont',color: Colors.cyan.shade800)),
              ),
              Container(
                  height: 50, child: Image.asset('assets/images/logo.png')),
            ],
          ),
        ),
      ),
      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_home2.jpg'),
            fit: BoxFit.cover, // You can also use BoxFit.fill
          ),
        ),
        child: Stack(children: [
          Opacity(
            opacity: body_opacity,
            child: Column(
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
                          // height: 20,
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

                                  decoration: DoubleBorderDecoration(
                                    color: Colors.white,// Outer border color
                                    thickness: 4.0, // Thickness of both borders
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${app_data.workout_routines[index]}",
                                      style: TextStyle(
                                        color: Colors.black45,
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
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.cyan))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Total routine-time: ",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              "${app_data.total_estimated_time} Hours",
                              style: TextStyle(color: Colors.white),
                            ),
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
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(width: 0.5),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "${app_data.weekdays[index].name} ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 29,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          color: Colors.grey,
                                          width: double.infinity,
                                          margin: EdgeInsets.all(10),

                                          child: Center(
                                            child: Text(
                                              "${app_data.weekdays[index].stratergy_name}",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                                      "Average Time: \n${app_data.weekdays[index].workout_time} Hrs",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2,
                                        color: Colors
                                            .white), // Customize border width and color
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        body_opacity = 0.3;
                                        new_routine_visible = true;
                                        remove_routine = index;
                                      });
                                    },
                                    icon:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
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
          ),
          Visibility(
            visible: new_routine_visible,
            child: Center(
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.teal,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.question_mark,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Do you really want to delete this workout?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              new_routine_visible = false;
                              body_opacity = 1;
                            });
                          },
                          child: Text("No"),
                          style: ElevatedButton.styleFrom(
                            // color:Colors.red,
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Perform deletion logic here
                            setState(() {
                              if (remove_routine != -1)
                                app_data.weekdays.removeAt(remove_routine);
                              new_routine_visible = false;
                              remove_routine = -1;
                              body_opacity = 1;
                            });
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(

                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
