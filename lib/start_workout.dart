import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/workout_screen.dart';
import 'rest.dart';
import 'data_heirarcy.dart';

class start_workout extends StatefulWidget {
  var data;
  var day_week;
  var exercise_index;

  start_workout(
    this.data,
    this.day_week,
    this.exercise_index,
  );
  @override
  State<StatefulWidget> createState() {
    return start_workout_screen(data, day_week, exercise_index);
  }
}

class start_workout_screen extends State<StatefulWidget> {

  var data;
  var week_day;
  var last_set_reps;
  var exercise_index;
  var alert = "";
  var bg_col = Colors.green;
  var weight_controller = TextEditingController();
  var reps_controller = TextEditingController();
  int sets_done = 0;


  start_workout_screen(this.data, this.week_day, this.exercise_index);

  get_last_time_best_lift(data, week_index, exercise_index, sets) {
    int max_last_time = -1;
    var target = data.weekdays[week_index].exercises[exercise_index].Sets;
    if(sets!=0){
      for (int i = 0; i < sets; i++) {
      print("\n $i");
      if (target.length - i - 1 >= 0) {
        int check_val = target[target.length - i - 1].max;
        if (max_last_time < (check_val)) {
          max_last_time = (check_val);
        }
      }
    }
    return max_last_time;}
    else{return "- -";}
  }

  get_last_time_best_reps(data, week_index, exercise_index, sets) {
    int max_last_time = -1;
    var target = data.weekdays[week_index].exercises[exercise_index].Sets;
    if(sets!=0){
    for (int i = 0; i < sets; i++) {
      if (target.length - i - 1 >= 0) {
        int check_val = target[target.length - i - 1].reps;
        if (max_last_time < (check_val)) {
          max_last_time = (check_val);
        }
      }
    }
    return max_last_time;}
    else{
      return "- -";
    }
  }

  get_last_set_reps(data, week_index, exercise_index, sets){
    if(sets!=0 && data.weekdays[week_day].exercises[exercise_index].Sets.length!=0){
      return data.weekdays[week_day].exercises[exercise_index].Sets[data.weekdays[week_day].exercises[exercise_index].Sets.length-1].reps;
    }
    else{
      return "- -";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
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
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            width: 350,
            duration: Duration(seconds: 1),
            height: 650,
            child: Card(
              color: bg_col,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Text(
                                "${data.weekdays[week_day].exercises[exercise_index].name}",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold))),
                        Text(
                            "Last Time Sets : ${data.weekdays[week_day].exercises[exercise_index].last_time_sets}"),
                        Text(
                            "Last Time Max Lifts : ${get_last_time_best_lift(data, week_day, exercise_index, data.weekdays[week_day].exercises[exercise_index].last_time_sets)} kg"),
                        Text(
                            "Last Time Best reps: ${get_last_time_best_reps(data, week_day, exercise_index, data.weekdays[week_day].exercises[exercise_index].last_time_sets)} reps"),
                        Text(
                            "Last Set Reps: ${get_last_set_reps(data, week_day, exercise_index, data.weekdays[week_day].exercises[exercise_index].last_time_sets)} reps"),
                        Text(
                          "Current Set : ${sets_done + 1}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 40),
                          padding: EdgeInsets.only(top: 40),
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  width: 210,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: weight_controller,
                                    decoration: InputDecoration(
                                        hintText: "Weight",
                                        labelText: "WEIGHT",
                                        prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.add_chart),
                                        )),
                                  )),
                              Container(
                                  width: 210,
                                  child: TextField(
                                    controller: reps_controller,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Reps",
                                        labelText: "REPITATIONS",
                                        prefixIcon: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.add_chart))),
                                  )),
                              Text(
                                alert,
                                style: TextStyle(color: Colors.red),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 27),
                                child: ElevatedButton(
                                    onPressed: () {

                                      setState(() {
                                        if (reps_controller.text.toString() !=
                                                "" &&
                                            weight_controller.text.toString() !=
                                                "") {
                                          data.weekdays[week_day].exercises[exercise_index].Sets.add(Sets_ins(
                                              int.parse(
                                                  reps_controller.text.toString()),
                                              int.parse(weight_controller.text
                                                  .toString())));
                                          sets_done++;
                                          print(data.weekdays[week_day].exercises[exercise_index].Sets.length);
                                          alert = "";
                                        } else {
                                          alert =
                                              "Please fill out all fields! ";
                                        }
                                        if (sets_done <= 1) {
                                          bg_col = Colors.green;
                                        }
                                        if (sets_done == 2) {
                                          bg_col = Colors.orange;
                                        }
                                        if (sets_done >= 3) {
                                          bg_col = Colors.red;
                                        }

                                      });
                                    },
                                    child: Text("Set Done")),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 40),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            print("Pressed Previous");
                                            if (exercise_index - 1 >= 0) {
                                              Navigator.push(context, MaterialPageRoute(builder :(context)=>rest()));

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          start_workout(
                                                              data,
                                                              week_day,
                                                              exercise_index -
                                                                  1)));
                                            }
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: bg_col,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              width: 90,
                                              height: 90,
                                              child: Center(
                                                  child: Text("PREVIOUS")))),
                                      InkWell(
                                          onTap: () {
                                            print("Pressed Forward");
                                            data
                                                    .weekdays[week_day]
                                                    .exercises[exercise_index]
                                                    .last_time_sets =
                                                sets_done;

                                            data.weekdays[week_day].exercises[exercise_index].update_max_min_val();
                                            if(data.weekdays[week_day].exercises[exercise_index].name==data.weekdays[week_day].exercises[data.weekdays[week_day].exercises.length-1].name){
                                              Navigator.pop(context);
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: bg_col,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              width: 90,
                                              height: 90,
                                              child:
                                                  Center(child: Text("NEXT"))))
                                    ],
                                  ))
                            ],
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
