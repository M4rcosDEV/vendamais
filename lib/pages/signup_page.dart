import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vendamais/services/auth_email_password_service.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthEmailPasswordService _authService = AuthEmailPasswordService();

  bool _isObscure = true;
  bool isLoading = false;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Future<void> cadastrarUser(String nome, String email, String senha) async {
    //   try {
    //     setState(() {
    //       isLoading = true;
    //     });

    //     // ignore: unused_local_variable
    //     UserCredential userCredential = await FirebaseAuth.instance
    //         .createUserWithEmailAndPassword(email: email, password: senha);
    //     Navigator.of(context).pushNamed('/home');
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'weak-password') {
    //       // ignore: use_build_context_synchronously
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('Senha muito fraca'),
    //         ),
    //       );
    //       print('Senha muito fraca');
    //     } else if (e.code == 'email-already-in-use') {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('Email já existe'),
    //         ),
    //       );
    //       print('Email já existe');
    //     }
    //   } finally {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }

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
                  'CADASTRO',
                  style: TextStyle(
                      fontSize: 20, color: Colors.grey, fontFamily: 'Mokoto'),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: 300,
                  child: TextField(
                    controller: _userNameController,
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
                      hintText: 'Usuário',
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
                        PhosphorIconsRegular.envelopeSimple,
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
                Container(
                  margin: EdgeInsets.all(10),
                  width: 300,
                  child: TextField(
                    controller: _confirmPasswordController,
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
                      hintText: 'Confirmar senha',
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
                SizedBox(height: 13),
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
                    _authService.cadastrarUser(
                        context,
                        _userNameController.text,
                        _emailController.text,
                        _passwordController.text);
                  },
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text('Login',
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
