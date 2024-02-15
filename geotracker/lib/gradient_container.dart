import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  // initialize the widget
  const GradientContainer({super.key});
  // build the widget
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient( 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 27, 62, 91),
            Color.fromARGB(255, 1, 26, 61),
          ],
        ),
      ),
      child: const Center(
        child: Text('GO TRACKER',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }
}