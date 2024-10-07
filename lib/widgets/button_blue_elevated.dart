import 'package:flutter/material.dart';

class ElevatedButtonBlue extends StatelessWidget {
  final String buttonText;

  final String router;

  const ElevatedButtonBlue({super.key, required this.buttonText, required this.router});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size(200, 50)),
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.all(
            const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/$router');
      },
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
