import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exam_model.dart';
import '../providers/exam_provider.dart';
import '../widgets/custom_text_field.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamProvider>(context, listen: false).loadExams();
    });
  }

  void _showAddDialog() {
    final subjectController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final venueController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Add Exam',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Subject',
                    hint: 'e.g. Mathematics',
                    controller: subjectController,
                    prefixIcon: Icons.book_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter subject' : null,
                  ),
                  CustomTextField(
                    label: 'Exam Date',
                    hint: 'e.g. 25 June 2025',
                    controller: dateController,
                    prefixIcon: Icons.calendar_today_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter date' : null,
                  ),
                  CustomTextField(
                    label: 'Exam Time',
                    hint: 'e.g. 9:00 AM',
                    controller: timeController,
                    prefixIcon: Icons.access_time_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter time' : null,
                  ),
                  CustomTextField(
                    label: 'Venue (Optional)',
                    hint: 'e.g. Hall A',
                    controller: venueController,
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  CustomTextField(
                    label: 'Notes (Optional)',
                    hint: 'Any additional notes...',
                    controller: notesController,
                    prefixIcon: Icons.note_outlined,
                    maxLines: 2,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        Provider.of<ExamProvider>(context, listen: false)
                            .addExam(ExamModel(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          subject: subjectController.text,
                          examDate: dateController.text,
                          examTime: timeController.text,
                          venue: venueController.text,
                          notes: notesController.text,
                        ));
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Exam',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Exam Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFFFF6B6B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<ExamProvider>(
        builder: (context, provider, _) {
          if (provider.exams.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_outlined,
                      size: 80, color: Color(0xFFD1D5DB)),
                  SizedBox(height: 16),
                  Text('No exams scheduled!',
                      style: TextStyle(
                          fontSize: 18, color: Color(0xFF9CA3AF))),
                  Text('Tap + to add your first exam',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF9CA3AF))),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.exams.length,
            itemBuilder: (context, index) {
              final exam = provider.exams[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.event_rounded,
                        color: Color(0xFFFF6B6B)),
                  ),
                  title: Text(
                    exam.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 12, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(exam.examDate,
                              style: const TextStyle(
                                  color: Color(0xFF6B7280), fontSize: 13)),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time_outlined,
                              size: 12, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(exam.examTime,
                              style: const TextStyle(
                                  color: Color(0xFF6B7280), fontSize: 13)),
                        ],
                      ),
                      if (exam.venue.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 12, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 4),
                            Text(exam.venue,
                                style: const TextStyle(
                                    color: Color(0xFF6B7280), fontSize: 13)),
                          ],
                        ),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete Exam'),
                          content: const Text(
                              'Are you sure you want to delete this exam?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.deleteExam(exam.id);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}