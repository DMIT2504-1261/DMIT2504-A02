# Advanced State Management

We've been managing state with `StatefulWidget` and `setState()`. That works when state is local to one widget, but it breaks down when multiple pages need the same data. How does the First Name Page know the user's name changed on the Last Name Page?

In this demo we refactor the same app three different ways, each one solving the problem more cleanly than the last. By the end, you'll understand why `Provider` is the recommended approach and when you don't need it at all.

**Readings:**
- [State management introduction](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)
- [State management options](https://docs.flutter.dev/data-and-backend/state-mgmt/options)


---

## Table of Contents

0. [The Starter App](#0-the-starter-app)
1. [ChangeNotifier: Refactor the User Model](#1-changenotifier-refactor-the-user-model)
2. [ChangeNotifier: Update HomePage to Pass State](#2-changenotifier-update-homepage-to-pass-state)
3. [ChangeNotifier: Wire Up Pages with ListenableBuilder](#3-changenotifier-wire-up-pages-with-listenablebuilder)
4. [Test the ChangeNotifier Stage](#4-test-the-changenotifier-stage)
5. [InheritedNotifier: Create UserNotifier Widget](#5-inheritednotifier-create-usernotifier-widget)
6. [InheritedNotifier: Rewire main.dart and All Pages](#6-inheritednotifier-rewire-maindart-and-all-pages)
7. [Test the InheritedNotifier Stage](#7-test-the-inheritednotifier-stage)
8. [Provider: Install and Update main.dart](#8-provider-install-and-update-maindart)
9. [Provider: Update Pages to Use Consumer](#9-provider-update-pages-to-use-consumer)
10. [Test the Provider Stage](#10-test-the-provider-stage)
11. [FAQ / Troubleshooting](#11-faq--troubleshooting)

---

<a id="0-the-starter-app"></a>
<details>
<summary><strong>0. The Starter App</strong></summary>

Open the starter project and run it. You'll see:

- A **Home Page** with two buttons: "First Name Page" and "Last Name Page."
- Each sub-page shows hardcoded "USER_NAME HERE" text and a FloatingActionButton that does nothing.

The app has a `User` model (`lib/models/user.dart`) with private fields, getters, and setters, but nothing connects it to the UI. The pages don't know the User exists.

**The problem:** if the First Name Page updates the user's first name, the Last Name Page has no way to see that change. Right now, the pages can't even access a User object. That's what we're going to fix -- three different ways.

**Commit your starter code before we begin.**

</details>

---

<a id="1-changenotifier-refactor-the-user-model"></a>
<details>
<summary><strong>1. ChangeNotifier: Refactor the User Model</strong></summary>

The first approach uses `ChangeNotifier`, which is built into Flutter. A `ChangeNotifier` has a method called `notifyListeners()`. When you call it, every widget that's listening to this object will rebuild. Think of it as a simple event system: "something changed, everyone who cares should update."

Replace `lib/models/user.dart` with:

```dart
import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  User(String firstName, String lastName) {
    this.firstName = firstName;
    this.lastName = lastName;
  }

  String? _firstName;
  String? _lastName;

  String? get firstName => _firstName;
  String? get lastName => _lastName;

  set firstName(newFirstName) {
    _firstName = newFirstName;
    // any listeners will be notified the change to the User
    notifyListeners();
  }

  set lastName(newLastName) {
    _lastName = newLastName;
    // any listeners will be notified the change to the User
    notifyListeners();
  }
}
```

**What changed:** `User` now extends `ChangeNotifier`. Both setters call `notifyListeners()`. The getters and private fields are the same. That's it -- everything else is about how the UI connects to this object.

</details>

---

<a id="2-changenotifier-update-homepage-to-pass-state"></a>
<details>
<summary><strong>2. ChangeNotifier: Update HomePage to Pass State</strong></summary>

The HomePage will create a User object and pass it to both sub-pages via their constructors. This is "lifting state up" -- the state lives above the pages that need it.

Replace `lib/pages/home_page.dart` with:

```dart
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'first_name_page.dart';
import 'last_name_page.dart';

class HomePage extends StatelessWidget {
  // Create a new Home Page with demo User state
  HomePage({super.key}) : user = User('Jane', 'Doe');

  // App state
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
```

Also update `lib/main.dart` (remove `const` from `HomePage()`):

```dart
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}
```

**What changed:** HomePage creates `User('Jane', 'Doe')` and passes the same instance to both `FirstNamePage(user: user)` and `LastNamePage(user: user)`. Both pages will reference the same object in memory, so changes on one page are visible on the other. This is the same basic approach as passing props in React.

</details>

---

<a id="3-changenotifier-wire-up-pages-with-listenablebuilder"></a>
<details>
<summary><strong>3. ChangeNotifier: Wire Up Pages with ListenableBuilder</strong></summary>

Each sub-page needs to: (a) accept the User via its constructor, (b) display the user's name using a `ListenableBuilder` that rebuilds when `notifyListeners()` fires, and (c) update the name when the FloatingActionButton is tapped.

Replace `lib/pages/first_name_page.dart` with:

```dart
import 'package:flutter/material.dart';

import '../models/user.dart';

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            // Re-render on app state changes
            ListenableBuilder(
              listenable: user,
              builder: (BuildContext context, Widget? child) =>
                  Text('User name: ${user.firstName} ${user.lastName}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Will cause a re-render
        onPressed: () => user.firstName = 'NewFirstName',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

Replace `lib/pages/last_name_page.dart` with:

```dart
import 'package:flutter/material.dart';

import '../models/user.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            ListenableBuilder(
              listenable: user,
              builder: (BuildContext context, Widget? child) =>
                  Text('User name: ${user.firstName} ${user.lastName}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => user.lastName = 'NewLastName',
        tooltip: 'Update the last name',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

**What's happening:**

- `ListenableBuilder` watches the `user`. Its builder function re-runs every time `notifyListeners()` fires.
- The FloatingActionButton sets a new name, which triggers the setter, which calls `notifyListeners()`, which rebuilds the `ListenableBuilder`.
- These are `StatelessWidget`s. We don't need `StatefulWidget` or `setState` because `ListenableBuilder` manages the rebuilding.

</details>

---

<a id="4-test-the-changenotifier-stage"></a>
<details>
<summary><strong>4. Test the ChangeNotifier Stage</strong></summary>

Run the app.

1. **Home page:** two buttons. Tap "First Name Page."
2. See "User name: Jane Doe." Tap the update button. Name changes to "NewFirstName Doe."
3. Go back. Tap "Last Name Page." See "User name: NewFirstName Doe" -- the first name change persisted because both pages share the same User object.
4. Tap the update button. Name changes to "NewFirstName NewLastName."

**This works, but there's a problem:** every page has to accept `User` in its constructor. If you have 10 pages that need the user, that's 10 constructors to maintain. And if you stick a widget between HomePage and a sub-page, that widget has to forward the User even if it never uses it. This is called **prop drilling**, and it's the same problem React developers solve with Context or state libraries.

**Commit before the next refactor.**

</details>

---

<a id="5-inheritednotifier-create-usernotifier-widget"></a>
<details>
<summary><strong>5. InheritedNotifier: Create UserNotifier Widget</strong></summary>

Instead of passing User through constructors, we can put it into the widget tree so that any widget can look it up via `context`. That's what `InheritedNotifier` does. If this sounds familiar, it's because `Navigator.of(context)` and `Theme.of(context)` work the exact same way -- Navigator and Theme are both InheritedWidgets under the hood.

Create a new file `lib/widgets/user_notifier.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserNotifier extends InheritedNotifier<User> {
  const UserNotifier({
    super.key,
    required User user,
    required Widget child,
  }) : super(notifier: user, child: child);

  static UserNotifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserNotifier>();
  }

  static User of(BuildContext context) {
    final UserNotifier? result = maybeOf(context);
    if (result == null || result.notifier == null) {
      throw StateError('No UserInheritedNotifier found in context');
    }
    return result.notifier!;
  }
}
```

**What this does:**

- `UserNotifier` extends `InheritedNotifier<User>`. It wraps a User (our ChangeNotifier) and makes it available to any widget below it in the tree.
- `of(context)` is how downstream widgets get the User. It walks up the widget tree looking for a `UserNotifier`. If it finds one, it returns the User. If not, it throws.
- `maybeOf(context)` does the same but returns null instead of throwing. Useful if the state is optional.

</details>

---

<a id="6-inheritednotifier-rewire-maindart-and-all-pages"></a>
<details>
<summary><strong>6. InheritedNotifier: Rewire main.dart and All Pages</strong></summary>

Now we restructure the app: UserNotifier wraps above the MaterialApp, and pages pull the User from context instead of their constructor.

Replace `lib/main.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:week_08_state_test/widgets/user_notifier.dart';

import 'models/user.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

// Create the state notifier
User user = User('Jane', 'Doe');

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Need to wrap the MaterialApp because of Navigator use
    // -- Navigator is created by MaterialApp and won't pass
    // down a context that can be used by pushed pages to find
    // the UserNotifier
    return UserNotifier(
      user: user,
      child: Builder(
        builder: (BuildContext context) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HomePage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

> **Why above MaterialApp?** Navigator is created *by* MaterialApp. When you push a route, the new page gets a context from the Navigator. If UserNotifier is *inside* MaterialApp, pushed pages can't see it -- their context doesn't reach above the Navigator. The Builder creates a context that sits between UserNotifier and MaterialApp so the lookup chain works.

Replace `lib/pages/home_page.dart` with:

```dart
import 'package:flutter/material.dart';

import 'first_name_page.dart';
import 'last_name_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  builder: (context) => const FirstNamePage(),
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
                  builder: (context) => const LastNamePage(),
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
```

Replace `lib/pages/first_name_page.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:week_08_state_test/widgets/user_notifier.dart';

import '../models/user.dart';

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the user notifier
    User user = UserNotifier.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            // Re-render on app state changes
            ListenableBuilder(
              listenable: user,
              builder: (BuildContext context, Widget? child) =>
                  Text('User name: ${user.firstName} ${user.lastName}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Will cause a re-render
        onPressed: () => user.firstName = 'NewFirstName',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

Replace `lib/pages/last_name_page.dart` with:

```dart
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/user_notifier.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the user notifier
    User user = UserNotifier.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Name Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24.0,
            ),
            ListenableBuilder(
              listenable: user,
              builder: (BuildContext context, Widget? child) =>
                  Text('User name: ${user.firstName} ${user.lastName}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => user.lastName = 'NewLastName',
        tooltip: 'Update the last name',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

**What changed from the ChangeNotifier version:**

- `user.dart` is **unchanged**. ChangeNotifier still does its job.
- `home_page.dart` no longer creates a User or passes it to pages. It's back to `const HomePage`.
- Sub-pages no longer take `user` in their constructor. They call `UserNotifier.of(context)` to get it.
- **New file:** `widgets/user_notifier.dart`.
- `main.dart`: the User is a top-level variable. UserNotifier wraps above MaterialApp with a Builder.

**No more prop drilling.** Any page can call `UserNotifier.of(context)` without needing the User threaded through every constructor in the chain.

</details>

---

<a id="7-test-the-inheritednotifier-stage"></a>
<details>
<summary><strong>7. Test the InheritedNotifier Stage</strong></summary>

Run the app. Same behavior as before -- names update, changes persist across pages.

**What we gained:** no more prop drilling. Pages get the User from context.

**What's still awkward:** we had to write the entire `UserNotifier` class ourselves (the `of`/`maybeOf` methods, the super call). The `Builder` wrapper in main.dart is an unintuitive workaround. And if we needed a second piece of state (say, a Settings object), we'd have to write another InheritedNotifier class. This is exactly the kind of boilerplate that the Provider package eliminates.

**Commit before the next refactor.**

</details>

---

<a id="8-provider-install-and-update-maindart"></a>
<details>
<summary><strong>8. Provider: Install and Update main.dart</strong></summary>

The `provider` package does exactly what InheritedNotifier does, but it handles the boilerplate for you. It uses three core classes: `ChangeNotifierProvider`, `Consumer`, and `Selector`. We'll use the first two.

Install the package:

```bash
flutter pub add provider
```

Replace `lib/main.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'pages/home_page.dart';

void main() {
  // Wrap the MainApp in our ChangeNotifierProvider, which
  // will provide access to our User state object in the Widget
  // tree
  runApp(ChangeNotifierProvider(
    create: (context) => User('Jane', 'Doe'),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}
```

**What changed:**

- `ChangeNotifierProvider` wraps the entire app. It creates the User object and makes it available throughout the widget tree. Same job as our `UserNotifier`, without us writing a custom class.
- No `Builder` wrapper needed. Provider handles the context properly.
- The User is created inside `ChangeNotifierProvider`'s `create:` parameter, not as a top-level variable.
- You can delete `lib/widgets/user_notifier.dart`. Provider replaces it entirely.

</details>

---

<a id="9-provider-update-pages-to-use-consumer"></a>
<details>
<summary><strong>9. Provider: Update Pages to Use Consumer</strong></summary>

`lib/pages/home_page.dart` is **unchanged** from the InheritedNotifier version. It doesn't reference User at all.

`lib/models/user.dart` is **unchanged**. Still extends ChangeNotifier, same as step 1.

Replace `lib/pages/first_name_page.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class FirstNamePage extends StatelessWidget {
  const FirstNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        appBar: AppBar(
          title: const Text('First Name Page'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              // Re-render on state changes
              ListenableBuilder(
                listenable: user,
                builder: (BuildContext context, Widget? child) =>
                    Text('User name: ${user.firstName} ${user.lastName}'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            user.firstName = 'NEW_FIRST';
          },
          child: const Icon(Icons.update),
        ),
      ),
    );
  }
}
```

Replace `lib/pages/last_name_page.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class LastNamePage extends StatelessWidget {
  const LastNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Last Name Page'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              Text('User name: ${user.firstName} ${user.lastName}'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            user.lastName = 'NEW_LASTNAME';
          },
          child: const Icon(Icons.update),
        ),
      ),
    );
  }
}
```

**What's happening:**

- `Consumer<User>` is Provider's way of saying "give me the User from context, and rebuild this subtree whenever it changes." The builder gets `(context, user, child)`.
- No more `UserNotifier.of(context)`. No more custom InheritedNotifier class. The import is just `package:provider/provider.dart`.
- If you simply need to read a value without rebuilding, you can use `Provider.of<User>(context)` instead of `Consumer`.
- Note that `user.dart` is **completely unchanged** from step 1. The only thing that changed across all three approaches is *how the pages get access to User* and *who wires up the listening*.

</details>

---

<a id="10-test-the-provider-stage"></a>
<details>
<summary><strong>10. Test the Provider Stage</strong></summary>

Run the app. Same behavior as before. Name updates propagate across pages.

**Summary comparison:**

| Approach | How pages get state | Boilerplate | Package? |
| --- | --- | --- | --- |
| ChangeNotifier (manual pass) | Constructor args (`required this.user`) | Medium -- every page needs the param | No |
| InheritedNotifier | `UserNotifier.of(context)` | High -- write InheritedNotifier class + Builder trick | No |
| Provider | `Consumer<User>` | Low | Yes (`provider`) |

**Recommendation for your assignments:** use Provider. It's the least boilerplate, the Flutter team recommends it as the starting point for state management, and it scales cleanly if you need multiple state objects.

**Commit the final version.**

</details>

---

<a id="11-faq--troubleshooting"></a>

## 11. FAQ / Troubleshooting

| Problem | Solution |
| --- | --- |
| **`ListenableBuilder` doesn't rebuild** | Make sure the model calls `notifyListeners()` in the setter. Check that `listenable:` points to the right object. |
| **`UserNotifier.of(context)` throws "not found"** | The UserNotifier must be *above* the MaterialApp in the widget tree. If it's inside MaterialApp, pushed routes can't see it. |
| **Provider "could not find the correct Provider" error** | Same idea: ChangeNotifierProvider must wrap the MaterialApp. Make sure it's in `main()` around the app. |
| **Changes on one page don't show on the other** | Both pages must reference the *same* state object. If they create separate instances, changes won't sync. |
| **"const" error after adding User field** | A widget with mutable fields can't be `const`. Remove `const` from the constructor call and class. |
| **Consumer rebuilds but Text doesn't update** | If using `ListenableBuilder` inside `Consumer`, both are listening. Try removing `ListenableBuilder` and letting `Consumer` handle rebuilds. |
| **Import errors after refactor** | Unused imports from the previous stage. Delete imports you no longer need (e.g. `user_notifier.dart` after switching to Provider). |
| **`flutter pub add provider` fails** | Check internet connection. Try `flutter pub get` first. |
