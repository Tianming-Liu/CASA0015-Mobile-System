import 'package:flutter/material.dart';
import 'package:geotracker/widgets/loading_page.dart';
import 'package:geotracker/widgets/tag_page.dart';
import 'dart:async';
import 'package:geotracker/widgets/auth.dart';
import 'package:geotracker/theme_data.dart';

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
        displayPage = const AuthPage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: geotrackerThemeData,
      debugShowCheckedModeBanner: false,
      home: displayPage,
    );
  }
}
