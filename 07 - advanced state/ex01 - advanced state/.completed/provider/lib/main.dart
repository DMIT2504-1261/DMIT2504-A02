import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'pages/home_page.dart';

void main() {
  // Wrap the MainApp in our ChangeNotifierProvider, which
  // will provide access to our User state object in the Widget
  // tree
  runApp(ChangeNotifierProvider(
    create: (context) => User('Jane', 'Doe'),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}
