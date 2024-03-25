import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              'GO TRACK',
              style: GoogleFonts.oswald(
                fontSize: 50,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 189, 189, 189),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
