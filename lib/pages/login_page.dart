import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendamais/models/user_model.dart';
import 'package:vendamais/providers/user_provider.dart';
import 'package:vendamais/services/auth_email_password_service.dart';
import 'package:vendamais/services/auth_google_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthGoogleService authGoogleService = AuthGoogleService();
  final AuthEmailPasswordService _authService = AuthEmailPasswordService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailResetController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool isLoading = false;

  void _limparCampos() {
    _emailResetController.clear();
  }

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
    _checkUserLoginStatusEmailAndPassword();
  }

  Future<void> _checkUserLoginStatus() async {
    bool isLoggedIn = await authGoogleService.isUserLoggedIn();
    if (isLoggedIn) {
      UserModel? userModel = await authGoogleService.loadUserData();
      if (userModel != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(userModel);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  Future<void> _checkUserLoginStatusEmailAndPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final AuthEmailPasswordService _authService = AuthEmailPasswordService();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Carrega os dados do usuário do SharedPreferences
      UserModel? userModel = await _authService.loadUserData();
      if (userModel != null) {
        // Atualiza o UserProvider com os dados do usuário
        Provider.of<UserProvider>(context, listen: false).setUser(userModel);
        // Redireciona para a tela principal
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

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
                    controller: _emailController,
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
                    controller: _passwordController,
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Redefinir senha'),
                          content: TextField(
                            controller: _emailResetController,
                            decoration: InputDecoration(
                              labelText: 'Email para recuperação',
                              labelStyle: TextStyle(fontSize: 18),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Enviar'),
                              onPressed: () {
                                _authService.redefinirSenha(
                                    context, _emailResetController.text);

                                _limparCampos();
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
                  },
                  child: Text('Esqueceu sua senha ?',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(Size(200, 50)),
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    overlayColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.5)),
                  ),
                  onPressed: () async {
                    _authService.loginUser(context, _emailController.text,
                        _passwordController.text);
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(height: 20),
                Text('Ou', style: TextStyle(color: Colors.grey, fontSize: 15)),
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
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
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    UserCredential? userCredential =
                                        await authGoogleService
                                            .signInWithGoogle();
                                    if (userCredential?.user != null) {
                                      if (mounted) {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUser(
                                          UserModel(
                                            uid: userCredential?.user!.uid,
                                            displayName: userCredential
                                                ?.user!.displayName,
                                            email: userCredential?.user!.email,
                                            photoUrl:
                                                userCredential?.user!.photoURL,
                                          ),
                                        );
                                        Navigator.of(context)
                                            .pushNamed('/home');
                                        print(
                                            'Usuário logado:  ${userCredential?.user?.displayName}');
                                      }
                                    }
                                  } catch (e) {
                                    print('Erro ao autenticar com Google: $e');
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Falha ao autenticar com Google: $e'),
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
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
