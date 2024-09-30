class UserModel{
  final String _id;
  final String _name;
  final String _email;
  final String _password;
  
  UserModel(this._id, this._name, this._email, this._password);

  String get id => _id;
  String get name => _name;
  String get email => _email;

  // Validações
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(_email);
  }

  bool isValidPassword() {
    // Exemplo: mínimo de 6 caracteres
    return _password.length >= 6;
  }

}