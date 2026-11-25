import 'package:flutter/material.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Name Page'),
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
        // Update our user last name here
        onPressed: () {
          //noop;
        },
        child: const Icon(Icons.update),
      ),
    );
  }
}
