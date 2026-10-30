// have to make this data class match what the db table wants (or implement conversion)
//  - I need an integer id
//  - I need to remap true/false to 1/0
//  - sqlite-specific: I need to be able to represent this instance/its data as a Map {key: value} 

class Todo {
  int? id; // the db will assign the ID (since it's the primary key); nullable because a Todo not yet written to DB won't have an id yet
  String description;
  bool done;

  Todo({this.id, required this.description, required this.done});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'done': done ? 1 : 0,
    };
  }
}
