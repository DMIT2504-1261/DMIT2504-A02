import 'package:flutter/material.dart';

// Here is the start of another option for handling state:
// 1. just write a class shaped like the data you want to store
// 2. extend it from ChangeNotifier; fire notifyListeners() in the setters (when the data changes)

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
    notifyListeners();
  }

  set lastName(newLastName) {
    _lastName = newLastName;
    notifyListeners();
  }
}
