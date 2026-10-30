import 'package:sqflite/sqflite.dart';   // flutter pub add sqflite


const databaseName = 'todos.db';  // this will be our filename; sqflite will create it in a platform-specific location

Future<Database> getDatabase() async {
  return openDatabase(  // opens - or, if nonexistent, creates - the file (which lives at a platform-specific path)
    databaseName,
    version: 1,
    onCreate: (Database db, int version) async {  // only runs if the db doesn't exist yet
      await db.execute('''
        CREATE TABLE todos (
          id INTEGER PRIMARY KEY,
          description TEXT,
          done INTEGER DEFAULT 0
        )
      ''');
    },
  );  
}
