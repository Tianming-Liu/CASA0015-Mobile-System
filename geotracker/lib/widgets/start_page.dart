import 'package:flutter/material.dart';
import 'package:geotracker/widgets/loading_page.dart';
import 'package:geotracker/widgets/tag_page.dart';
import 'dart:async';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Widget displayPage;

  @override
  void initState() {
    super.initState();
    displayPage = const LoadingPage();
    Timer(
      const Duration(seconds: 2),
      () => setState(() {
        // displayPage = const HomePage();
        displayPage = const TagPage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: displayPage,
    );
  }
}
