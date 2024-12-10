import 'package:flutter/material.dart';

class NoteDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required VoidCallback onSave,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 5f8457d0b5b8af45d1e9097b93f2590b67d0286f
