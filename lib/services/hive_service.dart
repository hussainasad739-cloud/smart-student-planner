import 'package:hive_flutter/hive_flutter.dart';
import '../models/assignment_model.dart';
import '../models/note_model.dart';
import '../models/exam_model.dart';

class HiveService {
  static const String assignmentBox = 'assignments';
  static const String noteBox = 'notes';
  static const String examBox = 'exams';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AssignmentModelAdapter());
    Hive.registerAdapter(NoteModelAdapter());
    Hive.registerAdapter(ExamModelAdapter());
    await Hive.openBox<AssignmentModel>(assignmentBox);
    await Hive.openBox<NoteModel>(noteBox);
    await Hive.openBox<ExamModel>(examBox);
  }

  static Box<AssignmentModel> getAssignmentBox() {
    return Hive.box<AssignmentModel>(assignmentBox);
  }

  static Box<NoteModel> getNoteBox() {
    return Hive.box<NoteModel>(noteBox);
  }

  static Box<ExamModel> getExamBox() {
    return Hive.box<ExamModel>(examBox);
  }
}