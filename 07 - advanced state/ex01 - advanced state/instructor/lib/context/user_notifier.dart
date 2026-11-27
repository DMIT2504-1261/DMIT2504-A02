// We're still goign to have event-driven re-rendering based on data changing,
// *but* we'll create a kind of blanket to wrap that entire element tree in, which will contain that shared state.
// then, instead of needing to drill state variables through layers of components, anything can just reach out directly
// for that blanket no matter how far up or down in the element tree it is.
import 'package:flutter/material.dart';

import '../models/user.dart';


class UserNotifier {

  const UserNotifier({
    required User user,      // an instance of the 'gossiping data structure' we've already made (User)
    required Widget child,   // widget/component/remainder of element tree that should be nested inside this shared state provider

    // we'll write something that starts to behave liek Flutter context you're already familiar with:
    // e.g. Theme.of(context) -> go upwards in the element tree until a Theme is found, and return it.
    // we're making one of these too now! "go upwards in the element tree until a User instance is found, and gimme"

    static UserNotifier? maybeOf(BuildContext context) {
      // will try to return a UserNotifier instance from context
    }

    static User of(BuildContext) {
      // 1. try to find an existing UserNotifier instance to work with
      // 2. throw an error if we don't find one
      // 3. if we do, return that notifier
    }

  });

}


/*

  `InheritedNotifier` gives us shared state available via the widget tree's `context`.
  Any widget living below it in the tree will just call UserNotifier.of(context) to get the User. boom done

  This is the same pattern we've seen in how routing works - `Navigator.of(context)` - and theme - `Theme.of(context)`.
  Now we get to write our own stuff that works like this, accessing context.

  In production code, I would probably only have the .of() method, so I 100% throw an error 
  if there's no UserNotifier I can find above me but my intent is that UserNotifier *must* exist.

*/