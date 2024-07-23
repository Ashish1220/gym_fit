import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data_heirarcy.dart';
import 'database_connector.dart';
class add_new_routine extends StatefulWidget {
  var data;

  add_new_routine(this.data);

  @override
  State<StatefulWidget> createState() {
    return add_new_routine_screen(data);
  }
}

class add_new_routine_screen extends State<StatefulWidget> {
  var data;
  var warning = "";
  var add_routine_name_controller = TextEditingController();
  var add_strategy_name_controller = TextEditingController();

  add_new_routine_screen(this.data);

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
              Container(height: 50, child: Image.asset('assets/images/logo.png')),
            ],
          ),
        ),
      ),
      body: Container(
        // color: Colors.cyan.shade50,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/add_workout.jpg'),
    fit: BoxFit.cover, // You can also use BoxFit.fill
    ),),
    child: Center(
          child: Container(

            width: 300,
            height: 400,
            decoration: BoxDecoration(
                color: Colors.cyan.shade800, borderRadius: BorderRadius.circular(12),border: Border.all(
              color: Colors.cyanAccent,
              width: 5, // Specify the width of the border
            ),
              ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: const Text(
                        "ADD NEW WORKOUT!",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(13),
                        width: 200,
                        child: TextField(
                          controller: add_routine_name_controller,
                          style: TextStyle(color: Colors.white), // Text color
                          decoration: InputDecoration(
                            hintText: "Routine Name",
                            prefixIcon: Icon(Icons.sports_gymnastics, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Hint text color
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(13),
                        width: 200,
                        child: TextField(
                          controller: add_strategy_name_controller,
                          style: TextStyle(color: Colors.white), // Text color
                          decoration: InputDecoration(
                            hintText: "Strategy Name",
                            prefixIcon: Icon(Icons.sports_gymnastics, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Hint text color
                          ),
                        ),
                      ),
                      Container(
                        height: 16,
                        child: Text(
                          warning,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(13),
                        child: ElevatedButton(
                          onPressed: () {
                            if (add_routine_name_controller.text.toString() != "" &&
                                add_strategy_name_controller.text.toString() != "") {
                              warning = "";
                              data.weekdays.add(Weekdays(
                                add_routine_name_controller.text.toString(),
                                add_strategy_name_controller.text.toString(),
                                [],
                                0,
                              ));
                              DatabaseHelper helper2 = DatabaseHelper();
                              helper2.updateFirstItem(data.toJsonString());
                              Navigator.pop(context);
                            } else {
                              warning = "Please Enter all fields";
                            }
                            setState(() { });
                          },
                          child: Text("Add New Routine!"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
