import 'package:flutter/material.dart';

class Resources extends StatefulWidget {
  const Resources({super.key});

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  String _selectedCategory = 'Crisis Support';
  final List<String> _categories = [
    'Crisis Support',
    'Counseling',
    'Wellness',
    'Academic',
    'Articles'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Resources',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Support and information when you need it',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                Color bgColor;
                Color textColor = isSelected ? Colors.white : Colors.black54;
                IconData? icon;

                if (isSelected) {
                  switch (category) {
                    case 'Crisis Support':
                      bgColor = const Color(0xFF9C27B0);
                      icon = Icons.error_outline;
                      break;
                    case 'Counseling':
                      bgColor = const Color(0xFF9C27B0);
                      icon = Icons.chat_bubble_outline;
                      break;
                    case 'Wellness':
                      bgColor = const Color(0xFF9C27B0);
                      icon = Icons.favorite_border;
                      break;
                    case 'Academic':
                      bgColor = const Color(0xFF9C27B0);
                      icon = Icons.school_outlined;
                      break;
                    default:
                      bgColor = const Color(0xFF9C27B0);
                      icon = Icons.article_outlined;
                  }
                } else {
                  bgColor = Colors.grey.shade200;
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          if (isSelected && icon != null) ...[
                            Icon(icon, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            category,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_selectedCategory == 'Crisis Support') _buildCrisisSupport(),
                if (_selectedCategory == 'Counseling') _buildCounseling(),
                if (_selectedCategory == 'Wellness') _buildWellness(),
                if (_selectedCategory == 'Academic') _buildAcademic(),
                if (_selectedCategory == 'Articles') _buildArticles(),
                const SizedBox(height: 24),
                _buildFAQSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisSupport() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFCDD2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "If you're in immediate danger",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Call 999 or go to your nearest hospital emergency department. Your safety is the priority.",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          title: 'Befrienders Malaysia',
          subtitle: '24/7 emotional support and suicide prevention',
          contact: '03-7627 2929',
          tagText: '24/7',
          icon: Icons.phone_in_talk,
          iconColor: Colors.red,
          iconBgColor: const Color(0xFFFFEBEE),
        ),
        _buildContactCard(
          title: 'Talian Kasih',
          subtitle: 'Government helpline for social welfare support',
          contact: '15999',
          tagText: '24/7',
          icon: Icons.phone_in_talk,
          iconColor: Colors.red,
          iconBgColor: const Color(0xFFFFEBEE),
        ),
        _buildContactCard(
          title: 'MIASA Mental Health Crisis Line',
          subtitle: 'Mental illness awareness and support',
          contact: '03-2780 6803',
          tagText: 'Mon-Fri: 9am-5pm',
          icon: Icons.phone_in_talk,
          iconColor: Colors.red,
          iconBgColor: const Color(0xFFFFEBEE),
        ),
        _buildContactCard(
          title: 'Campus Security',
          subtitle: 'Immediate assistance on campus',
          contact: '03-41450123 ',
          tagText: 'Mon-Fri: 8.30am-5.30pm',
          icon: Icons.phone_in_talk,
          iconColor: Colors.red,
          iconBgColor: const Color(0xFFFFEBEE),
        ),
      ],
    );
  }

  Widget _buildCounseling() {
    return Column(
      children: [
        _buildDetailCard(
          title: 'Student Counselling Unit',
          subtitle: 'Free confidential counselling for students',
          description:
              'Individual counselling, group therapy, and mental health support available',
          tagText: 'Mon-Fri: 8am-5pm',
          extraLink: 'counselling@university.edu.my',
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.purple,
          iconBgColor: const Color(0xFFF3E5F5),
        ),
        _buildDetailCard(
          title: 'Peer Support Groups',
          subtitle: 'Student-led support groups on various topics',
          description:
              'Anxiety, depression, stress management, grief support, and more',
          tagText: 'Various times',
          extraLink: 'Check student portal for schedules',
          icon: Icons.group_outlined,
          iconColor: Colors.purple,
          iconBgColor: const Color(0xFFF3E5F5),
        ),
        _buildDetailCard(
          title: 'MySejahtera Mental Health Resources',
          subtitle: 'Access mental health support through MySejahtera app',
          description: 'Free online mental health screening and resources',
          tagText: 'Available 24/7',
          extraLink: 'Available on MySejahtera app',
          icon: Icons.health_and_safety_outlined,
          iconColor: Colors.purple,
          iconBgColor: const Color(0xFFF3E5F5),
        ),
      ],
    );
  }

  Widget _buildWellness() {
    return Column(
      children: [
        _buildListCard(
          title: 'Student Wellness Centre',
          subtitle: 'Holistic wellness programmes and workshops',
          items: [
            'Yoga classes',
            'Meditation sessions',
            'Nutrition counselling',
            'Sleep workshops'
          ],
          icon: Icons.favorite_border,
          iconColor: Colors.green,
          iconBgColor: const Color(0xFFE8F5E9),
        ),
        _buildListCard(
          title: 'Sports & Recreation',
          subtitle: 'Physical activity for mental health',
          items: [
            'Gym access',
            'Group fitness classes',
            'Outdoor activities',
            'Sports clubs'
          ],
          icon: Icons.favorite_border,
          iconColor: Colors.green,
          iconBgColor: const Color(0xFFE8F5E9),
        ),
        _buildListCard(
          title: 'Mindfulness Programmes',
          subtitle: 'Learn meditation and stress management',
          items: [
            'Weekly meditation',
            'Mindfulness workshops',
            'Stress reduction courses',
            'Guided sessions'
          ],
          icon: Icons.favorite_border,
          iconColor: Colors.green,
          iconBgColor: const Color(0xFFE8F5E9),
        ),
      ],
    );
  }

  Widget _buildAcademic() {
    return Column(
      children: [
        _buildListCard(
          title: 'Academic Advisory',
          subtitle: 'Support for academic stress and planning',
          items: [
            'Course planning',
            'Programme selection',
            'Academic support',
            'Time management'
          ],
          icon: Icons.school_outlined,
          iconColor: const Color(0xFF7B1FA2),
          iconBgColor: const Color(0xFFF3E5F5),
        ),
        _buildListCard(
          title: 'Special Needs & Disability Services',
          subtitle: 'Accommodations and support services',
          items: [
            'Exam accommodations',
            'Note-taking assistance',
            'Extended deadlines',
            'Mental health accommodations'
          ],
          icon: Icons.school_outlined,
          iconColor: const Color(0xFF7B1FA2),
          iconBgColor: const Color(0xFFF3E5F5),
        ),
        _buildListCard(
          title: 'Learning Support Centre',
          subtitle: 'Academic support to reduce stress',
          items: [
            'Subject tutoring',
            'Study skills',
            'Writing assistance',
            'Peer mentoring'
          ],
          icon: Icons.school_outlined,
          iconColor: const Color(0xFF7B1FA2),
          iconBgColor: const Color(0xFFF3E5F5),
        ),
      ],
    );
  }

  Widget _buildArticles() {
    return Column(
      children: [
        _buildArticleCard(
          tag: 'Academic Stress',
          readTime: '5 min read',
          title: 'Managing Exam Anxiety',
          description:
              'Learn practical strategies to stay calm and focused during examinations...',
        ),
        _buildArticleCard(
          tag: 'Wellness',
          readTime: '7 min read',
          title: 'Building Healthy Sleep Habits',
          description:
              'Sleep is crucial for mental health. Discover tips for better rest...',
        ),
        _buildArticleCard(
          tag: 'Emotional Health',
          readTime: '6 min read',
          title: 'Coping with Being Away from Home',
          description:
              'Feeling homesick is normal. Here\'s how to cope and build community on campus...',
        ),
        _buildArticleCard(
          tag: 'Mental Health',
          readTime: '8 min read',
          title: 'Managing Social Anxiety at University',
          description:
              'Strategies for managing social situations and building connections...',
        ),
        _buildArticleCard(
          tag: 'Mental Health',
          readTime: '6 min read',
          title: 'Recognising Signs of Depression',
          description:
              'Understanding symptoms and when to seek help...',
        ),
      ],
    );
  }

  Widget _buildArticleCard({
    required String tag,
    required String readTime,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                readTime,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Text(
                'Read more',
                style: TextStyle(fontSize: 13, color: Colors.purple),
              ),
              SizedBox(width: 4),
              Icon(Icons.open_in_new, size: 14, color: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required String contact,
    required String tagText,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Text(
                  contact,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    tagText,
                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String subtitle,
    required String description,
    required String tagText,
    required String extraLink,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.videocam_outlined,
                        size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      tagText,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  extraLink,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.purple, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required String subtitle,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.chevron_right,
                              size: 18, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            item,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          _buildFAQTile('Is counselling really confidential?'),
          _buildFAQTile('How much does counselling cost?'),
          _buildFAQTile('What if I need help outside office hours?'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String question) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: const Text(
              'Information regarding this question goes here. Counselling is generally confidential with specific exceptions for safety.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
