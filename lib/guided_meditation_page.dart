import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuidedMeditationPage extends StatefulWidget {
  const GuidedMeditationPage({super.key});

  @override
  State<GuidedMeditationPage> createState() => _GuidedMeditationPageState();
}

class _GuidedMeditationPageState extends State<GuidedMeditationPage> {
  int _remainingSeconds = 600; // 10 minutes
  Timer? _timer;
  bool _isRunning = false;

  void _startMeditation() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = 600;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;

        if (_remainingSeconds <= 0) {
          _finishMeditation();
        }
      });
    });
  }

  void _finishMeditation() {
    _timer?.cancel();

    // Gentle feedback when time is up
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.alert);

    setState(() {
      _isRunning = false;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Well done'),
        content: const Text(
          'You have completed the meditation. Take a moment to notice how you feel.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to previous page
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: AppBar(
        title: const Text('Guided Meditation'),
        backgroundColor: const Color(0xFFFAF5FF),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 48),

            const Icon(
              Icons.self_improvement,
              size: 100,
              color: Colors.purple,
            ),

            const SizedBox(height: 16),

            Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isRunning ? null : _startMeditation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Start',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 40),

            _buildGuidanceCard(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1BEE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'How to Practice',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A),
            ),
          ),
          SizedBox(height: 12),
          _GuidanceItem(text: 'Sit or lie down in a comfortable position'),
          _GuidanceItem(text: 'Gently close your eyes'),
          _GuidanceItem(text: 'Take a few slow, deep breaths'),
          _GuidanceItem(text: 'Allow your body to relax naturally'),
          _GuidanceItem(text: 'Let thoughts come and go without judgment'),
          _GuidanceItem(text: 'Continue for 10 minutes'),
        ],
      ),
    );
  }
}

class _GuidanceItem extends StatelessWidget {
  final String text;

  const _GuidanceItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8E24AA),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.deepPurple.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
