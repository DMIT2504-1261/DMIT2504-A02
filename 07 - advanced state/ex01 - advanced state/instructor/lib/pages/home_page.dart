import 'package:flutter/material.dart';

import '../models/user.dart';
import 'first_name_page.dart';
import 'last_name_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key}) : user = User('Jane', 'Doe'); // pass in a user with a default value

  // if I want to pass something in a constructor, it has to be a field that exists on the class
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FirstNamePage(user: user),
                ),
              ),
              child: const Text('First Name Page'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LastNamePage(user: user),
                ),
              ),
              child: const Text('Last Name Page'),
            ),
          ],
        ),
      ),
    );
  }
}
