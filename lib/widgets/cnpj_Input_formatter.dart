import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formattedText = '';

    if (newText.length > 0) {
      formattedText = newText.substring(0, newText.length > 2 ? 2 : newText.length);
    }
    if (newText.length > 2) {
      formattedText += '.${newText.substring(2, newText.length > 5 ? 5 : newText.length)}';
    }
    if (newText.length > 5) {
      formattedText += '.${newText.substring(5, newText.length > 8 ? 8 : newText.length)}';
    }
    if (newText.length > 8) {
      formattedText += '/${newText.substring(8, newText.length > 12 ? 12 : newText.length)}';
    }
    if (newText.length > 12) {
      formattedText += '-${newText.substring(12, newText.length > 14 ? 14 : newText.length)}';
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CnpjInput extends StatelessWidget {
  final TextEditingController controller;

  CnpjInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [CnpjInputFormatter()],
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        labelText: 'CNPJ',
      ),
    );
  }
}
