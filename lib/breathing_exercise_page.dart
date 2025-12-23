import 'dart:async';
import 'package:flutter/material.dart';

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String _phase = 'Inhale';
  int _countdown = 4;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.7, end: 1.2).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
  }

  void _startBreathing() {
    setState(() {
      _isRunning = true;
      _phase = 'Inhale';
      _countdown = 4;
    });

    _controller.forward();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;

        if (_countdown == 0) {
          if (_phase == 'Inhale') {
            _phase = 'Exhale';
            _countdown = 4;
            _controller.reverse();
          } else {
            _phase = 'Inhale';
            _countdown = 4;
            _controller.forward();
          }
        }
      });
    });
  }

  void _stopBreathing() {
    _timer?.cancel();
    _controller.stop();

    setState(() {
      _isRunning = false;
      _phase = 'Inhale';
      _countdown = 4;
    });
  }

  String get _guidanceText {
    return _phase == 'Inhale'
        ? 'Breathe in slowly through your nose'
        : 'Gently breathe out through your mouth';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text('4-4 Breathing'),
        backgroundColor: const Color(0xFFF1F8FF),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _phase,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_countdown',
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 40),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _isRunning ? _stopBreathing : _startBreathing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(
                _isRunning ? 'Stop' : 'Start',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            _buildGuidanceCard(),
          ],
        ),
      ),
    );
  }
}

Widget _buildGuidanceCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: const Color(0xFFE3F2FD),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFBBDEFB),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'How to Practice',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        SizedBox(height: 12),
        _GuidanceItem(text: 'Find a comfortable seated position'),
        _GuidanceItem(text: 'Focus on the breathing circle'),
        _GuidanceItem(text: 'Breathe in as the circle expands'),
        _GuidanceItem(text: 'Breathe out as the circle contracts'),
        _GuidanceItem(text: 'Continue for at least 5 cycles'),
      ],
    ),
  );
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
              color: Color(0xFF1565C0),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


