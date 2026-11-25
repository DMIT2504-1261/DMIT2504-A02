import 'package:flutter/material.dart';
import 'package:week_08_state_test/widgets/user_notifier.dart';

import '../models/user.dart';

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the user notifier
    User user = UserNotifier.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            // Re-render on app state changes
            ListenableBuilder(
              listenable: user,
              builder: (BuildContext context, Widget? child) =>
                  Text('User name: ${user.firstName} ${user.lastName}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Will cause a re-render
        onPressed: () => user.firstName = 'NewFirstName',
        child: const Icon(Icons.update),
      ),
    );
  }
}
