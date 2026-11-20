import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  Todo({
    required this.description,
    required this.completed,
    this.id,
  });

  String description;
  bool completed;
  String? id;

  // this is new compared to last time!
  factory Todo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Todo(
      description: data?['description'],
      completed: data?['completed'],
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'completed': completed,
    };
  }
}