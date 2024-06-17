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
      body: Container(width: double.infinity,height: double.infinity,color:Colors.green.shade300,child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Container(margin:EdgeInsets.all(15),child: Text(quote[i]),),ElevatedButton(onPressed: (){Navigator.pop(context);}, child:Container(child: Text("LETs GO!")))],),),
    );
  }

}