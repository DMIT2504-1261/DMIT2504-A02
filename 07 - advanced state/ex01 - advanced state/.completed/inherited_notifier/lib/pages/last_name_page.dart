import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/user_notifier.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the user notifier
    User user = UserNotifier.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            ListenableBuilder(
              listenable: user,
              builder: (BuildContext context, Widget? child) =>
                  Text('User name: ${user.firstName} ${user.lastName}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => user.lastName = 'NewLastName',
        tooltip: 'Update the last name',
        child: const Icon(Icons.update),
      ),
    );
  }
}
