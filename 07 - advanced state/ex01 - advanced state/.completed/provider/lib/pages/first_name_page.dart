import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        appBar: AppBar(
          title: const Text('First Name Page'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              // Re-render on state changes
              ListenableBuilder(
                listenable: user,
                builder: (BuildContext context, Widget? child) =>
                    Text('User name: ${user.firstName} ${user.lastName}'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            user.firstName = 'NEW_FIRST';
          },
          child: const Icon(Icons.update),
        ),
      ),
    );
  }
}
