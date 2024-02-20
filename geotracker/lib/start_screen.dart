import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color.fromARGB(255, 251, 231, 255),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_final.png',
              width: 240,
            ),
            const SizedBox(height: 40,),
            Text(
              'Go Tracking',
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(147, 0, 0, 0),
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
