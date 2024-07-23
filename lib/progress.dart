import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ml_regression.dart'; // Import ml_reports widget
import 'database_connector.dart';
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
      for (int i = 0; i < data.weekdays[weekday].exercises[exercise].Sets.length; i++) {
        data_points_lift.add(FlSpot(i.toDouble(), data.weekdays[weekday].exercises[exercise].Sets[i].max.toDouble()));
      }

      for (int i = 0; i < data.weekdays[weekday].exercises[exercise].Sets.length; i++) {
        data_points_reps.add(FlSpot(i.toDouble(), data.weekdays[weekday].exercises[exercise].Sets[i].reps.toDouble()));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 7, left: 7, top: 10, bottom: 7),
              child: Text(
                "${data.weekdays[weekday].exercises[exercise].name.toString().toUpperCase()} ANALYSIS",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
              ),
            ),
            Stack(
              children: [
                Visibility(
                  visible: lift_visible,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          "LIFT ANALYSIS",
                          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: double.infinity,
                        height: 300,
                        child: LineChart(
                          LineChartData(
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ml_reports(data, weekday, exercise)));
                            },
                            child: Text("Perform Predictive analysis"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15,bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Adjust as needed
                              children: [
                                Icon(
                                  Icons.data_usage, // Example icon (replace with your desired icon)
                                  color: Colors.cyan.shade800, // Icon color
                                ),

                                SizedBox(width: 8), // Adjust spacing between icon and text
                                Text(
                                  'Data Points',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan.shade800, // Text color
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              height: 360,
                              child: ListView.builder(
                                itemCount: data.weekdays[weekday].exercises[exercise].Sets.length,
                                itemBuilder: (context, index) {
                                  // Extract the Sets_ins object for easier access


                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(

                                        child: Text((index + 1).toString()), // Display index as a circle avatar
                                      ),
                                      title: Text(
                                        "${data.weekdays[weekday].exercises[exercise].Sets[index].reps} reps", // Display reps count
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Lift: ${data.weekdays[weekday].exercises[exercise].Sets[index].max} kg", // Display max value of the set
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,),
                                        onPressed: () {
                                            setState(() {
                                              data.weekdays[weekday].exercises[exercise].Sets.remove(data.weekdays[weekday].exercises[exercise].Sets[index]);
                                              DatabaseHelper helper2 = DatabaseHelper();
                                              helper2.updateFirstItem(data.toJsonString());
                                            });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),

                            ),
                          ),
                        ],
                      ),
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: double.infinity,
                        height: 300,
                        child: LineChart(
                          LineChartData(
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ml_reports(data, weekday, exercise)));
                            },
                            child: Text("Perform Predictive analysis"),
                          ),
    Container(
      margin: EdgeInsets.only(top:15,bottom:10),
      child: Row(
      mainAxisSize: MainAxisSize.min, // Adjust as needed
      children: [
      Icon(
      Icons.data_usage, // Example icon (replace with your desired icon)
      color: Colors.cyan.shade800, // Icon color
      ),

      SizedBox(width: 8), // Adjust spacing between icon and text
      Text(
      'Data Points',
      style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.cyan.shade800, // Text color
      ),
      ),
      ],
      ),
    ),

                          SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              height: 360,
                              child: ListView.builder( reverse: true,
                                itemCount: data.weekdays[weekday].exercises[exercise].Sets.length,
                                itemBuilder: (context, index) {
                                  // Extract the Sets_ins object for easier access


                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text((index + 1).toString()), // Display index as a circle avatar
                                      ),
                                      title: Text(
                                        "${data.weekdays[weekday].exercises[exercise].Sets[index].reps} reps", // Display reps count
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Lift: ${data.weekdays[weekday].exercises[exercise].Sets[index].max} kg", // Display max value of the set
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          // Add action for the info icon if needed
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 90,
                  right: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: options,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.cyan.shade800, borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(5),
                          width: 170,
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
                                  padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                                  child: Text(
                                    "Lift Analysis",
                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    reps_visible = true;
                                    lift_visible = false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 25, right: 25, top: 13, bottom: 10),
                                  child: Text(
                                    "Rep Analysis",
                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            options = !options;
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: Colors.cyan
                              .shade800, borderRadius: BorderRadius.circular(100)),
                          child: Center(child: Icon(Icons.list,color: Colors.white,)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
