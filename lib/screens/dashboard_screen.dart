import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/assignment_provider.dart';
import '../providers/note_provider.dart';
import '../providers/exam_provider.dart';
import 'assignment_screen.dart';
import 'note_screen.dart';
import 'exam_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssignmentProvider>(context, listen: false).loadAssignments();
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
      Provider.of<ExamProvider>(context, listen: false).loadExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildStatsRow(),
              const SizedBox(height: 24),
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              _buildGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello, Student! 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  auth.userEmail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF6C63FF),
                child: Text(
                  auth.userEmail.isNotEmpty
                      ? auth.userEmail[0].toUpperCase()
                      : 'S',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: Consumer<AssignmentProvider>(
            builder: (context, provider, _) => _buildStatCard(
              'Pending',
              '${provider.pendingAssignments.length}',
              Icons.assignment_outlined,
              const Color(0xFFFF6B6B),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<NoteProvider>(
            builder: (context, provider, _) => _buildStatCard(
              'Notes',
              '${provider.notes.length}',
              Icons.note_outlined,
              const Color(0xFF4ECDC4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<ExamProvider>(
            builder: (context, provider, _) => _buildStatCard(
              'Exams',
              '${provider.exams.length}',
              Icons.event_outlined,
              const Color(0xFFFFBE0B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final items = [
      {
        'title': 'Assignments',
        'subtitle': 'Track your tasks',
        'icon': Icons.assignment_rounded,
        'color': const Color(0xFF6C63FF),
        'screen': const AssignmentScreen(),
      },
      {
        'title': 'Notes',
        'subtitle': 'Your study notes',
        'icon': Icons.note_rounded,
        'color': const Color(0xFF4ECDC4),
        'screen': const NoteScreen(),
      },
      {
        'title': 'Exams',
        'subtitle': 'Exam schedule',
        'icon': Icons.event_rounded,
        'color': const Color(0xFFFF6B6B),
        'screen': const ExamScreen(),
      },
      {
        'title': 'Profile',
        'subtitle': 'Account settings',
        'icon': Icons.person_rounded,
        'color': const Color(0xFFFFBE0B),
        'screen': const ProfileScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => item['screen'] as Widget),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}