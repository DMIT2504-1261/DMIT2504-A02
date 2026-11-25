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
