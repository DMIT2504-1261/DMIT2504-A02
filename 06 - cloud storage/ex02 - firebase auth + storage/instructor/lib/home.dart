import 'package:flutter/material.dart';

import 'app_state.dart';

// I should be renaming authAppState to just appState since we're about to use it for storage,
// but in the interest of moving forward with our class time, I will use a crap name instead

class HomePage extends StatelessWidget {
  const HomePage({required this.authAppState, super.key});

  final ApplicationState authAppState; // I need to import and use the auth listener class I just made

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth Demo'),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 16.0),
          // everything here is familiar to you, except for this ListenableBuilder
          // this is the other half of the 'event-listening' flow in flutter

          // notice, first of all, how this widget is stateless, but, is meant to react
          // to an auth change. 

          // what listenable builder does is take an instance that can listen to events in the app
          // (our ApplicationState, extended from ChangeNotifier), and whenever notifyListeners() fires
          // inside ApplicationState, this ListenableBuilder will be able to hear that event 
          // and rebuild/re-render the widget automatically.
          // If we used a plain builder method, nothing would update when listener notification fired.
          ListenableBuilder(
            listenable: authAppState,
            builder: (context, child) {
              return authAppState.loggedIn
                  ? Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/profile'),
                          child: const Text('Profile'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/todos'),
                          child: const Text('Todo List'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/sign-in'),
                      child: const Text('Sign In'),
                    );
            },
          )
        ],
      ),
    );
  }
}