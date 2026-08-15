import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';
import 'package:first_app/Task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List<Task> tasks = [];
  final uuid = Uuid();
  final _controller = TextEditingController();
  String selectedType = 'Work';
  @override
  void initState() {
    super.initState();
    lockTasks();
  }

  void lockTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List jsonList = jsonDecode(tasksString);
      setState(() {
        tasks = jsonList.map((e) => Task.fromJson(e)).toList();
      });
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString = jsonEncode(tasks.map((e) => e.toJson()));
    prefs.setString('tasks', tasksString);
  }

  void addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      tasks.add(
        Task(id: uuid.v4(), title: _controller.text.trim(), type: selectedType),
      );
    });
    saveTasks();
    _controller.clear();
    Navigator.pop(context);
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index] = Task(
        id: tasks[index].id,
        title: tasks[index].title,
        type: tasks[index].type,
        isDone: !tasks[index].isDone,
      );
    });
    saveTasks();
  }

  void showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "New Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Name of Task',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['Work', 'Reading', 'Personally'].map((e) {
                  return DropdownMenuItem<String>(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedType = val!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Type of Task',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: addTask, child: const Text('Add')),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showAddTaskSheet();
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text("My First App"),
        ),
        body: tasks.isEmpty
            ? const Center(
                child: Text(
                  "You don't have any Task enter + to create a new Day",
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                    child: Card(
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () => toggleTask(index),
                          icon: Icon(
                            task.isDone
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: task.isDone ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(task.type),
                        trailing: Icon(
                          task.isDone
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: task.isDone ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
