import 'package:flutter/material.dart';

class ElevatedButtonBlue extends StatelessWidget {
  final String buttonText;

  final String router;

  const ElevatedButtonBlue(
      {super.key, required this.buttonText, required this.router});

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
        // Navigator.of(context).pushNamed('/$router');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text(
                  'Rapaz tu ta achando que tem um desempregador aqui é ? Ainda to fazendo tenha calma'),
              actions: <Widget>[
                TextButton(
                  child: Text('Fechar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Rapaz estou trabalhando nisso ainda, usa o google, é mais bonito')));
      },
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
