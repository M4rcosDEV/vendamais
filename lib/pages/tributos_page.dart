import 'package:flutter/material.dart';

class TributosPage extends StatefulWidget {
  @override
  State<TributosPage> createState() => _TributosPageState();
}

class _TributosPageState extends State<TributosPage> {
  // Controladores para os dois TextFields
  final TextEditingController vlrProdControllerOption0 =
      TextEditingController();
  final TextEditingController aliquotaICMSControllerOption0 =
      TextEditingController();

  final TextEditingController vlrProdControllerOption1 =
      TextEditingController();
  final TextEditingController valorICMSControllerOption1 =
      TextEditingController();

  bool isShow = true;
  final GlobalKey<FormState> _formKeyOption0 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyOption1 = GlobalKey<FormState>();

  // Variável para armazenar o resultadoOption0
  double resultadoOption0 = 0;
  double resultadoOption1 = 0;

  // Lista de opções
  final List<String> opcoes = [
    "Calcular valor do ICMS",
    "Calcular aliquota de ICMS",
    "Outras",
  ];

  @override
  void dispose() {
    vlrProdControllerOption0.dispose();
    aliquotaICMSControllerOption0.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Tributos'))),
      body: ListView.builder(
        itemCount: opcoes.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ExpansionTile(
              shape: Border(
                  bottom: BorderSide(
                color: Colors.grey,
                width: 0,
                style: BorderStyle.solid,
              )),
              title: Text(opcoes[index]),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: index == 0 // Calcular ICMS
                      ? Column(
                          children: [
                            Form(
                              key: _formKeyOption0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: vlrProdControllerOption0,
                                      decoration: InputDecoration(
                                        labelText: 'Valor do produto',
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Valor do produto vazio';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      controller: aliquotaICMSControllerOption0,
                                      decoration: InputDecoration(
                                        labelText: 'Aliquota de ICMS',
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Valor da aliquota vazio';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKeyOption0.currentState!.validate()) {
                                  double vlrProd = double.tryParse(
                                          vlrProdControllerOption0.text) ??
                                      0;
                                  double aliqIcms = double.tryParse(
                                          aliquotaICMSControllerOption0.text) ??
                                      0;

                                  setState(() {
                                    resultadoOption0 =
                                        vlrProd * (aliqIcms / 100);
                                    print(
                                        'ResultadoOption0: $resultadoOption0');
                                    isShow = false;
                                  });
                                }
                              },
                              child: Text('Calcular'),
                            ),
                            SizedBox(height: 20),
                            Offstage(
                              offstage: isShow,
                              child: Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Text('RESULTADO'),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text('Valor do produto:'),
                                              Text(' R\$'),
                                              ValueListenableBuilder(
                                                valueListenable:
                                                    vlrProdControllerOption0,
                                                builder: (context,
                                                    TextEditingValue value,
                                                    child) {
                                                  return Text(value.text);
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text('Aliquota de ICMS: '),
                                              ValueListenableBuilder(
                                                valueListenable:
                                                    aliquotaICMSControllerOption0,
                                                builder: (context,
                                                    TextEditingValue value,
                                                    child) {
                                                  return Text(value.text);
                                                },
                                              ),
                                              Text('%'),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text('Valor do ICMS:'),
                                              Text(' R\$'),
                                              Text(resultadoOption0
                                                  .toStringAsFixed(2)),
                                            ],
                                          ),
                                        ],
                                      ))),
                            )
                          ],
                        )
                      : index == 1
                          ? Column(
                              children: [
                                Form(
                                  key: _formKeyOption1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: vlrProdControllerOption1,
                                          decoration: InputDecoration(
                                            labelText: 'Valor do produto',
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Valor do produto vazio';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              valorICMSControllerOption1,
                                          decoration: InputDecoration(
                                            labelText: 'Valor do ICMS',
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Valor do ICMS vazio';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKeyOption1.currentState!
                                        .validate()) {
                                      double vlrProd1 = double.tryParse(
                                              vlrProdControllerOption1.text) ??
                                          0;
                                      double valorIcms1 = double.tryParse(
                                              valorICMSControllerOption1
                                                  .text) ??
                                          0;

                                      setState(() {
                                        resultadoOption1 =
                                            (valorIcms1 * 100) / vlrProd1;
                                        print(
                                            'ResultadoOption0: $resultadoOption1');
                                        isShow = false;
                                      });
                                    }
                                  },
                                  child: Text('Calcular'),
                                ),
                                SizedBox(height: 20),
                                Offstage(
                                  offstage: isShow,
                                  child: Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Text('RESULTADO'),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text('Valor do produto:'),
                                                  Text(' R\$'),
                                                  ValueListenableBuilder(
                                                    valueListenable:
                                                        vlrProdControllerOption1,
                                                    builder: (context,
                                                        TextEditingValue value,
                                                        child) {
                                                      return Text(value.text);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text('Aliquota de ICMS: '),
                                                  ValueListenableBuilder(
                                                    valueListenable:
                                                        valorICMSControllerOption1,
                                                    builder: (context,
                                                        TextEditingValue value,
                                                        child) {
                                                      return Text(value.text);
                                                    },
                                                  ),
                                                  Text('%'),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text('Valor do ICMS:'),
                                                  Text(' R\$'),
                                                  Text(resultadoOption1
                                                      .toStringAsFixed(2)),
                                                ],
                                              ),
                                            ],
                                          ))),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                    "Informações adicionais sobre outras opções"),
                                // Adicione o conteúdo que deseja aqui
                              ],
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
