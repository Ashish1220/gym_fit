import 'dart:async';
import 'package:Gym_Fit/start_workout.dart';
import 'rest.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Gym_Fit/workout_screen.dart';

class cooldown extends StatefulWidget{
  var just_pass_data;
  var just_pass_weekday;

  cooldown(this.just_pass_data,this.just_pass_weekday);
  @override
  State<StatefulWidget> createState() {
   return cooldown_screen(just_pass_data,just_pass_weekday);
  }

}

class cooldown_screen extends State<StatefulWidget>{
  var just_pass_data;
  var just_pass_weekday;

  cooldown_screen(this.just_pass_data,this.just_pass_weekday);

  var counter=3;
  @override
  void initState() {
    super.initState();
   Timer.periodic(Duration(seconds: 1), (timer){
     
     setState(() {
       this.counter--;
     });
     if(counter==1){
       timer.cancel();
       Navigator.pop(context);
       print(just_pass_data.weekdays[just_pass_weekday].exercises.length);
       for(int i=just_pass_data.weekdays[just_pass_weekday].exercises.length-1;i>=0;i--){
         print("Workout_Started");
         print(just_pass_data.weekdays[just_pass_weekday].exercises[i].name);
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) =>
                     start_workout(
                         just_pass_data,
                         just_pass_weekday,
                         i)));
      if(i!=0) { Navigator.push(context, MaterialPageRoute(builder :(context)=>rest()));}

       }

     }


   });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: double.infinity,height: double.infinity,child:SizedBox(width: 150,height: 150, child: Center(child: Text("$counter" ,style
      :TextStyle(fontSize: 90))),),)
    );
  }

}