import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import './empresas_page.dart';
import './profile_page.dart';
import './favorites_page.dart';
import './settings_page.dart';
import './generator_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selecionarIndice = 0;
  final PageController _pageController = PageController();
  // ignore: unused_field
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