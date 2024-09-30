class NivelModel {
  final String _id;
  final String _descricao;

  NivelModel({required String id, required String descricao})
      : _id = id, _descricao = descricao;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'descricao': _descricao,
    };
  }

  factory NivelModel.fromJson(Map<String, dynamic> json) {
    return NivelModel(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
    );
  }

  String get id => _id;
  String get descricao => _descricao;
}
