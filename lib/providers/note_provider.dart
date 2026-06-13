import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/hive_service.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  void loadNotes() {
    final box = HiveService.getNoteBox();
    _notes = box.values.toList();
    notifyListeners();
  }

  Future<void> addNote(NoteModel note) async {
    final box = HiveService.getNoteBox();
    await box.put(note.id, note);
    loadNotes();
  }

  Future<void> updateNote(NoteModel note) async {
    await note.save();
    loadNotes();
  }

  Future<void> deleteNote(String id) async {
    final box = HiveService.getNoteBox();
    await box.delete(id);
    loadNotes();
  }
}