import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:untitled/main.dart';
import 'main.dart';
import 'data_heirarcy.dart';
class add_new_routine extends StatefulWidget {
  var data;

  add_new_routine(this.data);
  @override
  State<StatefulWidget> createState() {

    return add_new_routine_screen(data);
  }
}

class add_new_routine_screen extends State<StatefulWidget> {
  var temp_opacity=0.8;
  var data;
  var warning="";
  var add_routine_name_controller = TextEditingController();
  var add_strategy_name_controller = TextEditingController();

  add_new_routine_screen(this.data);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
      body: AnimatedContainer(

        decoration: BoxDecoration(color: Colors.purple.shade50,image: DecorationImage(image: AssetImage("assets/images/back_ground.png"),fit: BoxFit.fitHeight)),
        duration: Duration(seconds: 2),
        child: Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
          width: 300,
          height: 400,
          decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(temp_opacity), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: const Text(
                            "ADD NEW WORKOUT!",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          )))),
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.all(13),
                        width: 200,
                        child: TextField(
                          onTap: (){
                            setState(() {
                              temp_opacity=1;
                            });
                          },
                          controller: add_routine_name_controller,
                          decoration:const  InputDecoration(

                              hintText: "Routine Name",
                              prefixIcon: Icon(Icons.sports_gymnastics)),
                        )),
                    Container(
                        margin: EdgeInsets.all(13),
                        width: 200,
                        child: TextField(
                          onTap: (){
                            setState(() {
                              temp_opacity=1;
                            });
                          },

                          controller: add_strategy_name_controller,
                          decoration: const InputDecoration(

                              hintText: "Strategy Name",
                              prefixIcon: Icon(Icons.sports_gymnastics)),
                        )),Container(height: 16,child: Text(warning,style: TextStyle(color: Colors.red),)),
                    Container(
                      margin: EdgeInsets.all(13),
                      child: ElevatedButton(
                          onPressed: () {
                            if(add_routine_name_controller.text.toString()!="" &&add_strategy_name_controller.text.toString()!=""){
                                warning="";
                              data.weekdays.add(Weekdays(
                                add_routine_name_controller.text.toString(),
                                add_strategy_name_controller.text.toString(),
                                [],
                                0));
                                Navigator.pop(context);}
                            else
                              {warning="Please Enter all feilds";
                              }
                            setState(() {

                            });

                            },
                          child: Text("Add New Routine!")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
