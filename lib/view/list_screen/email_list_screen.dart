import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select All and Delete Draft'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectAllDeleteRow(),
        ),
      ),
    );
  }
}

class SelectAllDeleteRow extends StatefulWidget {
  @override
  _SelectAllDeleteRowState createState() => _SelectAllDeleteRowState();
}

class _SelectAllDeleteRowState extends State<SelectAllDeleteRow> {
  bool isSelected = false;

  void toggleSelectAll(bool? value) {
    setState(() {
      isSelected = value ?? false;
    });
  }

  void deleteDrafts() {
    // Implement your delete logic here
    print("Delete drafts");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: toggleSelectAll,
            ),
            Text('Select All'),
          ],
        ),
        TextButton(
          onPressed: deleteDrafts,
          child: Text('Delete Drafts'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
