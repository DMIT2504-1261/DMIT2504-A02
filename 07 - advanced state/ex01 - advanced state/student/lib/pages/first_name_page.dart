import 'package:flutter/material.dart';

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Name Page'),
      ),
      body: const Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            Text('User name: USER_NAME HERE'),
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
