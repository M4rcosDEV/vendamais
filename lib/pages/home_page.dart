import 'dart:io';

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
    String? imagePath = Provider.of<MyAppState>(context).imagePath;

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
              padding: EdgeInsets.all(0),
              decoration:
                  BoxDecoration(color: const Color.fromARGB(255, 15, 95, 161)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: imagePath != null &&
                                  imagePath.isNotEmpty
                              ? FileImage(File(imagePath))
                              : const AssetImage('assets/images/profile.jpg')
                                  as ImageProvider,
                          child: (imagePath == null || imagePath.isEmpty)
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Marcos Vinícius',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'marcosifba01@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
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
              leading: Icon(Icons.sledding),
              title: Text('Ainda to pensando'),
              onTap: () {
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            ExpansionTile(
              shape: Border(
                  right: BorderSide(
                color: const Color.fromARGB(255, 0, 140, 255),
              )),
              leading: Icon(Icons.business),
              title: Text('Empresas'),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Cadastrar Empresa'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Placeholder()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Ver Empresas'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmpresasPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text('Relatórios'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Placeholder()),
                    );
                  },
                ),
              ],
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
          physics: NeverScrollableScrollPhysics(),
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
