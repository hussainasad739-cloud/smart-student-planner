import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/assignment_model.dart';
import '../providers/assignment_provider.dart';
import '../widgets/custom_text_field.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssignmentProvider>(context, listen: false).loadAssignments();
    });
  }

  void _showAddEditDialog({AssignmentModel? assignment}) {
    final titleController =
        TextEditingController(text: assignment?.title ?? '');
    final subjectController =
        TextEditingController(text: assignment?.subject ?? '');
    final descController =
        TextEditingController(text: assignment?.description ?? '');
    final dueDateController =
        TextEditingController(text: assignment?.dueDate ?? '');
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
                  // Handle bar
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
                  Text(
                    assignment == null ? 'Add Assignment' : 'Edit Assignment',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Title',
                    hint: 'e.g. Math Homework',
                    controller: titleController,
                    prefixIcon: Icons.title,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter a title' : null,
                  ),
                  CustomTextField(
                    label: 'Subject',
                    hint: 'e.g. Mathematics',
                    controller: subjectController,
                    prefixIcon: Icons.book_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter a subject' : null,
                  ),
                  CustomTextField(
                    label: 'Due Date',
                    hint: 'e.g. 25 June 2025',
                    controller: dueDateController,
                    prefixIcon: Icons.calendar_today_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter a due date' : null,
                  ),
                  CustomTextField(
                    label: 'Description (Optional)',
                    hint: 'Add details...',
                    controller: descController,
                    prefixIcon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        final provider = Provider.of<AssignmentProvider>(
                            context,
                            listen: false);
                        if (assignment == null) {
                          provider.addAssignment(AssignmentModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            title: titleController.text,
                            subject: subjectController.text,
                            dueDate: dueDateController.text,
                            description: descController.text,
                          ));
                        } else {
                          assignment.title = titleController.text;
                          assignment.subject = subjectController.text;
                          assignment.dueDate = dueDateController.text;
                          assignment.description = descController.text;
                          provider.updateAssignment(assignment);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        assignment == null ? 'Add Assignment' : 'Save Changes',
                        style: const TextStyle(
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

  void _deleteAssignment(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: const Text('Are you sure you want to delete this assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AssignmentProvider>(context, listen: false)
                  .deleteAssignment(id);
              Navigator.pop(context);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Assignments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, _) {
          if (provider.assignments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 80, color: Color(0xFFD1D5DB)),
                  SizedBox(height: 16),
                  Text(
                    'No assignments yet!',
                    style: TextStyle(
                        fontSize: 18, color: Color(0xFF9CA3AF)),
                  ),
                  Text(
                    'Tap + to add your first assignment',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.assignments.length,
            itemBuilder: (context, index) {
              final assignment = provider.assignments[index];
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
                  leading: GestureDetector(
                    onTap: () => provider.toggleComplete(assignment),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: assignment.isCompleted
                            ? const Color(0xFF6C63FF)
                            : Colors.transparent,
                        border: Border.all(
                          color: assignment.isCompleted
                              ? const Color(0xFF6C63FF)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                      ),
                      child: assignment.isCompleted
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  title: Text(
                    assignment.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      decoration: assignment.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: assignment.isCompleted
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF1F2937),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        assignment.subject,
                        style: const TextStyle(
                            color: Color(0xFF6C63FF), fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 12, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(
                            assignment.dueDate,
                            style: const TextStyle(
                                color: Color(0xFF9CA3AF), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Color(0xFF6C63FF)),
                        onPressed: () =>
                            _showAddEditDialog(assignment: assignment),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red),
                        onPressed: () => _deleteAssignment(assignment.id),
                      ),
                    ],
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