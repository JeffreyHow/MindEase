import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  List<Map<String, dynamic>> _moodLogs = [];
  bool _isLoading = true;
  String _selectedPeriod = 'Week';

  @override
  void initState() {
    super.initState();
    _loadMoodLogs();
  }

  Future<void> _loadMoodLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('moodLogs') ?? [];

    setState(() {
      _moodLogs = logs.map((log) => jsonDecode(log) as Map<String, dynamic>).toList();
      // Sort by timestamp descending (newest first)
      _moodLogs.sort((a, b) {
        final timeA = DateTime.parse(a['timestamp']);
        final timeB = DateTime.parse(b['timestamp']);
        return timeB.compareTo(timeA);
      });
      _isLoading = false;
    });
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Great': return Icons.sentiment_very_satisfied;
      case 'Good': return Icons.sentiment_satisfied;
      case 'Okay': return Icons.sentiment_neutral;
      case 'Bad': return Icons.sentiment_dissatisfied;
      case 'Terrible': return Icons.sentiment_very_dissatisfied;
      default: return Icons.sentiment_neutral;
    }
  }

  Color _getColorForLabel(String label) {
    switch (label) {
      case 'Great': return Colors.green;
      case 'Good': return Colors.blue;
      case 'Okay': return Colors.amber;
      case 'Bad': return Colors.orange;
      case 'Terrible': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatDateTime(String isoString) {
    final dt = DateTime.parse(isoString);
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) {
      return 'Today, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    }
  }

  String _mostCommonMood() {
    if (_moodLogs.isEmpty) return '-';

    final Map<String, int> count = {};
    for (var log in _moodLogs) {
      final label = log['moodLabel'];
      count[label] = (count[label] ?? 0) + 1;
    }

    return count.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _averageScore() {
    if (_moodLogs.isEmpty) return 0.0;

    const scoreMap = {
      'Terrible': 1,
      'Bad': 2,
      'Okay': 3,
      'Good': 4,
      'Great': 5,
    };

    final total = _moodLogs.fold<int>(0, (sum, log) {
      return sum + (scoreMap[log['moodLabel']] ?? 0);
    });

    return total / _moodLogs.length;
  }

  double _moodToScore(String label) {
    switch (label) {
      case 'Great':
        return 5;
      case 'Good':
        return 4;
      case 'Okay':
        return 3;
      case 'Bad':
        return 2;
      case 'Terrible':
        return 1;
      default:
        return 3;
    }
  }

  List<Map<String, dynamic>> get _filteredLogs {
    final now = DateTime.now();

    return _moodLogs.where((log) {
      final time = DateTime.parse(log['timestamp']);
      final diffDays = now.difference(time).inDays;

      if (_selectedPeriod == 'Week') {
        return diffDays >= 0 && diffDays < 7;
      } else {
        return diffDays >= 0 && diffDays < 30;
      }
    }).toList();
  }

  List<FlSpot> get _chartSpots {
    final now = DateTime.now();
    final days = _selectedPeriod == 'Week' ? 7 : 30;

    return _filteredLogs.map((log) {
      final time = DateTime.parse(log['timestamp']);
      final diffDays = now.difference(time).inDays;

      final x = (days - 1 - diffDays).toDouble();
      final y = _moodToScore(log['moodLabel']);

      return FlSpot(x, y);
    }).toList();
  }


  List<String> get _weekLabels {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return '${_monthName(date.month)} ${date.day}';
    });
  }

  List<String> get _monthLabels {
    final now = DateTime.now();

    return List.generate(30, (i) {
      final date = now.subtract(Duration(days: 29 - i));
      return '${_monthName(date.month)} ${date.day}';
    });
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mood Tracker',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track your emotional well-being over time',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              //Stat Card
              if (_moodLogs.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.calendar_today,
                        value: _moodLogs.length.toString(),
                        label: 'Total Entries',
                        iconColor: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.sentiment_satisfied,
                        value: _mostCommonMood(),
                        label: 'Most Common',
                        iconColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.trending_up,
                        value: _averageScore().toStringAsFixed(1),
                        label: 'Avg. Score',
                        iconColor: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Mood Trends Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mood Trends',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildToggleButton('Week', _selectedPeriod == 'Week'),
                              _buildToggleButton('Month', _selectedPeriod == 'Month'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 180,
                      child: _filteredLogs.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('No data for this period'),
                        ],
                      )
                          : LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: _selectedPeriod == 'Week' ? 6 : 29,
                            minY: 1,
                            maxY: 5,
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(color: Colors.grey.shade400, width: 1),
                                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                                right: BorderSide.none,
                                top: BorderSide.none,
                              ),
                            ),

                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: _selectedPeriod == 'Week' ? 1 : 5,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();

                                    if (_selectedPeriod == 'Week') {
                                      if (index < 0 || index >= _weekLabels.length) return const SizedBox();
                                      return Text(_weekLabels[index], style: const TextStyle(fontSize: 10));
                                    } else {
                                      if (index < 0 || index >= _monthLabels.length) return const SizedBox();
                                      return Text(_monthLabels[index], style: const TextStyle(fontSize: 10));
                                    }
                                  },
                                ),
                              ),
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: _chartSpots,
                                isCurved: true,
                                color: Colors.purple,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Entries Header
              const Text(
                'Recent Entries',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Entries List
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_moodLogs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'No mood entries yet',
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start logging your daily mood to see your history here',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _moodLogs.length,
                  itemBuilder: (context, index) {
                    final log = _moodLogs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getColorForLabel(log['moodLabel']).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconForLabel(log['moodLabel']),
                              color: _getColorForLabel(log['moodLabel']),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      log['moodLabel'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      _formatDateTime(log['timestamp']),
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (log['note'] != null && log['note'].isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    log['note'],
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9C27B0) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
