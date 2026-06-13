import 'package:hive/hive.dart';

part 'exam_model.g.dart';

@HiveType(typeId: 2)
class ExamModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late String examDate;

  @HiveField(3)
  late String examTime;

  @HiveField(4)
  late String venue;

  @HiveField(5)
  late String notes;

  ExamModel({
    required this.id,
    required this.subject,
    required this.examDate,
    required this.examTime,
    this.venue = '',
    this.notes = '',
  });
}