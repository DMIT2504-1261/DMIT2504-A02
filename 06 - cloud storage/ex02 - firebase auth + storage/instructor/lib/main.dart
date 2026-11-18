import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'home.dart';

// when our app runs, we want to:
Future<void> main() async {
  // make sure flutter widget processing is initialised before doing firebase stuff
  WidgetsFlutterBinding.ensureInitialized();

  // load my internal application state management
  ApplicationState authAppState = ApplicationState();

  // run the app
  runApp(MainApp(authAppState: authAppState));
}

class MainApp extends StatelessWidget {
  const MainApp({required this.authAppState, super.key});

  final ApplicationState authAppState;

  @override
  Widget build(BuildContext context) {
    // this is just routing between screens that you're already familiar with
    final routes = {
      '/': (context) {
        return HomePage(authAppState: authAppState);
      },
      '/sign-in': (context) {
        return SignInScreen( // built-in we can use from firebase_ui_auth package.
                             // fully built out UI for login & registration!
          actions: [
            // AuthStateChangeAction, SignedIn, UserCreate also all come from firebase_ui_auth package (mouse over it to confirm; this is how you find that out)
            AuthStateChangeAction((context, state) {
              final user = switch (state) {
                // this is new syntax: a switch statement without explcit cases.
                // each one of these things is a case:
                // if the state change was a SignedIn    -> existing user signed in, get the user
                // if the state change was a UserCreated -> we made a new user, get the user
                // otherwise, by default (_), return null (instead of a user)
                SignedIn state => state.user, // either null or a user
                UserCreated state => state.credential.user,
                _ => null,
              };

              if (user == null) {
                return;
              }

              if (state is UserCreated) {
                user.updateDisplayName(user.email!.split('@').first);
              }

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            }),
          ],
        );
      },
      '/profile': (context) {
        return ProfileScreen( // also a fully built out widget from firebase_ui_auth, check it out!
          actions: [
            SignedOutAction((context) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            })
          ],
        );
      }
    };

    return MaterialApp(
      title: 'Firebase UI Auth Demo',
      routes: routes,
    );
  }
}

// We now have a fully complete auth flow, and fully working UI app-side, just like that!!!! Go ahead and test it out / play with it!

