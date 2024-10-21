import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendamais/providers/user_provider.dart';

import '../main.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user.displayName ?? 'Sem Nome'),
                    Text(user.uid ?? 'Sem ID'),
                    Text(user.email ?? 'Sem email'),  
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.abc_outlined),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
