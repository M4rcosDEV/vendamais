class EmpresaModel {
  //id = cnpj
  final String _id;

  final String _nome;
  final String _logradouro;
  final String _numero;
  final String _bairro;
  final String _municipio;
  final String _uf;
  final String _cep;
  final String _telefone;
  final String _email;
  final String _nivelId;

  EmpresaModel({
    required String id,
    required String nome,
    required String logradouro,
    required String numero,
    required String bairro,
    required String municipio,
    required String uf,
    required String cep,
    required String telefone,
    required String email,
    required String nivelId,
  })  : _id = id,
        _nome = nome,
        _logradouro = logradouro,
        _numero = numero,
        _bairro = bairro,
        _municipio = municipio,
        _uf = uf,
        _cep = cep,
        _telefone = telefone,
        _email = email,
        _nivelId = nivelId;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nome': _nome,
      'logradouro': _logradouro,
      'numero': _numero,
      'bairro': _bairro,
      'municipio': _municipio,
      'uf': _uf,
      'cep': _cep,
      'telefone': _telefone,
      'email': _email,
      'nivelId': _nivelId
    };
  }

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      logradouro: json['logradouro'] as String,
      numero: json['numero'] as String,
      bairro: json['bairro'] as String,
      municipio: json['municipio'] as String,
      uf: json['uf'] as String,
      cep: json['cep'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      nivelId: json['nivel'] as String,
    );
  }

  String get id => _id;
  String get nome => _nome;
  String get logradouro => _logradouro;
  String get numero => _numero;
  String get bairro => _bairro;
  String get municipio => _municipio;
  String get uf => _uf;
  String get cep => _cep;
  String get telefone => _telefone;
  String get email => _email;
  String get nivel => _nivelId;
}
