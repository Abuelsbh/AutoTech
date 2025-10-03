import 'package:flutter/material.dart';
import '../models/staff.dart';
import '../services/firebase_service.dart';
import 'add_staff_screen.dart';
import 'edit_staff_screen.dart';

class StaffManagementScreen extends StatefulWidget {
  final String schoolId;

  const StaffManagementScreen({
    super.key,
    required this.schoolId,
  });

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  List<Staff> _staff = [];
  bool _isLoading = true;
  String _searchQuery = '';
  StaffRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final staff = await FirebaseService.getStaff(widget.schoolId);
      setState(() {
        _staff = staff;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _staff = []; // قائمة فارغة في حالة الخطأ
      });
      
      // إذا كان الخطأ بسبب عدم الاتصال بـ Firebase، اعرض رسالة مختلفة
      if (e.toString().contains('offline') || e.toString().contains('unavailable')) {
        _showErrorDialog('لا يمكن الاتصال بـ Firebase. تأكد من:\n1. اتصال الإنترنت\n2. إعداد Firebase بشكل صحيح\n3. تحديث ملف firebase_options.dart');
      } else {
        _showErrorDialog('خطأ في تحميل المنسوبين: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  Future<void> _editStaff(Staff staff) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStaffScreen(staff: staff),
      ),
    );

    if (result == true) {
      _loadStaff();
    }
  }

  Future<void> _deleteStaff(Staff staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ${staff.roleDisplayName} "${staff.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseService.deleteStaff(staff.id);
        _loadStaff();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف المنسوب بنجاح')),
        );
      } catch (e) {
        _showErrorDialog('خطأ في حذف المنسوب: $e');
      }
    }
  }

  List<Staff> get _filteredStaff {
    List<Staff> filtered = _staff;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((staff) {
        return staff.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               staff.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               staff.phone.contains(_searchQuery) ||
               staff.username.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedRole != null) {
      filtered = filtered.where((staff) => staff.roles.contains(_selectedRole!)).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // شريط البحث والفلاتر
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث في المنسوبين...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('الكل'),
                        selected: _selectedRole == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRole = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('معلم'),
                        selected: _selectedRole == StaffRole.teacher,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRole = selected ? StaffRole.teacher : null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('مدير'),
                        selected: _selectedRole == StaffRole.principal,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRole = selected ? StaffRole.principal : null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('حارس'),
                        selected: _selectedRole == StaffRole.guard,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRole = selected ? StaffRole.guard : null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('مراقب'),
                        selected: _selectedRole == StaffRole.monitor,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRole = selected ? StaffRole.monitor : null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // قائمة المنسوبين
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStaff.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'لا يوجد منسوبين مسجلين',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'اضغط على + لإضافة منسوب جديد',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredStaff.length,
                        itemBuilder: (context, index) {
                          final staff = _filteredStaff[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getRoleColor(staff.roles.first),
                                child: Icon(
                                  _getRoleIcon(staff.roles.first),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                staff.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الأدوار: ${staff.roleDisplayName}'),
                                  Text('البريد: ${staff.email}'),
                                  Text('الجوال: ${staff.phone}'),
                                  Text('اسم المستخدم: ${staff.username}'),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('تعديل'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('حذف', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editStaff(staff);
                                  } else if (value == 'delete') {
                                    _deleteStaff(staff);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStaffScreen(schoolId: widget.schoolId),
            ),
          );
          
          if (result == true) {
            _loadStaff();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getRoleColor(StaffRole role) {
    switch (role) {
      case StaffRole.teacher:
        return Colors.blue;
      case StaffRole.principal:
        return Colors.green;
      case StaffRole.guard:
        return Colors.orange;
      case StaffRole.monitor:
        return Colors.purple;
    }
  }

  IconData _getRoleIcon(StaffRole role) {
    switch (role) {
      case StaffRole.teacher:
        return Icons.person;
      case StaffRole.principal:
        return Icons.admin_panel_settings;
      case StaffRole.guard:
        return Icons.security;
      case StaffRole.monitor:
        return Icons.visibility;
    }
  }
}
