import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'school_settings_screen.dart';
import 'class_management_screen.dart';
import 'student_management_screen.dart';
import 'staff_management_screen.dart';

class SchoolAdminDashboardScreen extends StatefulWidget {
  final String schoolId;

  const SchoolAdminDashboardScreen({
    super.key,
    required this.schoolId,
  });

  @override
  State<SchoolAdminDashboardScreen> createState() => _SchoolAdminDashboardScreenState();
}

class _SchoolAdminDashboardScreenState extends State<SchoolAdminDashboardScreen> {
  int _selectedIndex = 0;
  Map<String, int> _stats = {
    'students': 0,
    'classes': 0,
    'staff': 0,
  };
  bool _isLoadingStats = true;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
    _screens.addAll([
      _buildDashboard(),
      SchoolSettingsScreen(schoolId: widget.schoolId),
      ClassManagementScreen(schoolId: widget.schoolId),
      StudentManagementScreen(schoolId: widget.schoolId),
      StaffManagementScreen(schoolId: widget.schoolId),
    ]);
  }

  Future<void> _loadStats() async {
    try {
      final stats = await FirebaseService.getSchoolStats(widget.schoolId);
      setState(() {
        _stats = stats;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStats = false;
      });
      // في حالة الخطأ، استخدم قيم افتراضية
      setState(() {
        _stats = {
          'students': 0,
          'classes': 0,
          'staff': 0,
        };
      });
      print('تحذير: لا يمكن الاتصال بـ Firebase، استخدام القيم الافتراضية');
    }
  }

  Widget _buildDashboard() {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات سريعة
            const Text(
              'نظرة عامة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'إجمالي الطلاب',
                    _isLoadingStats ? '...' : _stats['students'].toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'الفصول',
                    _isLoadingStats ? '...' : _stats['classes'].toString(),
                    Icons.class_,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'المنسوبين',
                    _isLoadingStats ? '...' : _stats['staff'].toString(),
                    Icons.person,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'الوصولات اليوم',
                    '0', // سيتم تحديثها لاحقاً
                    Icons.check_circle,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // إجراءات سريعة
            const Text(
              'إجراءات سريعة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildQuickActionCard(
                  'إعدادات المدرسة',
                  Icons.settings,
                  Colors.blue,
                  () => _onItemTapped(1),
                ),
                _buildQuickActionCard(
                  'إدارة الفصول',
                  Icons.class_,
                  Colors.green,
                  () => _onItemTapped(2),
                ),
                _buildQuickActionCard(
                  'إدارة الطلاب',
                  Icons.people,
                  Colors.orange,
                  () => _onItemTapped(3),
                ),
                _buildQuickActionCard(
                  'إدارة المنسوبين',
                  Icons.person,
                  Colors.purple,
                  () => _onItemTapped(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // تحديث الإحصائيات عند العودة للداشبورد
    if (index == 0) {
      _loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد مسؤول المدرسة'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'الفصول',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'الطلاب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'المنسوبين',
          ),
        ],
      ),
    );
  }
}
