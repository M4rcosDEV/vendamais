import 'package:english_words/english_words.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendamais/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:vendamais/pages/signup_page.dart';
import 'package:vendamais/providers/user_provider.dart';
import 'package:vendamais/services/auth_email_password_service.dart';

import './services/amplify_service.dart';

//Pages
import './pages/home_page.dart';

//Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final AmplifyService amplifyService = AmplifyService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    amplifyService.configureAmplify();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MyAppState()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    print('Ocorreu  um erro ao inicializar o Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final authService = AuthEmailPasswordService();
    // authService.verificarAutenticacao(context);
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'VendeMais',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 15, 95, 161)),
        ),
        routes: {
          '/': (_) => LoginPage(),
          '/home': (_) => MyHomePage(),
          '/login': (_) => LoginPage(),
          '/cadastrar': (_) => SignupPage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  
}
