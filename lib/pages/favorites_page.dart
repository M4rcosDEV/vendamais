import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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
