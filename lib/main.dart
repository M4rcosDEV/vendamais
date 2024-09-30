import 'package:english_words/english_words.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

//Pages
import './pages/home_page.dart';

//Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MyApp(),
    ),);
  } catch (e) {
    print('Ocorreu  um erro ao inicializar o Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'VendeMais',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 15, 95, 161)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String? _imagePath;

  String? get imagePath => _imagePath;

  void updateImage(XFile image) {
    _imagePath = image.path; // Armazena o caminho da imagem
    notifyListeners(); // Notifica os ouvintes sobre a alteração
  }

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;


  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favoritos = <WordPair>[];

  void escolherFavorito() {
    if (favoritos.contains(current)) {
      favoritos.remove(current);
    } else {
      favoritos.add(current);
    }

    print(favoritos);
    notifyListeners();
  }

  void listarFavoritos() {
    for (var pair in favoritos) {
      print(pair);
    }

    notifyListeners();
  }

  void removerFavorito(WordPair pair) {
    favoritos.remove(pair);
    print('Nome removido : $pair');

    notifyListeners();
  }
}
