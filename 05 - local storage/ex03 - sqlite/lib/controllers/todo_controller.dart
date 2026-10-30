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

  Future<List<Todo>> getTodos() async {
    // what we get back from the db is a Map {key: value}, so we pull that, then convert its formatting
    final List<Map<String, dynamic>> todoMaps = await _db!.query(tableName);
    // e.g. [ {id: 1, description: "write code", done: false}, {...}, ]

    return List.generate(
      todoMaps.length, // number of items to generate
      (i) {            // callback: for a counter number, return each element
        return Todo(
          id: todoMaps[i]['id'],
          description: todoMaps[i]['description'],
          done: todoMaps[i]['done'] == 1,   // I need a bool not an int 0/1, so if done==1, I get true (otherwise false)
        );
      }    
    );
  }

  Future<void> addTodo(Todo todo) async {
    await _db!.insert(tableName, todo.toMap()); // insert the {key: value} representation of the instance, which is what sqflite expects
  }

  Future<void> updateTodo(Todo todo) async {
    await _db!.update(
      tableName,
      todo.toMap(),
      where: 'id = ?',      // the ? is a placeholder that gets replaced with whereArgs (tldr) to prevent SQL injection
      whereArgs: [todo.id], // otherwise, we'd just write 'id = ${todo.id}', but whereArgs escapes injection potential
    );
  }

  Future<void> deleteAllTodos() async {
    await _db!.delete(tableName);  // recall services/db.dart — if there's no db/table, it will be recreated
  }

}


