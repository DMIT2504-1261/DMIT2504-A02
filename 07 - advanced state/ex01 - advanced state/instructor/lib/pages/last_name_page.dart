import 'package:flutter/material.dart';

import '../models/user.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            ListenableBuilder(
              listenable: user,  // the class instance that a) holds your data, b) is extended from ChangeNotifier, c) fires notifyListeners() in setters for data we care about re-rendering off of 
              builder: (BuildContext context, Widget? child) => 
                Text('User name: ${user.firstName} ${user.lastName}')
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Update our user last name here
        onPressed: () {
          //noop;
        },
        child: const Icon(Icons.update),
      ),
    );
  }
}
