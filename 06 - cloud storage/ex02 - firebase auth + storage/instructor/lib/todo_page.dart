import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({required this.appState, super.key});

  final ApplicationState appState;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    // Temporary test data: will be replaced by Firestore
    _todoList.add(Todo(description: 'Buy Milk', completed: false));
    _todoList.add(Todo(description: 'Buy Eggs', completed: false));
    _todoList.add(Todo(description: 'Buy Bread', completed: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: _buildList(_todoList),
    );
  }

  Widget _buildList(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Dismissible(
          key: UniqueKey(),
          child: ListTile(
            title: Text(
              todo.description,
              style: todo.completed
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic,
                    )
                  : null,
            ),
            shape: const Border(
              bottom: BorderSide(color: Colors.grey),
            ),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (value) {
                setState(() {
                  todo.completed = value!;
                });
              },
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              todos.removeAt(index);
            });
          },
        );
      },
    );
  }
}