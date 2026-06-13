import 'package:flutter/material.dart';
import '../models/exam_model.dart';
import '../services/hive_service.dart';

class ExamProvider extends ChangeNotifier {
  List<ExamModel> _exams = [];

  List<ExamModel> get exams => _exams;

  void loadExams() {
    final box = HiveService.getExamBox();
    _exams = box.values.toList();
    notifyListeners();
  }

  Future<void> addExam(ExamModel exam) async {
    final box = HiveService.getExamBox();
    await box.put(exam.id, exam);
    loadExams();
  }

  Future<void> updateExam(ExamModel exam) async {
    await exam.save();
    loadExams();
  }

  Future<void> deleteExam(String id) async {
    final box = HiveService.getExamBox();
    await box.delete(id);
    loadExams();
  }
}