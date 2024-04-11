import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geotracker/widgets/loading_page.dart';
import 'package:geotracker/widgets/tag_page.dart';
import 'dart:async';
import 'package:geotracker/widgets/auth_page.dart';
import 'package:geotracker/theme_data.dart';
import 'package:geotracker/widgets/firebase_waiting.dart';

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
        // displayPage = const TagPage();
        displayPage = StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const FirebaseWaiting();
            }
            if (snapshot.hasData) {
              return const TagPage();
            }
            return const AuthPage();
          },
        );
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
