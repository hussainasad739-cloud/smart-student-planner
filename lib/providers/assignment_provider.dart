import 'package:flutter/material.dart';
import '../models/assignment_model.dart';
import '../services/hive_service.dart';

class AssignmentProvider extends ChangeNotifier {
  List<AssignmentModel> _assignments = [];

  List<AssignmentModel> get assignments => _assignments;

  List<AssignmentModel> get pendingAssignments =>
      _assignments.where((a) => !a.isCompleted).toList();

  List<AssignmentModel> get completedAssignments =>
      _assignments.where((a) => a.isCompleted).toList();

  void loadAssignments() {
    final box = HiveService.getAssignmentBox();
    _assignments = box.values.toList();
    notifyListeners();
  }

  Future<void> addAssignment(AssignmentModel assignment) async {
    final box = HiveService.getAssignmentBox();
    await box.put(assignment.id, assignment);
    loadAssignments();
  }

  Future<void> updateAssignment(AssignmentModel assignment) async {
    await assignment.save();
    loadAssignments();
  }

  Future<void> deleteAssignment(String id) async {
    final box = HiveService.getAssignmentBox();
    await box.delete(id);
    loadAssignments();
  }

  Future<void> toggleComplete(AssignmentModel assignment) async {
    assignment.isCompleted = !assignment.isCompleted;
    await assignment.save();
    loadAssignments();
  }
}