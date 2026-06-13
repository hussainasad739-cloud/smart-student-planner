import 'package:hive/hive.dart';

part 'assignment_model.g.dart';

@HiveType(typeId: 0)
class AssignmentModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String subject;

  @HiveField(3)
  late String dueDate;

  @HiveField(4)
  late bool isCompleted;

  @HiveField(5)
  late String description;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isCompleted = false,
    this.description = '',
  });
}