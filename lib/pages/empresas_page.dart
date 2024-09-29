import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpresasPage extends StatefulWidget {
  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  final TextEditingController _cnpjController = TextEditingController();
  String _nome = '';
  String _cnpj = '';
  String _endereco = '';

  @override
  Widget build(BuildContext context) {
    Future<void> buscarEmpresaCNPJBiz(String cnpj) async {
      final url = 'https://www.receitaws.com.br/v1/cnpj/$cnpj';

      void _showErrorDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text(
                  'Erro ao buscar informações:\n \n -Confira se o CNPJ está correto \n -Verifique a conexão com a internet'),
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
      }

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _nome = data['nome'];
            _cnpj = data['cnpj'];
            _endereco = '${data['logradouro']}, ${data['numero']}';
          });
        } else {
          print('Erro ao buscar informações: ${response.statusCode}');
        }
      } catch (e) {
        print('Exceção: $e');
        _showErrorDialog();
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cnpjController,
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
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String cnpj = _cnpjController.text;
                buscarEmpresaCNPJBiz(cnpj);
              },
              child: Text('Buscar Empresa'),
            ),
            SizedBox(height: 20),
            Text(
              'Nome: $_nome',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'CNPJ: $_cnpj',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Endereço: $_endereco',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
