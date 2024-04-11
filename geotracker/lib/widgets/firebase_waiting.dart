import 'package:flutter/material.dart';

class FirebaseWaiting extends StatelessWidget {
  const FirebaseWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 200, height: 200),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
