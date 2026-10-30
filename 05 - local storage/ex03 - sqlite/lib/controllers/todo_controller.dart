import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';


class TodoController {
  // we'll implement a singleton pattern where we only have one instance
  // talking to the database at any given time (to prevent desync/race conditions etc.)
  static Database? _db;             // the db we've loaded, static because it shouldn't change after initial load
  static TodoController? _instance; // the instance of this class actually to talking to the db; static because if we allowed multiple, we'd get desync

  static const tableName = 'todos';

  static TodoController getInstance() {
    // get the (single) instance of the todocontroller so all the behaviour I call
    // runs from that same single instance
  }

  Future<List<Todo>> getTodos() async {}

  Future<void> addTodo(Todo todo) async {}

  Future<void> updateTodo(Todo todo) async {}

  Future<void> deleteAllTodos() async {}

}


