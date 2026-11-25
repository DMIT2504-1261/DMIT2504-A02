import 'package:flutter/material.dart';
import 'package:week_08_state_test/widgets/user_notifier.dart';

import 'models/user.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

// Create the state notifier
User user = User('Jane', 'Doe');

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Need to wrap the MaterialApp because of Navigator use
    // -- Navigator is created by MaterialApp and won't pass
    // down a context that can be used by pushed pages to find
    // the UserNotifier
    return UserNotifier(
      user: user,
      child: Builder(
        builder: (BuildContext context) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HomePage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
