import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class progress extends StatefulWidget {
  var data;
  var weekday;
  var exercise;
  progress(this.data, this.weekday, this.exercise);

  @override
  State<StatefulWidget> createState() {
    return progress_screen(data, weekday, exercise);
  }
}

class progress_screen extends State<StatefulWidget> {
  var data;
  var weekday;
  var exercise;
  var data_points_lift = [FlSpot(0, 0)];
  var data_points_reps = [FlSpot(0, 0)];
  var maxx = 1.0;
  var maxy = 1.0;
  var options = false;
  var reps_visible = false;
  var lift_visible = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      for (int i = 0;
          i < data.weekdays[weekday].exercises[exercise].Sets.length;
          i++) {
        data_points_lift.add(FlSpot(i.toDouble(),
            data.weekdays[weekday].exercises[exercise].Sets[i].max.toDouble()));
      }

      for (int i = 0;
          i < data.weekdays[weekday].exercises[exercise].Sets.length;
          i++) {
        data_points_reps.add(FlSpot(
            i.toDouble(),
            data.weekdays[weekday].exercises[exercise].Sets[i].reps
                .toDouble()));
      }
    });
  }

  progress_screen(this.data, this.weekday, this.exercise);

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
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(right: 7, left: 7, top: 10, bottom: 7),
              child: Text(
                "${data.weekdays[weekday].exercises[exercise].name.toString().toUpperCase()} ANALYSIS",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
              )),
          Stack(children: [
            Visibility(
              visible: lift_visible,
              child: Column(
                children: [
                  Container(
                      child: Text(
                    "LIFT ANALYSIS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        // maxX:maxx,
                        // maxY:maxy,
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: data_points_lift,
                            isCurved: false,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text("Data Points"),
                      SingleChildScrollView(
                          child: Container(
                            // color: Colors.brown,
                        width: double.infinity,
                        height: 360,
                        child: ListView.builder(itemCount: data.weekdays[weekday].exercises[exercise].Sets.length,itemBuilder: (context,index){
                          return Container(child: Center(child: Text( "${index+1}. ${data.weekdays[weekday].exercises[exercise].Sets[index].max.toString()} kg"))) ;
                        }),
                      ))
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: reps_visible,
              child: Column(
                children: [
                  Container(
                      child: Text(
                    "REPS ANALYSIS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        // maxX:maxx,
                        // maxY:maxy,
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: data_points_reps,
                            isCurved: false,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text("Data Points"),
                      SingleChildScrollView(
                          child: Container(
                            // color: Colors.brown,
                            width: double.infinity,
                            height: 360,
                            child: ListView.builder(itemCount: data.weekdays[weekday].exercises[exercise].Sets.length,itemBuilder: (context,index){
                              return Container(child: Center(child: Text( "${index+1}. ${data.weekdays[weekday].exercises[exercise].Sets[index].reps.toString()} reps"))) ;
                            }),
                          ))
                    ],
                  )

                ],
              ),
            ),
            Container(
              height: 700,
              width: 390,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: options,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(5),
                        width: 150,
                        height: 100,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    reps_visible = false;
                                    lift_visible = true;
                                  });
                                },
                                child: Container(
                                    // color: Colors.lightGreen,
                                    padding: EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                        top: 10,
                                        bottom: 10),
                                    child: Text("Lift Anaysis",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17))),
                              ),
                              Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide()))),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    reps_visible = true;
                                    lift_visible = false;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                        top: 13,
                                        bottom: 10),
                                    // color: Colors.lightGreen,
                                    child: Text("Rep Analysis",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17))),
                              )
                            ]),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (options) {
                            options = false;
                          } else {
                            options = true;
                          }
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(child: Icon(Icons.list)),
                      ),
                    ),
                  ]),
            )
          ]),
        ],
      ),
    );
  }
}
