import 'package:flutter/material.dart';

// ChangeNotifier is a flutter built-in.
// if curious: https://blog.stackademic.com/a-complete-guide-to-using-changenotifier-and-changenotifierprovider-in-flutter-00f957819cf3?gi=ddc0375b3ba3

// It allows us to *listen to* certain changes in state, rather than
// having to manually fire behaviour every time we manually change state.

// It's roughly similar to how JS event listeners work, or push notifications. 
// "Something changed; everyone who is supposed to care about it should receive that news and update."

class ApplicationState extends ChangeNotifier {

  // at the end of the day, we just want access to ChangeNotifier.notifyListeners()
  // which will push all relevant state/data updates to all listeners that are configured to hear about them

}