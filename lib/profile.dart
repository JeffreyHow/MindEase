import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  String _displayName = 'Your Profile';
  int _moodCount = 0;
  List<Map<String, dynamic>> _moodEntries = [];

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadMoodEntries();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString('userName') ?? 'Your Profile';
      _nameController.text = prefs.getString('userName') ?? '';
    });
  }

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    setState(() {
      _displayName = _nameController.text.isEmpty ? 'Your Profile' : _nameController.text;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name saved successfully!')),
      );
    }
  }

  Future<void> _loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> logs = prefs.getStringList('moodLogs') ?? [];

    final List<Map<String, dynamic>> decodedLogs = logs
        .map((log) => jsonDecode(log) as Map<String, dynamic>)
        .toList();

    setState(() {
      _moodEntries = decodedLogs;
      _moodCount = decodedLogs.length;
    });
  }

  Future<void> exportWellbeingData({
    required String userName,
    required List<Map<String, dynamic>> moodEntries,
  }) async {
    final exportData = {
      "userName": userName,
      "moodEntries": moodEntries,
      "exportDate": DateTime.now().toUtc().toIso8601String(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'wellbeing-data-${DateTime.now().toIso8601String().split("T").first}.json';

    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'My Wellbeing Data Export',
    );
  }

  Future<void> _clearAllData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('userName');
    await prefs.remove('moodLogs');

    setState(() {
      _displayName = 'Your Profile';
      _nameController.clear();
      _moodEntries.clear();
      _moodCount = 0;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data has been cleared')),
      );
    }
  }

  Future<void> _confirmClearAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your data from this device. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _clearAllData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                'Profile & Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your information and privacy',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Profile Card
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
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFFC58BF2),
                          child: Icon(Icons.person_outline, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_moodCount mood entries logged',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Display Name',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your name',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black38),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _saveName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC58BF2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Privacy & Data Card
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
                      children: const [
                        Icon(Icons.shield_outlined, color: Colors.purple),
                        SizedBox(width: 8),
                        Text(
                          'Privacy & Data',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFBBDEFB)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.info_outline, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Data is Private',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'All your information is stored locally on your device. We do not collect, transmit, or store any of your personal data on external servers.',
                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () async {
                        await exportWellbeingData(
                            userName: _displayName,
                            moodEntries: _moodEntries);
                        if(mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data exported successfully!')),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.download_outlined, color: Colors.black87, size: 20),
                          SizedBox(width: 8),
                          Text('Export Your Data', style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _confirmClearAllData,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text('Clear All Data', style: TextStyle(color: Colors.red.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Our Privacy Commitment Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Privacy Commitment',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCommitmentItem('No account creation required - your privacy comes first'),
                    _buildCommitmentItem('All data stored locally on your device only'),
                    _buildCommitmentItem('No tracking, analytics, or third-party data sharing'),
                    _buildCommitmentItem('You control your data - export or delete anytime'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // About This App Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'About This App',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This mental health companion app is designed to support student well-being through daily mood tracking, mindfulness exercises, and access to mental health resources.',
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Version 1.0.0 • Built for Student Affairs',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'This app is not a substitute for professional mental health care. If you\'re experiencing a mental health crisis, please contact emergency services or a crisis hotline immediately.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommitmentItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
