import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vendamais/services/auth_google_service.dart';
import 'package:vendamais/widgets/button_blue_elevated.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool isLoading = false;
  final AuthGoogleService authService = AuthGoogleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('lib/assets/Logo.png'),
                ),
                Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 20, color: Colors.grey, fontFamily: 'Mokoto'),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20.0, bottom: 20.0, left: 60),
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
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                      prefixIcon: Icon(
                        PhosphorIconsRegular.user,
                        size: 30,
                        color: Colors.grey,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20.0, bottom: 20.0, left: 60),
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
                      hintText: 'Senha',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                      prefixIcon: Icon(
                        PhosphorIconsRegular.lock,
                        size: 30,
                        color: Colors.grey,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: _isObscure
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                    ),
                    textAlign: TextAlign.start,
                    obscureText: _isObscure,
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: Text('Esqueceu sua senha ?',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButtonBlue(buttonText: 'Entrar'),
                SizedBox(height: 20),
                Text('Ou', style: TextStyle(color: Colors.grey, fontSize: 15)),
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(200, 50)),
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)),
                      foregroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 138, 138, 138)),
                      overlayColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.5)),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Iniciar o carregamento
                      });
                      User? user = await authService.signInWithGoogle(context);
                      setState(() {
                        isLoading = false; // Finalizar o carregamento
                      });
                      if (user != null) {
                        // Usuário autenticado com sucesso
                        print("Usuário logado: ${user.displayName}");
                      } else {
                        // Falha na autenticação
                        print("Falha ao autenticar com Google");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icon-google.svg',
                          height: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Google',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrar');
                  },
                  child: Text('Cadastrar-se',
                      style:
                          TextStyle(color: Colors.blue, fontFamily: 'Mokoto')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
