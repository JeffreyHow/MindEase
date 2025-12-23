import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mental_health_support_app_mindease/mindfulness.dart';
import 'package:mental_health_support_app_mindease/moodTracker.dart';
import 'package:mental_health_support_app_mindease/profile.dart';
import 'package:mental_health_support_app_mindease/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mental_health_support_app_mindease/breathing_exercise_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindEase',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeContent(
        onGoToResources: () => _switchTab(3),
      ),
      MoodTracker(),
      MindfulnessPage(),
      Resources(),
      Profile(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Mood'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Mindfulness'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Resources'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile'
            ),
          ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onGoToResources;

  const HomeContent({super.key,required this.onGoToResources});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _userName = '';
  Map<String, dynamic>? _lastMoodLog;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('moodLogs') ?? [];

    Map<String, dynamic>? todayLog;
    if (logs.isNotEmpty) {
      // Parse logs and find the most recent one for today
      final allLogs = logs.map((log) => jsonDecode(log) as Map<String, dynamic>).toList();
      // Sort descending
      allLogs.sort((a, b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
      
      final latest = allLogs.first;
      final logDate = DateTime.parse(latest['timestamp']);
      final now = DateTime.now();

      // Check if the log is from today
      if (logDate.year == now.year && logDate.month == now.month && logDate.day == now.day) {
        todayLog = latest;
      }
    }

    setState(() {
      _userName = prefs.getString('userName') ?? '';
      _lastMoodLog = todayLog;
    });
  }

  void _showMoodCheckInDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const MoodCheckInDialog(),
    );
    // Reload data after dialog closes (to update the card if a new mood was saved)
    _loadData();
  }

  String _getMoodQuote(String label) {
    switch (label) {
      case 'Great': return '"I\'m happy today."';
      case 'Good': return '"Feeling good!"';
      case 'Okay': return '"Just taking it one step at a time."';
      case 'Bad': return '"Tomorrow is a new day."';
      case 'Terrible': return '"It\'s okay to not be okay."';
      default: return '"Stay positive."';
    }
  }

  String _getMoodDescription(String label) {
    switch (label) {
      case 'Great': return "You're feeling great today";
      case 'Good': return "You're feeling good today";
      case 'Okay': return "You're feeling okay today";
      case 'Bad': return "You're having a tough day";
      case 'Terrible': return "You're having a really hard time";
      default: return "You've logged your mood";
    }
  }

  IconData _getMoodIcon(String label) {
     switch (label) {
      case 'Great': return Icons.sentiment_very_satisfied;
      case 'Good': return Icons.sentiment_satisfied;
      case 'Okay': return Icons.sentiment_neutral;
      case 'Bad': return Icons.sentiment_dissatisfied;
      case 'Terrible': return Icons.sentiment_very_dissatisfied;
      default: return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(String label) {
    switch (label) {
      case 'Great': return Colors.green;
      case 'Good': return Colors.blue;
      case 'Okay': return Colors.amber;
      case 'Bad': return Colors.orange;
      case 'Terrible': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Greeting
             Text(
               _userName.isEmpty ? 'Hi' : 'Hi, $_userName',
               style: const TextStyle(
                   fontSize: 22,
                   fontWeight: FontWeight.bold),
             ),
             const SizedBox(height: 4,),
             const Text(
               'How are you feeling today?',
               style: TextStyle(
                 fontSize: 14,
                 color: Colors.black54,
               ),),
             const SizedBox(height: 12,),
             // Daily Check-In Card
             InkWell(
               onTap: _showMoodCheckInDialog,
               child: Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(16),
                     gradient: _lastMoodLog == null 
                       ? const LinearGradient(colors: [Color(0xFFEDE7FF),Color(0xFFE3EEFF)])
                       : LinearGradient(colors: [
                           _getMoodColor(_lastMoodLog!['moodLabel']).withOpacity(0.1),
                           _getMoodColor(_lastMoodLog!['moodLabel']).withOpacity(0.05)
                         ]),
                 ),
                 child: _lastMoodLog == null 
                   ? Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: const [
                         CircleAvatar(
                           radius: 24,
                           backgroundColor: Colors.white,
                           child: Icon(Icons.favorite,color: Colors.purple,),
                         ),
                         SizedBox(height: 12,),
                         Text(
                           'Daily Check-In',
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         SizedBox(height: 4,),
                         Text(
                           "Tap to log how you're feeling",
                           style: TextStyle(
                             color: Colors.black54,
                           ),
                         )
                       ],
                     )
                   : Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(
                           _getMoodIcon(_lastMoodLog!['moodLabel']),
                           color: _getMoodColor(_lastMoodLog!['moodLabel']),
                           size: 48,
                         ),
                         const SizedBox(height: 12,),
                         const Text(
                           "Today's Mood Logged",
                           style: TextStyle(
                             fontSize: 14,
                             color: Colors.black87,
                           ),
                         ),
                         const SizedBox(height: 4,),
                         Text(
                           _getMoodDescription(_lastMoodLog!['moodLabel']),
                           style: const TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                             color: Colors.black87,
                           ),
                         ),
                         const SizedBox(height: 8,),
                         Text(
                           _getMoodQuote(_lastMoodLog!['moodLabel']),
                           textAlign: TextAlign.center,
                           style: const TextStyle(
                             color: Colors.black54,
                             fontStyle: FontStyle.italic,
                           ),
                         )
                       ],
                     ),
               ),
             ),
             const SizedBox(height: 12,),
             // Emergency Help Card
             Container(
               width: double.infinity,
               padding: EdgeInsets.all(16),
               decoration: BoxDecoration(
                   color: const Color(0xFFFFF1F0),
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: Color(0xFFFFCCBC))
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: const [
                   Row(
                     children: [
                       Icon(Icons.error_outline,color: Colors.red,),
                       SizedBox(width: 8,),
                       Text('Need Immediate Help?',style: TextStyle(
                           fontSize: 15
                       ),)
                     ],
                   ),
                   SizedBox(height: 2,),
                   Row(
                     children: [
                       SizedBox(width: 30,),
                       Text("If you're in crisis, please reach out for support",style: TextStyle(
                         fontSize: 12,
                         color: Colors.black54
                       ),),
                     ],
                   ),
                   SizedBox(height: 18,),
                   Row(
                     children: [
                       SizedBox(width: 30,),
                       Text('Befrienders: ',style: TextStyle(
                           fontWeight: FontWeight.bold
                       ),),
                       Text('03-7627 2929 (24/7)'),
                     ],
                   ),
                   SizedBox(height: 2,),
                   Row(
                     children: [
                       SizedBox(width: 30,),
                       Text('Talian Kasih: ',style: TextStyle(
                           fontWeight: FontWeight.bold
                       ),),
                       Text('15999 (24/7)'),
                     ],
                   ),
                   SizedBox(height: 2,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(width: 30,),
                       Text('Campus Counseling: ',style: TextStyle(
                           fontWeight: FontWeight.bold
                       ),),
                       Expanded(child: Text('03-41450123 (Mon-Fri, 8.30am - 5.30pm)')),
                     ],
                   )
                 ],
               ),
             ),
             const SizedBox(height: 12,),
             // Feature Cards
             Row(
               children: [
                 Expanded(
                   child: InkWell(
                     onTap: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (_) => const BreathingExercisePage(),
                         ),
                       );
                     },
                     child: Container(
                       padding: EdgeInsets.all(16),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(16),
                           color: Colors.white,
                           border: Border.all(color: Color(0xFFE0E0E0))
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           CircleAvatar(
                             backgroundColor: Colors.blue.withOpacity(0.3),
                             child: const Icon(Icons.air,color: Colors.blue,),
                           ),
                           const SizedBox(height: 4,),
                           const Text('Breathing'),
                           const SizedBox(height: 2,),
                           const Text('Quick calm',style: TextStyle(
                               color: Colors.black54,
                               fontSize: 12
                           ),)
                         ],
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(width: 12,),
                 Expanded(
                     child: InkWell(
                       onTap: widget.onGoToResources,
                       child: Container(
                         padding: EdgeInsets.all(16),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(16),
                             color: Colors.white,
                             border: Border.all(color: Color(0xFFE0E0E0))
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             CircleAvatar(
                               backgroundColor: Colors.green.withOpacity(0.3),
                               child: const Icon(Icons.menu_book,color: Colors.green,),
                             ),
                             const SizedBox(height: 4,),
                             const Text('Resources'),
                             const SizedBox(height: 2,),
                             const Text('Get support',style: TextStyle(
                                 color: Colors.black54,
                                 fontSize: 12
                             ),)
                           ],
                         ),
                       ),
                     ),
                   ),
               ],
             ),
             const SizedBox(height: 12,),
             // Wellness Tip
             Container(
               padding:EdgeInsets.all(16),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: Color(0xFFFFE082)),
                 color: Color(0xFFFFF8E1),
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: const [
                   Row(
                     children: [
                       Icon(Icons.lightbulb_outline,color: Colors.amber),
                       SizedBox(width: 4,),
                       Text('Daily Wellness Tip',
                         style: TextStyle(
                             fontSize: 15
                         ),),
                     ],
                   ),
                   SizedBox(height: 40,),
                   Text('Take a 5-minute break every hour when studying. Short breaks can improve focus and reduce stress.')
                 ],
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }
}

class MoodCheckInDialog extends StatefulWidget {
  const MoodCheckInDialog({super.key});

  @override
  State<MoodCheckInDialog> createState() => _MoodCheckInDialogState();
}

class _MoodCheckInDialogState extends State<MoodCheckInDialog> {
  int? _selectedMoodIndex;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Great', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.green, 'value': 5},
    {'label': 'Good', 'icon': Icons.sentiment_satisfied, 'color': Colors.blue, 'value': 4},
    {'label': 'Okay', 'icon': Icons.sentiment_neutral, 'color': Colors.amber, 'value': 3},
    {'label': 'Bad', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.orange, 'value': 2},
    {'label': 'Terrible', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.red, 'value': 1},
  ];

  Future<void> _saveMood() async {
    if (_selectedMoodIndex == null) return;

    final prefs = await SharedPreferences.getInstance();
    final moodData = {
      'moodValue': _moods[_selectedMoodIndex!]['value'],
      'moodLabel': _moods[_selectedMoodIndex!]['label'],
      'note': _noteController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Get existing logs or create new list
    List<String> logs = prefs.getStringList('moodLogs') ?? [];
    logs.add(jsonEncode(moodData));
    
    // Save updated logs
    await prefs.setStringList('moodLogs', logs);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood saved successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Expanded(
                  child: Text(
                    'How are you feeling?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Select your mood and add notes if you\'d like',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_moods.length, (index) {
                final mood = _moods[index];
                final isSelected = _selectedMoodIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMoodIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        mood['icon'],
                        color: isSelected ? mood['color'] : Colors.grey.shade300,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood['label'],
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a note about your day (optional)',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMoodIndex != null ? _saveMood : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC58BF2),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Save Mood'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
