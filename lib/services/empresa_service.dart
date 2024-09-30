import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/empresa_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresaService {
  final String baseUrl;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EmpresaService({this.baseUrl = 'https://www.receitaws.com.br/v1/cnpj/'});

  Future<EmpresaModel?> buscarEmpresaPorCNPJ(String cnpj) async {
    String formattedCNPJ = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    final url = '$baseUrl$formattedCNPJ';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          return EmpresaModel(
              id: data['cnpj'],
              nome: data['nome'],
              logradouro: data['logradouro'],
              numero: data['numero'],
              bairro: data['bairro'],
              municipio: data['municipio'],
              uf: data['uf'],
              cep: data['cep'],
              telefone: data['telefone'],
              email: data['email'],
              nivelId: 'Normal');
        } else {
          return null;
        }
      } else {
        print('Erro ao buscar informações: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Excerção: $error');
      return null;
    }
  }

  Future<void> cadastrarEmpresa(EmpresaModel empresa) async {
    try {
      //Tirar os caracteres especiais do  CNPJ
      String cnpj = empresa.id.replaceAll(RegExp(r'[^0-9]'), '');

      await _firestore.collection('empresas').doc(cnpj).set(empresa.toJson());
      print('Empresa cadastrada com sucesso!');
    } catch (error) {
      print('Erro ao salvar empresa: $error');
    }
  }

  Future deleteEmpresa(String id) async {
    try {
      //Tirar os caracteres especiais do  CNPJ
      String cnpj = id.replaceAll(RegExp(r'[^0-9]'), '');
      await FirebaseFirestore.instance
          .collection("empresas")
          .doc(cnpj)
          .delete();
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> listarEmpresas() async {
    try {
      final snapshot = await _firestore.collection('empresas').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Erro ao buscar empresas: $error');
      return [];
    }
  }
}
