import 'dart:convert';
import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
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

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  void updateImage(XFile? image) {
    _imageFile = image;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selecionarIndice = 0;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageFile = Provider.of<MyAppState>(context).imageFile;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 95, 161),
          title: Text(
            'Top Vendas',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          iconTheme:
              IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                })
          ],
        ),
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
              decoration:
                  BoxDecoration(color: const Color.fromARGB(255, 15, 95, 161)),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 50,
                  child: imageFile == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _pageController.jumpToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favoritos'),
              onTap: () {
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.view_compact_rounded),
              title: Text('Empresas'),
              onTap: () {
                _pageController.jumpToPage(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                _pageController.jumpToPage(3);
                Navigator.pop(context);
              },
            ),
          ]),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            GeneratorPage(),
            FavoritesPage(),
            EmpresasPage(),
            SettingsPage(),
          ],
        ),
      );
    });
  }
}

class EmpresasPage extends StatefulWidget {
  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  final TextEditingController _cnpjController = TextEditingController();
  String _nome = '';
  String _cnpj = '';
  String _endereco = '';

  @override
  Widget build(BuildContext context) {
    Future<void> buscarEmpresaCNPJBiz(String cnpj) async {
      final url = 'https://www.receitaws.com.br/v1/cnpj/$cnpj';

      void _showErrorDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text(
                  'Erro ao buscar informações:\n \n -Confira se o CNPJ está correto \n -Verifique a conexão com a internet'),
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

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _nome = data['nome'];
            _cnpj = data['cnpj'];
            _endereco = '${data['logradouro']}, ${data['numero']}';
          });
        } else {
          print('Erro ao buscar informações: ${response.statusCode}');
        }
      } catch (e) {
        print('Exceção: $e');
        _showErrorDialog();
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cnpjController,
              decoration: InputDecoration(
                border: InputBorder.none,
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
                labelText: 'CNPJ',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String cnpj = _cnpjController.text;
                buscarEmpresaCNPJBiz(cnpj);
              },
              child: Text('Buscar Empresa'),
            ),
            SizedBox(height: 20),
            Text(
              'Nome: $_nome',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'CNPJ: $_cnpj',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Endereço: $_endereco',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _surnameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // Escolhe a imagem da galeria

    if (image != null) {
      setState(() {
        _imageFile = image; // Armazena a imagem escolhida
      });
      print('Image Path: ${image.path}'); // Exibe o caminho da imagem
      Provider.of<MyAppState>(context, listen: false).updateImage(image);
    } else {
      print(
          'No image selected.'); // Mensagem caso nenhuma imagem seja escolhida
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: const Color.fromARGB(255, 15, 95, 161),
        title: Text(
          'Perfil',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile!.path))
                      : null,
                  child: _imageFile == null
                      ? const Icon(Icons.add_a_photo, size: 50)
                      : null),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
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
                labelText: 'Nome',
              ),
            ),
            // Campo de Apelido
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                border: InputBorder.none,
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
                labelText: 'Apelido',
              ),
            ),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: InputBorder.none,
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
                labelText: 'Email',
              ),
            ),

            // Campos de Email e Senha lado a lado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Campo de Email
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Linha cinza quando não está em foco
                        ),
                      ),
                      labelText: 'Senha',
                    ),
                    obscureText: true, // Oculta o texto da senha
                  ),
                ),
                SizedBox(width: 16), // Espaçamento entre os campos
                // Campo de Senha
                Expanded(
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Linha cinza quando não está em foco
                        ),
                      ),
                      labelText: 'Confirmar senha',
                    ),
                    obscureText: true, // Oculta o texto da senha
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favoritos.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.escolherFavorito();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
        child: Column(
      children: [
        Text('Settings'),
      ],
    ));
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favoritos.isEmpty) {
      return Center(
        child: Text('Não tem favoritos'),
      );
    }

    return SafeArea(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child:
                Text('Você tem ' '${appState.favoritos.length} favoritos: ')),
        Expanded(
            child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 4 / 3,
          ),
          children: [
            for (var favorito in appState.favoritos)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          appState.removerFavorito(favorito);
                        },
                        icon: Icon(Icons.delete_forever),
                      ),
                      Expanded(
                          child: Text(
                        favorito.asLowerCase,
                        textAlign: TextAlign.center,
                        semanticsLabel: favorito.asPascalCase,
                        overflow: TextOverflow.ellipsis,
                      ))
                    ],
                  ),
                ),
              ),
          ],
        )),
      ],
    ));
  }
}

class TituloFavoritos extends StatelessWidget {
  const TituloFavoritos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final style = theme.textTheme.displayLarge!.copyWith(
      fontSize: 30,
      color: theme.colorScheme.onPrimary,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Favoritos', style: style),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class HistoricoFavoritos extends StatefulWidget {
  @override
  State<HistoricoFavoritos> createState() => _HistoricoFavoritosState();
}

class _HistoricoFavoritosState extends State<HistoricoFavoritos> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
