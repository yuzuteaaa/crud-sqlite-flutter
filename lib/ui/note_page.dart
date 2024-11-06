import 'package:flutter/material.dart';

import '../helpers/helper_note.dart';
import '../models/model_note.dart';
class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}
class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }
  void _loadNotes() async {
    List<Note> list = await DBHelper().getNotes();
    setState(() {
      notes = list;
    });
  }
  void _saveNote() async {
    String title = titleController.text;
    String description = descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      Note note = Note(
        title: title,
        description: description,
      );
      await DBHelper().insert(note);
      _loadNotes();
      titleController.clear();
      descriptionController.clear();
    }
  }
  void _editNote(Note note) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              note.title = titleController.text;
              note.description = descriptionController.text;
              await DBHelper().update(note);
              _loadNotes();
              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
  void _deleteNote(int id) async {
    await DBHelper().delete(id);
    _loadNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ),
          ElevatedButton(
            onPressed: _saveNote,
            child: Text('Save Note'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editNote(note),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(note.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}