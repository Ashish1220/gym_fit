import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Container(
        width: 411,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Gym-Fit", style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
            Container(height: 50, child: Image.asset('assets/images/logo.png')),
          ],
        ),
      ),
    );
  }
}
