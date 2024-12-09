import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Provides Hive-specific widgets like ValueListenableBuilder
import 'package:learning_hive/boxes.dart'; // Utility to access Hive boxes
import 'package:learning_hive/models/notes_model.dart'; // NotesModel class for Hive data
import 'package:learning_hive/widgets/note_dialog.dart'; // Custom reusable dialog for add/edit
import 'dart:math'; // For random color selection

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // List of pastel colors for the note cards
  final List<Color> pastelColors = [
    const Color(0xFFFFC1E3),
    const Color(0xFFFFD6A5),
    const Color(0xFFFFF59D),
    const Color(0xFFA5FFD6),
    const Color(0xFFA5D8FF),
    const Color(0xFFD7A5FF),
  ];

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for contrast
      appBar: AppBar(
        title: const Text('Notes',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 100,
      ),

      //Read
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          //----------------------------------------------------------------------------
          //This is retrieving all notes from the Hive box and converts them to a list.
          final notes = box.values.toList().cast<NotesModel>(); 
          //-----------------------------------------------------------------------------
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: pastelColors[random.nextInt(pastelColors.length)],
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: SizedBox(
                  height: 130,
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      note.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => _showEditDialog(note),
                        ),

                        //Delete
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => note.delete(), //.delete removes the note from Hive box
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  //Create
  Future<void> _showAddDialog() async {
    titleController.clear();
    descriptionController.clear();
    await NoteDialog.show(
      context: context,
      title: 'Add Note',
      titleController: titleController,
      descriptionController: descriptionController,
      onSave: () {
        final newNote = NotesModel(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
        );
        Boxes.getData().add(newNote); //.add is used to add a new note to the Hive box
        Navigator.pop(context);
      },
    );
  }

  //Update
  Future<void> _showEditDialog(NotesModel note) async {
    titleController.text = note.title;
    descriptionController.text = note.description;
    await NoteDialog.show(
      context: context,
      title: 'Edit Note',
      titleController: titleController,
      descriptionController: descriptionController,
      onSave: () {
        note.title = titleController.text.trim(); //Updates the title
        note.description = descriptionController.text.trim(); // Updates the description
        note.save(); //Save changes back to the Hive box
        Navigator.pop(context);
      },
    );
  }
}


/**

Create:
_showAddDialog	
box.add(object)	
Adds a new NotesModel to the Hive box.


Read:
ValueListenableBuilder	
box.values	
Reads all NotesModel objects from the Hive box.


Update:
_showEditDialog	object.save()	
Modifies an existing note and saves changes to Hive.

Delete:	
IconButton in ListTile	
object.delete()	
Deletes a specific note from the Hive box.


 */