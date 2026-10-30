import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';


class TodoController {
  // we'll implement a singleton pattern where we only have one instance
  // talking to the database at any given time (to prevent desync/race conditions etc.)
  static Database? _db;             // the db we've loaded, static because it shouldn't change after initial load
  static TodoController? _instance; // the instance of this class actually to talking to the db; static because if we allowed multiple, we'd get desync

  static const tableName = 'todos';

  TodoController._internal(Database db) {
    // ._internal is a named private constructor; we won't have a public constructor, meaning:
    // code outside this file/class cannot call TodoController() (or anything on it) directly.
    // instead, we'll task getInstance with talking to the instance (part of ensuring we only have 1 controller)
    _db = db;
  }

  static TodoController getInstance(Database db) {
    // get the (single) instance of the todocontroller so all the behaviour I call
    // runs from that same single instance
    _instance ??= TodoController._internal(db);  // create or reuse instance; ??= means assign only if null
    return _instance!; // 'trust me bro' operator — _instance is nullable, compiler cries, but we know we're either reusing or creating the instance
  }

  Future<List<Todo>> getTodos() async {}

  Future<void> addTodo(Todo todo) async {}

  Future<void> updateTodo(Todo todo) async {}

  Future<void> deleteAllTodos() async {}

}


