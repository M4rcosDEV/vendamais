import 'package:flutter/material.dart';
import 'package:vendamais/models/empresa_model.dart';
import 'package:vendamais/pages/profile_page.dart';
import 'package:vendamais/services/empresa_service.dart';

import '../widgets/cnpj_Input_formatter.dart';

class EmpresasPage extends StatefulWidget {
  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage>
    with SingleTickerProviderStateMixin {
  // Implementando TickerProvider
  final EmpresaService _empresaService = EmpresaService();
  final TextEditingController _cnpjController = TextEditingController();
  List<Map<String, dynamic>> empresas = [];
  List<bool> isExpanded = []; // Lista para controlar a expansão
  bool isLoading = true;

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(
              'Erro ao buscar informações:\n\n - Confira se o CNPJ está correto \n - Verifique a conexão com a internet'),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro realizado'),
          content: Text('Empresa foi cadastrada com sucesso!'),
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

  void _showDeleteDialog(String nomeEmpresa, String idEmpresa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deletar Empresa'),
          content: Text('Deseja deletar a empresa "$nomeEmpresa"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Deletar'),
              onPressed: () {
                // Chama a função que deleta a empresa do banco de dados
                _deletarEmpresa(idEmpresa);
                Navigator.of(context).pop(); // Fecha o diálogo após a exclusão
              },
            ),
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem deletar
              },
            ),
          ],
        );
      },
    );
  }

  void _deletarEmpresa(String idEmpresa) async {
    // Aqui você pode chamar o serviço que deleta a empresa do banco de dados
    await _empresaService.deleteEmpresa(idEmpresa);
    // Atualiza a lista de empresas após deletar
    _carregarEmpresas();
  }

  Future<void> _getEmpresa() async {
    String cnpj = _cnpjController.text;
    if (cnpj.isEmpty) {
      _showErrorDialog();
      return;
    }

    EmpresaModel? empresa = await _empresaService.buscarEmpresaPorCNPJ(cnpj);
    if (empresa != null) {
      setState(() {
        empresas.add({
          'id': empresa.id,
          'nome': empresa.nome,
          'logradouro': empresa.logradouro,
          'numero': empresa.numero,
          'bairro': empresa.bairro,
          'municipio': empresa.municipio,
          'uf': empresa.uf,
          'cep': empresa.cep,
          'telefone': empresa.telefone,
          'email': empresa.email,
          'nivelId': 'Normal'
        });
        isExpanded.add(false);
      });
      await _empresaService.cadastrarEmpresa(empresa);
      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  Future<void> _carregarEmpresas() async {
    final empresasList = await _empresaService.listarEmpresas();
    setState(() {
      empresas = empresasList;
      isExpanded = List.generate(empresasList.length, (_) => false);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarEmpresas();
  }

  Future<void> _onRefresh() async {
    await _carregarEmpresas(); // Atualiza a lista de empresas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 95, 161),
        title: Text(
          'Top Vendas',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              CnpjInput(controller: _cnpjController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getEmpresa,
                child: Text('Cadastrar Empresa'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : empresas.isEmpty
                        ? Center(child: Text("Nenhuma empresa encontrada."))
                        : ListView.builder(
                            itemCount: empresas.length,
                            itemBuilder: (context, index) {
                              final empresa = empresas[index];
                              return Card(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        isExpanded[index] = !isExpanded[index];
                                      }),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.business,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          empresa['nome'] ?? 'N/A',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                            'CNPJ: ${empresa['id'] ?? 'N/A'}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () =>
                                                    _showDeleteDialog(
                                                        empresa['nome'],
                                                        empresa['id']),
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: const Color.fromARGB(
                                                      255, 255, 1, 1),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: isExpanded[index]
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'CNPJ: ${empresa['id'] ?? 'N/A'}'),
                                                  Text(
                                                      'Logradouro: ${empresa['logradouro'] ?? 'N/A'}'),
                                                  Text(
                                                      'Número: ${empresa['numero'] ?? 'N/A'}'),
                                                  Text(
                                                      'Bairro: ${empresa['bairro'] ?? 'N/A'}'),
                                                  Text(
                                                      'Município: ${empresa['municipio'] ?? 'N/A'}'),
                                                  Text(
                                                      'UF: ${empresa['uf'] ?? 'N/A'}'),
                                                  Text(
                                                      'CEP: ${empresa['cep'] ?? 'N/A'}'),
                                                  Text(
                                                      'Telefone: ${empresa['telefone'] ?? 'N/A'}'),
                                                  Text(
                                                      'Email: ${empresa['email'] ?? 'N/A'}'),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cnpjController.dispose();
    super.dispose();
  }
}
