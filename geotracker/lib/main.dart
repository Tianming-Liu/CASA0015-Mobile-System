import 'package:flutter/material.dart';
import 'package:geotracker/start_screen.dart';

void main() {
  runApp(const Geotracker());
}

class Geotracker extends StatelessWidget {
  const Geotracker({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: StartScreen(),
      ),
    );
  } 
}
