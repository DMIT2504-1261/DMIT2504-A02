import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;  
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// magic knowledge: firebase_auth and firebase_ui_auth both have an EmailAuthProvider,
// which would cause a name collision; we'll just want the one from firebase_ui_auth.
// objectively terrible library design to have the same name for something in two separate
// pkgs *designed to be used together*.
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/todo.dart';

// ChangeNotifier is a flutter built-in.
// if curious: https://blog.stackademic.com/a-complete-guide-to-using-changenotifier-and-changenotifierprovider-in-flutter-00f957819cf3?gi=ddc0375b3ba3

// It allows us to *listen to* certain changes in state, rather than
// having to manually fire behaviour every time we manually change state.

// It's roughly similar to how JS event listeners work, or push notifications. 
// "Something changed; everyone who is supposed to care about it should receive that news and update."

class ApplicationState extends ChangeNotifier {

  // at the end of the day, we just want access to ChangeNotifier.notifyListeners()
  // which will push all relevant state/data updates to all listeners that are configured to hear about them

  ApplicationState() { // a simple constructor
    init();  // a constructor cannot be async, and all firebase i/o *is*,
             // so that's why we pack that logic into an async function, and run that here.
  }

  // initial login state should obviously be false
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn; // getter connected to a private backing field

  Future<void> init() async {

    // make sure firebase core stuff is initialised
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // make sure firebase auth is initialised w/ email provider (since we're doing email+pw login)
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    // automatically listen for changes in auth state (true/false)
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();  // whenever that state changes, notify to all listeners (we will have to 'subscribe' them to notifications)
    });
  }
}