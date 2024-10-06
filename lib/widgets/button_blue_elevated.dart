import 'package:flutter/material.dart';

class ElevatedButtonBlue extends StatelessWidget {
  final String buttonText;

  const ElevatedButtonBlue({
    super.key,
    required this.buttonText,
  });

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
        // Navigate to a new route
      },
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
