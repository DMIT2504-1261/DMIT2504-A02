import 'package:flutter/material.dart';

import '../models/user.dart'; // I need to import the model in any widget file that handles its data
                              // so that I can pass the type

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            // ListenableBuilder takes some ChangeNotifier instance, and automatically rebuilds/rerenders anytime instance's data changes
            ListenableBuilder(
              listenable: user,  // the class instance that a) holds your data, b) is extended from ChangeNotifier, c) fires notifyListeners() in setters for data we care about re-rendering off of 
              builder: (BuildContext context, Widget? child) => 
                Text('User name: ${user.firstName} ${user.lastName}')
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Update our user firs name here
        onPressed: () {
          //noop;
        },
        child: const Icon(Icons.update),
      ),
    );
  }
}
