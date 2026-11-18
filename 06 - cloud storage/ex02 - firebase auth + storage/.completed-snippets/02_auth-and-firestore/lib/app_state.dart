import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/todo.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    if (user == null) {
      throw ArgumentError('Cannot set the user to null');
    }
    _user = user;
  }

  List<Todo>? _todos;
  List<Todo>? get todos {
    if (user == null) {
      throw StateError('Cannot get todos when user is null');
    }
    return _todos;
  }

  set todos(List<Todo>? todos) {
    if (user == null) {
      throw StateError('Cannot set todos when user is null');
    }
    if (todos == null) {
      throw ArgumentError('Cannot set todos to null');
    }
    _todos = todos;
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        this.user = user;
        _fetchTodos();
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  void _fetchTodos() {
    if (user == null) {
      throw StateError('Cannot fetch todos when a user is null');
    }

    FirebaseFirestore.instance
        .collection('/todos/${user!.uid}/todos')
        .get()
        .then((snapshot) {
      todos = snapshot.docs.map((doc) {
        return Todo.fromFirestore(doc);
      }).toList();
    });
  }

  void updateTodo({required Todo todo}) {
    if (user == null) {
      throw StateError('Cannot update a todo when the user is null');
    }

    FirebaseFirestore.instance
        .collection('/todos/${user!.uid}/todos')
        .doc(todo.id)
        .update(todo.toMap());
  }

  void deleteTodo({required Todo todo}) {
    if (user == null) {
      throw StateError('Cannot delete a todo when the user is null');
    }

    FirebaseFirestore.instance
        .collection('/todos/${user!.uid}/todos')
        .doc(todo.id)
        .delete()
        .then((_) {
      todos!.remove(todo);
    });
  }

  void addTodo({
    required String description,
    required bool completed,
  }) {
    if (user == null) {
      throw StateError('Cannot add a todo when the user is null');
    }

    final todo = Todo(
      description: description,
      completed: completed,
    );

    FirebaseFirestore.instance
        .collection('/todos/${user!.uid}/todos')
        .add(todo.toMap())
        .then((DocumentReference doc) {
      todo.id = doc.id;
      todos!.add(todo);
    });
  }
}
