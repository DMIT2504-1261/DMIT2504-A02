import 'package:flutter/material.dart';
import 'package:week_06_sqlite/models/todo.dart';

import '../services/db.dart';
import '../models/todo.dart';
import '../controllers/todo_controller.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Todo> _todos = [];
  late int _counter = 0;             // will be determined once we fetch from db, so it won't be available immediately
  late TodoController _controller;   // set in initState, not in constructor, so it won't be available immediately

  @override
  void initState() {
    // when this component first loads, set up DB connection through the controller
    _initState();  // db stuff is async but initState can't be, so I need to pack away async functionality into its own function
    super.initState();
  }

  Future<void> _initState() async {
    _controller = TodoController.getInstance(await getDatabase());
  }

  void _addTodo() {
    setState(() {
      _todos.add(Todo(description: 'Todo $_counter', done: false));
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos Application'),
      ),
      body: Center(
        child: Column(
          children: [
            _todos.isEmpty
                ? const Text('No todos')
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _todos[index].description,
                            style: TextStyle(
                                decoration: _todos[index].done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          trailing: Checkbox(
                            value: _todos[index].done,
                            onChanged: (value) {
                              setState(() {
                                _todos[index].done = value!;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
            if (_todos.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _todos.clear();
                    _counter = 0;
                  });
                },
                child: const Text('Delete All'),
              ),
            const SizedBox(height: 96.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
