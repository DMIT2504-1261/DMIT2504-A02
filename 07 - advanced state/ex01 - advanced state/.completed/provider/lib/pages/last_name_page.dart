import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Last Name Page'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              Text('User name: ${user.firstName} ${user.lastName}'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            user.lastName = 'NEW_LASTNAME';
          },
          child: const Icon(Icons.update),
        ),
      ),
    );
  }
}
