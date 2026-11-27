// We're still goign to have event-driven re-rendering based on data changing,
// *but* we'll create a kind of blanket to wrap that entire element tree in, which will contain that shared state.
// then, instead of needing to drill state variables through layers of components, anything can just reach out directly
// for that blanket no matter how far up or down in the element tree it is.
import 'package:flutter/material.dart';

import '../models/user.dart';


class UserNotifier extends InheritedNotifier<User> { // an InheritedNotifier is technically a widget, so it needs a key

  const UserNotifier({
    super.key,
    required User user,      // an instance of the 'gossiping data structure' we've already made (User)
    required Widget child,   // widget/component/remainder of element tree that should be nested inside this shared state provider
  }) : super(notifier: user, child: child);
  // const SomeClass({ someClassAttr: value }) : super(parentAttr: value) 
  // -> forwarding params to the parent class's constructor 

    // we'll write something that starts to behave liek Flutter context you're already familiar with:
    // e.g. Theme.of(context) -> go upwards in the element tree until a Theme is found, and return it.
    // we're making one of these too now! "go upwards in the element tree until a User instance is found, and gimme"

    static UserNotifier? maybeOf(BuildContext context) {
      // will try to return a UserNotifier instance from context
      return context.dependOnInheritedWidgetOfExactType<UserNotifier>();
    }

    static User of(BuildContext context) {
      // 1. try to find an existing UserNotifier instance to work with
      final UserNotifier? userNotifier = maybeOf(context);
      // 2. throw an error if we don't find one
      if (userNotifier == null || userNotifier.notifier == null) {
        throw StateError('UserNotifier: Not inherited UserNotifier found in context.');
      }
      // 3. if we do, return that notifier
      return userNotifier.notifier!;  // reminder: ! says, "even though this type looks nullable, I promise you it won't be"
                                      // we ONLY EVER want to do this if we are ABSOLUTELY SURE -- never to just silence compiler problems
                                      // here, we know we'll be throwing an exception in the line above if it's null, so it's fine
    }

}


/*

  `InheritedNotifier` gives us shared state available via the widget tree's `context`.
  Any widget living below it in the tree will just call UserNotifier.of(context) to get the User. boom done

  This is the same pattern we've seen in how routing works - `Navigator.of(context)` - and theme - `Theme.of(context)`.
  Now we get to write our own stuff that works like this, accessing context.

  In production code, I would probably only have the .of() method, so I 100% throw an error 
  if there's no UserNotifier I can find above me but my intent is that UserNotifier *must* exist.

*/