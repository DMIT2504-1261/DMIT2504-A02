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
  List<Todo> _todos = [];
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
    _getTodosFromBackend();
  }

  // if I'm transitioning from internal widget state to a local backend,
  // those are now two differing sources of truth; I have to make sure that all my data mutation
  // doesn't result in any desync between those two things. 

  // because I have a local backend, the delay time of i/o is less of a concern. 
  // so the sensible thing to do is ALWAYS write to the backend and ONLY read UI/app state from the backend.
  // -> I'm avoiding widget state and db state being in potential conflict by making sure that 
  //    I only ever write directly to the local dbfile and I only ever read widget state from it.
  
  // throughout this commit: the common pattern I'm implementing is:
  //  - db is the sole source of truth: I only write to it (not internal state); I only read to it from internal state
  //  - every time I write to the db, I refetch from the db & re-render
  Future<void> _getTodosFromBackend() async {
    // 1. read from backend
    final todos = await _controller.getTodos();
    setState(() {
      _todos = todos;
      _counter = _todos.length; // this placeholder logic; i could delete #3 and length vs. max would be out of sync
    });
  }
  
  Future<void> _addTodo(Todo todo) async {
    await _controller.addTodo(todo);
    _getTodosFromBackend();
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
                            onChanged: (value) async {  // any time I introduce i/o, it needs to be async
                              setState(() {
                                _todos[index].done = value!;
                                _controller.updateTodo(_todos[index]);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
            if (_todos.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  await _controller.deleteAllTodos();
                  _getTodosFromBackend();
                },
                child: const Text('Delete All'),
              ),
            const SizedBox(height: 96.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addTodo(Todo(description: 'Todo $_counter', done: false));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
