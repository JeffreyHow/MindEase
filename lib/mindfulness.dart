import 'package:flutter/material.dart';
import 'package:mental_health_support_app_mindease/breathing_exercise_page.dart';
import 'package:mental_health_support_app_mindease/guided_meditation_page.dart';

class MindfulnessPage extends StatelessWidget {
  const MindfulnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or your app's background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Mindfulness',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Take a moment to center yourself',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Quick Exercises Section
              const Text(
                'Quick Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Exercise Card 1: Breathing
              _buildExerciseCard(
                icon: Icons.air,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withOpacity(0.1),
                title: 'Breathing Exercise',
                duration: '2-5 minutes',
                description: 'Calm your mind with guided breathing techniques',
                borderColor: const Color(0xFFE3F2FD),
                backgroundColor: const Color(0xFFF1F8FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BreathingExercisePage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Exercise Card 2: Meditation
              _buildExerciseCard(
                icon: Icons.psychology, // Brain icon
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withOpacity(0.1),
                title: 'Guided Meditation',
                duration: '5-10 minutes',
                description: 'Find peace with guided meditation sessions',
                borderColor: const Color(0xFFF3E5F5), // Light purple border
                backgroundColor: const Color(0xFFFAF5FF), // Very light purple bg
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GuidedMeditationPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Mindfulness Tips Section
              const Text(
                'Mindfulness Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Tip 1: Start Small
              _buildTipCard(
                icon: Icons.auto_awesome, // Sparkles icon
                iconColor: Colors.green,
                title: 'Start Small',
                description: 'Even 2 minutes of mindfulness can make a difference. Build the habit first, extend the time later.',
                borderColor: const Color(0xFFE8F5E9),
                backgroundColor: const Color(0xFFF1F8E9).withOpacity(0.5),
              ),
              const SizedBox(height: 12),

              // Tip 2: Consistency
              _buildTipCard(
                icon: Icons.waves,
                iconColor: Colors.blue,
                title: 'Consistency Over Perfection',
                description: "It's normal for your mind to wander. The practice is in noticing and gently returning your focus.",
                borderColor: const Color(0xFFE3F2FD),
                backgroundColor: const Color(0xFFE3F2FD).withOpacity(0.3),
              ),
              const SizedBox(height: 12),

              // Tip 3: Routine
              _buildTipCard(
                icon: Icons.refresh,
                iconColor: Colors.orange,
                title: 'Make It a Routine',
                description: 'Try practicing at the same time each day - morning or before bed works well for many students.',
                borderColor: const Color(0xFFFFF3E0),
                backgroundColor: const Color(0xFFFFF8E1).withOpacity(0.5),
              ),

              const SizedBox(height: 24),

              // Benefits Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FE), // Light bluish-grey background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EAF6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Benefits of Mindfulness',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBulletPoint('Reduces stress and anxiety'),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Improves focus and concentration'),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Enhances emotional regulation'),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Promotes better sleep quality'),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Increases self-awareness'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4, // Good for readability
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0), // Align dot with text
          child: Icon(Icons.circle, size: 6, color: Colors.indigoAccent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildExerciseCard({
  required IconData icon,
  required Color iconColor,
  required Color iconBgColor,
  required String title,
  required String duration,
  required String description,
  required Color borderColor,
  required Color backgroundColor,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: iconColor,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(duration,
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          Icon(Icons.play_arrow_outlined,
              color: iconColor, size: 28),
        ],
      ),
    ),
  );
}


