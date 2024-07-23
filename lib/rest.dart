import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class rest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return rest_screen();
  }

}

class rest_screen extends State<StatefulWidget>{
  var quote=["NO PAIN,NO GAIN!","“Take care of your body. It’s the only place you have to live.” — Jim Rohn","“Exercise should be regarded as tribute to the heart” – Gene Tunney"];
  var i =0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3),(timer){
      setState(() {
        if(i==quote.length-1){i=0;}
        else{i++;}
      });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.cyan.shade800,
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                "LET'S GO!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan.shade800,
                ),
              ),
            ),
          ],
        ),
      ),    );
  }

}