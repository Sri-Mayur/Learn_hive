import 'package:hive_flutter/hive_flutter.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0) // Adapter type ID
class NotesModel extends HiveObject { // Extends HiveObject for delete() and save() methods
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  NotesModel({required this.title, required this.description});
}
