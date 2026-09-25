import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue)
          ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Layout Demo'),
        ),
        body: const Column(
          children: [
            ProfileHeading(),
            ProfileImage('assets/images/me.jpg'),
            ProfileName('Nathan Humphrey'),
            ProfileInfo('Role', 'Developer'),
            ProfileInfo('Team', 'Front-End Main Product'),
            ProfileInfo('Handle', '@NateAtNait'),
            ProfileInfo('Supervisor', 'Sally Anne'),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String image;

  const ProfileImage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          width: 4.0,
          // I need to read from the theme (outside the scope of this component)
          // in order to colour my border, because a(n image) border colour isn't
          // within the pre-generated scope of a colour scheme.
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  final String name;

  const ProfileName(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Nathan Humphrey',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class ProfileHeading extends StatelessWidget {
  /// The heading for the profile page
  const ProfileHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Employee Profile',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfo(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
