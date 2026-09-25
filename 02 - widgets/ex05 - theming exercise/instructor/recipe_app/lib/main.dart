import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.pink);

    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        // by generating my colour scheme first, this now references something that actually exists
        scaffoldBackgroundColor: colorScheme.primary,
      ),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // like a flexbox!
                              // .stretch alignment means children fill the entire width
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: const Text(
                'My Recipe App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            Image.asset(
              'assets/images/cool.jpg',
              height: 480,
            ),
            const ListWithHeading(
              heading: "Ingredients",
              listItems: [
                "- some ingredient",
                "- some ingredient",
                "- some ingredient",
                "- some ingredient",
                "- some ingredient",
              ]
            ),
            const ListWithHeading(
              heading: "Instructions",
              listItems: [
                '1. take your cream and behold it',
                '2. whip it good',
                '3. dip a strawberry',
              ]
            ),
          ],
        ),
      ),
    );
  }
}


// I notice that the Ingredients & Instructions 'shapes' are identical,
// so I can make one component to reuse for both those purposes.
class ListWithHeading extends StatelessWidget {
  // 1. I need a constructor (input params: super.key, heading, and list<str>)
  const ListWithHeading({
    super.key,
    required this.heading,
    required this.listItems,
  });

  // 2. I need class attributes for heading & items
  final String       heading;
  final List<String> listItems;

  static const headingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);


  // 3. I need to write a build method that returns that group of elements
  @override
  Widget build(BuildContext context) {
    // I basically just take what I had inline and paste it here
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // default x-axis align will be centering
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: headingStyle,
          ),
          for (final item in listItems) Text(item),
        ],
      ),
    );
  }
}
