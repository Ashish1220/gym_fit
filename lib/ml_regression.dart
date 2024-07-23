import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

class ml_reports extends StatefulWidget {
  var data;
  var weekday;
  var exercise;

  ml_reports(this.data, this.weekday, this.exercise);

  @override
  _MLReportsScreenState createState() => _MLReportsScreenState();
}

class _MLReportsScreenState extends State<ml_reports> {
  var model;
  var prediction;
  var flag = 0;
  var max_y = 0.0;
  final TextEditingController _numberController = TextEditingController();
  var slope;
  var _enterednumber;
  var prediction_value;
  var base_lift = 0;
  final List<FlSpot> dataPoints = [];

  @override
  void initState() {
    super.initState();
    if (widget.data.weekdays[widget.weekday].exercises[widget.exercise].Sets
            .length >
        9) {
      setState(() {
        flag = 1;
        List<List<dynamic>> l = [];
        List<List<dynamic>> toPredict = [
          ["time"]
        ];
        l.add(["Weight", "time"]);
          num temp=0;
        for (int i = 0;
            i <
                widget.data.weekdays[widget.weekday].exercises[widget.exercise]
                    .Sets.length;
            i++) {
          l.add([
            widget.data.weekdays[widget.weekday].exercises[widget.exercise]
                .Sets[i].max,
            i + 1
          ]);
          toPredict.add([i + 1]);

        }
        base_lift=widget.data.weekdays[widget.weekday].exercises[widget.exercise]
            .Sets[widget.data.weekdays[widget.weekday].exercises[widget.exercise]
            .Sets.length-1].max;
        for (int i = widget.data.weekdays[widget.weekday]
                    .exercises[widget.exercise].Sets.length +
                1;
            i <=
                widget.data.weekdays[widget.weekday].exercises[widget.exercise]
                        .Sets.length +
                    7;
            i++) {
          toPredict.add([i]);
        }

        model = LinearRegressor(DataFrame(l), "Weight");
        prediction = model.predict(DataFrame(toPredict));
        prediction = prediction.toMatrix();
        slope = (prediction[prediction.length - 1][0] - prediction[0][0]) /
            prediction.length;

        for (int i = 0; i < toPredict.length - 1; i++) {
          // max_y=max(max_y, double.parse("${prediction[i][0]}"));
          max_y=max(max_y,prediction[i][0] as double);
          print("max val");
          print(max_y);
          if (prediction[i][0] < 0) {
            dataPoints.add(FlSpot(toPredict[i + 1][0].toDouble(), 0));
          } else {
            dataPoints
                .add(FlSpot(toPredict[i + 1][0].toDouble(), prediction[i][0]));
          }
        }
      });
    }
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
                child: Text("Gym-Fit",
                    style: TextStyle(fontSize: 25, fontFamily: 'CustomFont',color: Colors.cyan.shade800)),
              ),
              Container(
                  height: 50, child: Image.asset('assets/images/logo.png')),
            ],
          ),
        ),
      ),
      body: flag == 1
          ? prediction == null
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    color: Colors.cyan.shade100,

                    child: Padding(

                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "PREDICTIVE ANALYSIS",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.data.weekdays[widget.weekday]
                                .exercises[widget.exercise].name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 400,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: (widget.data.weekdays[widget.weekday].exercises[widget.exercise]
                                    .Sets.length*1.0+9.0),
                                minY: -4,
                                maxY: max_y*1.1,
                                // maxY:max_,

                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  show: true,
                                ),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: dataPoints,
                                    isCurved: true,
                                    color: Colors.red,
                                    barWidth: 3,
                                    belowBarData: BarAreaData(show: false),
                                    dotData: FlDotData(
                                      show: true,
                                      // Show dots at each point
                                      // Width of the stroke around the dots
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Please Enter The Number of Sets After Which You Expect Your Prediction:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: _numberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Enter number of sets',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  ),
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _enterednumber = _numberController.text;
                                      prediction_value = slope * double.parse(_enterednumber) + base_lift;
                                      prediction_value = prediction_value.toStringAsFixed(2);
                                    });
                                  },
                                  child: Text('Submit'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    textStyle: TextStyle(fontSize: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _enterednumber == null || _enterednumber.isEmpty
                                        ? ''
                                        : 'Approximated strength after $_enterednumber sets will be $prediction_value kgs',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "We need at least 9 sets for prediction analysis!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Go Back",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
