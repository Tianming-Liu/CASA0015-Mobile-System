import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.text, this.onTap, {super.key});

  final String text;
  final void Function(String answer) onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap(text);
      },
      style: ElevatedButton.styleFrom(
        // fixedSize: const Size.fromWidth(300),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        backgroundColor: const Color.fromARGB(92, 0, 0, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
