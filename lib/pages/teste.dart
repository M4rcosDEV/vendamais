import 'package:flutter/material.dart';

class TributosPage extends StatefulWidget {
  @override
  _TributosPageState createState() => _TributosPageState();
}

class _TributosPageState extends State<TributosPage> {
  final List<String> opcoes = [
    "Calcular ICMS",
    "Outras",
  ];
  bool showDetails = false; // Controla se os detalhes serão mostrados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tributos')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: opcoes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.green,
                  child: ListTile(
                    title: Text(opcoes[index]),
                    onTap: () {
                      setState(() {
                        showDetails = !showDetails; // Alterna a visibilidade
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Se showDetails for verdadeiro, exibe o conteúdo adicional
          if (showDetails) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Valor',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para calcular ou gerar resultados
                    },
                    child: Text('Calcular'),
                  ),
                  SizedBox(height: 20),
                  Text('Resultado:'),
                  // Aqui você pode adicionar um widget para exibir o resultado
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
