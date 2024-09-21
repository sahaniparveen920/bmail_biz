import 'package:flutter/material.dart';

class BmailTodoPage extends StatefulWidget {
  @override
  _BmailTodoPageState createState() => _BmailTodoPageState();
}

class _BmailTodoPageState extends State<BmailTodoPage> {
  List<Map<String, dynamic>> _toDoItems = [
    {'task': 'Buy groceries', 'isChecked': false},
    {'task': 'Complete Flutter project', 'isChecked': false},
    {'task': 'Call Mom', 'isChecked': false},
  ];

  TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _toDoItems.add({'task': _taskController.text, 'isChecked': false});
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _toDoItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[50],
      title: Text(
        'To-Do List',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input field to add new task
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Add a new task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        labelStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            // List of to-do items with checkboxes and delete buttons
            Expanded(
              child: ListView.builder(
                itemCount: _toDoItems.length,
                itemBuilder: (context, index) {
                  final item = _toDoItems[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Checkbox(
                        value: item['isChecked'],
                        onChanged: (newValue) {
                          setState(() {
                            item['isChecked'] = newValue!;
                          });
                        },
                      ),
                      title: Text(
                        item['task'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey[800],
                          decoration: item['isChecked'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close', style: TextStyle(color: Colors.blueGrey)),
        ),
      ],
    );
  }
}

void showToDoPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BmailTodoPage();
    },
  );
}
