import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendamais/models/user_model.dart';
import 'package:vendamais/providers/user_provider.dart';
import 'package:vendamais/services/prefs_auth_service.dart';

class AuthEmailPasswordService {
  Future<void> cadastrarUser(BuildContext context, String nome, String email,
      String senha, String senhaConfirm) async {
    if (senha != senhaConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Senha diferente da confirmação'),
        ),
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: senha);

        await userCredential.user!.updateDisplayName(nome);
        await userCredential.user!.reload();
        User? updatedUser = FirebaseAuth.instance.currentUser;
        Provider.of<UserProvider>(context, listen: false).setUser(
          UserModel(
            uid: updatedUser!.uid,
            displayName: updatedUser.displayName,
            email: updatedUser.email,
            photoUrl: updatedUser.photoURL,
          ),
        );
        await _saveUserData(userCredential.user);
        Navigator.of(context).pushNamed('/home');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Senha muito fraca'),
            ),
          );
          print('Senha muito fraca');
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email já existe'),
            ),
          );
          print('Email já existe');
        }
      }
    }
  }

  Future<void> _saveUserData(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('user_uid', user.uid);
      await prefs.setString('user_email', user.email ?? '');
      await prefs.setString(
          'user_displayName', user.displayName ?? 'Usuário'); // Valor padrão
      await prefs.setString(
          'user_photoUrl', user.photoURL ?? ''); // Valor padrão para a foto
      await prefs.setBool('isLoggedIn', true);
    }
  }

  Future<UserModel?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('user_uid');
    String? displayName =
        prefs.getString('user_displayName') ?? 'Usuário'; // Valor padrão
    String? email = prefs.getString('user_email');
    String? photoUrl = prefs.getString('user_photoUrl') ?? ''; // Valor padrão

    if (uid != null) {
      return UserModel(
        uid: uid,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
      );
    }

    return null; // Retorna null se não houver dados de usuário salvos
  }

  Future<void> redefinirSenha(BuildContext context, String email) async {
    // implementação da redefinição da senha
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('E-mail de redefinição de senha enviado para $email');
      Navigator.of(context).pop();
      _showEmailResetDialog(context, email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('E-mail inválido');
      } else if (e.code == 'user-not-found') {
        print('Usuário não encontrado para este e-mail');
      } else {
        print('Erro ao enviar e-mail de redefinição: ${e.message}');
      }
    }
  }

  Future<void> loginUser(
      BuildContext context, String email, String senha) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);

      await _saveUserData(userCredential.user);

      Navigator.of(context).pushNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado. Deseja se cadastrar?';
          _showRegistrationDialog(context);
          break;
        case 'invalid-credential':
          message =
              'As credenciais fornecidas são inválidas, malformadas ou expiradas';
          _showRegistrationDialog(context);
          break;
        case 'wrong-password':
          message = 'Senha incorreta. Tente novamente.';
          break;
        case 'invalid-email':
          message = 'E-mail inválido. Verifique e tente novamente.';
          break;
        case 'operation-not-allowed':
          message = 'Operação não permitida. Entre em contato com o suporte.';
          break;
        case 'too-many-requests':
          message = 'Muitas tentativas de login. Tente novamente mais tarde.';
          break;
        default:
          message = 'Erro ao realizar login: ${e.message}';
          break;
      }

      // Exibir mensagem de erro
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro'),
          content: Text('Deseja se cadastrar?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cadastrar'),
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/cadastrar');
              },
            ),
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

  void _showEmailResetDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email'),
          content: Text('Um email de recuperação foi enviado para ${email}.'),
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
}
