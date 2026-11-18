import 'package:firebase_test/app_state.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'todo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApplicationState appState = ApplicationState();

  runApp(MainApp(appState: appState));
}

class MainApp extends StatelessWidget {
  const MainApp({required this.appState, super.key});

  final ApplicationState appState;

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) {
        return HomePage(appState: appState);
      },
      '/sign-in': (context) {
        return SignInScreen(
          actions: [
            AuthStateChangeAction((context, state) {
              final user = switch (state) {
                SignedIn state => state.user,
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
        return ProfileScreen(
          actions: [
            SignedOutAction((context) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            })
          ],
        );
      },
      '/todos': (context) {
        return TodoPage(appState: appState);
      }
    };

    return MaterialApp(
      title: 'Firebase UI Auth Demo',
      routes: routes,
      onGenerateRoute: (settings) {
        if (settings.name == '/todos') {
          if (appState.loggedIn) {
            return MaterialPageRoute(builder: (context) {
              return TodoPage(appState: appState);
            });
          } else {
            return MaterialPageRoute(builder: (context) {
              return HomePage(appState: appState);
            });
          }
        }
        return null;
      },
    );
  }
}
