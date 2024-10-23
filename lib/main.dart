import 'package:flutter/material.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Map<String, dynamic>> _toDoItems = [];

  // Menampilkan dialog untuk menambahkan atau mengedit item
  void _showDialog([int? index]) {
    String task = index != null ? _toDoItems[index]['task'] : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Tambahkan Tugas' : 'Edit Tugas'),
          content: TextField(
            autofocus: true,
            controller: TextEditingController(text: task),
            onChanged: (value) {
              task = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(index == null ? 'Tambah' : 'Simpan'),
              onPressed: () {
                if (index == null) {
                  // Tambahkan item baru
                  if (task.isNotEmpty) {
                    setState(() {
                      _toDoItems.add({'task': task, 'isDone': false});
                    });
                  }
                } else {
                  // Edit item yang sudah ada
                  if (task.isNotEmpty) {
                    setState(() {
                      _toDoItems[index]['task'] = task;
                    });
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Membangun daftar tugas
  Widget _buildToDoList() {
    return ListView.builder(
      itemCount: _toDoItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            _toDoItems[index]['task'],
            style: TextStyle(
              decoration: _toDoItems[index]['isDone']
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          leading: Checkbox(
            value: _toDoItems[index]['isDone'],
            onChanged: (bool? value) {
              setState(() {
                _toDoItems[index]['isDone'] = value!;
              });
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _toDoItems.removeAt(index);
              });
            },
          ),
          onTap: () => _showDialog(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: _buildToDoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}