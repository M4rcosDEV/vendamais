import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vendamais/providers/user_provider.dart';
import 'package:vendamais/services/auth_google_service.dart';
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
  final AuthGoogleService authGoogleService = AuthGoogleService();
  var selecionarIndice = 0;
  final PageController _pageController = PageController();
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //String? imagePath = Provider.of<MyAppState>(context).imagePath;
    final user = Provider.of<UserProvider>(context).user;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
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
        drawer: SafeArea(
          child: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundImage: user.photoUrl != null &&
                                      user.photoUrl!.isNotEmpty
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null ||
                                      user.photoUrl!.isEmpty
                                  ? const Icon(Icons.person, size: 40)
                                  : null),
                        ],
                      ),
                    ),
                    Text(
                      user.displayName ?? 'Sem nome',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      (user.email ?? 'Sem email'),
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
              ListTile(
                leading: Icon(
                  PhosphorIconsRegular.signOut,
                  color: const Color.fromARGB(183, 255, 17, 0),
                ),
                title: Text('Sair',
                    style: TextStyle(
                      color: const Color.fromARGB(183, 255, 17, 0),
                    )),
                onTap: () async {
                  await authGoogleService.signOutGoogle();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ]),
          ),
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
            //FavoritesPage(),
            EmpresasPage(),
            SettingsPage(),
          ],
        ),
      );
    });
  }
}
