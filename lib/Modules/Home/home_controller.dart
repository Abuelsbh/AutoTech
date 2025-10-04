
import 'package:auto_tech/Models/student_model.dart';
import 'package:auto_tech/Utilities/router_config.dart';
import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:state_extended/state_extended.dart';

import '../../Utilities/strings.dart';
import '../../generated/assets.dart';
import 'home_data_handler.dart';
import 'update_photo_screen.dart';


class HomeController extends StateXController {
  // singleton
  factory HomeController()=> _this ??= HomeController._();
  static HomeController? _this;
  HomeController._();

  /// Loading state indicator for UI feedback during operations
  bool loading = false;

  /// List of students to display
  List<StudentModel> students = [];


  /// Fetch students by guardian phone number
  Future<void> fetchStudentsByGuardianPhone(String guardianPhone) async {
    setState(() {
      loading = true;
    });

    try {
      final result = await HomeDataHandler.getStudentsByGuardianPhone(
        guardianPhone: guardianPhone,
      );

      result.fold(
        (failure) {
          print('Error fetching students: ${failure.errorModel.statusMessage}');
          setState(() {
            students = [];
            loading = false;
          });
        },
        (studentList) {
          setState(() {
            students = studentList;
            loading = false;
          });
          print('Found ${studentList.length} students for guardian phone: $guardianPhone');
        },
      );
    } catch (e) {
      print('Exception while fetching students: $e');
      setState(() {
        students = [];
        loading = false;
      });
    }
  }

  /// Fetch all students
  Future<void> fetchAllStudents() async {
    setState(() {
      loading = true;
    });

    try {
      final result = await HomeDataHandler.getAllStudents();

      result.fold(
        (failure) {
          print('Error fetching all students: ${failure.errorModel.statusMessage}');
          setState(() {
            students = [];
            loading = false;
          });
        },
        (studentList) {
          setState(() {
            students = studentList;
            loading = false;
          });
          print('Found ${studentList.length} total students');
        },
      );
    } catch (e) {
      print('Exception while fetching all students: $e');
      setState(() {
        students = [];
        loading = false;
      });
    }
  }

  List<PopupMenuItem<String>> optionSetting(BuildContext context, StudentModel model) {
    return [
      // View QR Code
      _buildMenuItem(
        context,
        Assets.iconsQRCode, 
        Strings.viewQrCode.tr,
        () => _onViewQrCode(model),
      ),
      
      // Update Photo
      _buildMenuItem(
        context,
        Assets.iconsImage, 
        Strings.updatePhoto.tr,
        () => _onUpdatePhoto(model),
      ),
      
      // Canteen
      _buildMenuItem(
        context,
        Assets.iconsCanteen,
        Strings.canteen.tr,
        () => _onCanteen(model),
      ),
      
      // Sick Leave
      _buildMenuItem(
        context,
        Assets.iconsSickLeave,
        Strings.sickLeave.tr,
        () => _onSickLeave(model),
      ),
      
      // View Details
      _buildMenuItem(
        context,
        Assets.iconsDetails,
        Strings.viewDetails.tr,
        () => _onViewDetails(model),
      ),
      
      // Permission
      _buildMenuItem(
        context,
        Assets.iconsPermission,
        Strings.permission.tr,
        () => _onPermission(model),
      ),
      
      // Transactions Log
      _buildMenuItem(
        context,
        Assets.iconsTransaction,
        Strings.transactionsLog.tr,
        () => _onTransactionsLog(model),
      ),
      
      // Driver Location
      _buildMenuItem(
        context,
        Assets.iconsDriver,
        Strings.driverLocation.tr,
        () => _onDriverLocation(model),
      ),
    ];
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, String icon, String text, VoidCallback onTap) {
    return PopupMenuItem<String>(
      value: text,
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            icon, 
            color: Theme.of(context).primaryColor,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _onViewQrCode(StudentModel model) {
    print('View QR Code tapped for student: ${model.name}');
    // TODO: Implement QR Code viewing functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeScreen(student: model)));
  }

  void _onUpdatePhoto(StudentModel model) {
    print('Update Photo tapped for student: ${model.name}');
    // Navigate to UpdatePhotoScreen
    Navigator.push(
      currentContext_!,
      MaterialPageRoute(
        builder: (context) => UpdatePhotoScreen(student: model),
      ),
    );
  }

  void _onCanteen(StudentModel model) {
    print('Canteen tapped for student: ${model.name}');
    // TODO: Implement canteen functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CanteenScreen(student: model)));
  }

  void _onSickLeave(StudentModel model) {
    print('Sick Leave tapped for student: ${model.name}');
    // TODO: Implement sick leave functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SickLeaveScreen(student: model)));
  }

  void _onViewDetails(StudentModel model) {
    print('View Details tapped for student: ${model.name}');
    // TODO: Implement view details functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => StudentDetailsScreen(student: model)));
  }

  void _onPermission(StudentModel model) {
    print('Permission tapped for student: ${model.name}');
    // TODO: Implement permission functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionScreen(student: model)));
  }

  void _onTransactionsLog(StudentModel model) {
    print('Transactions Log tapped for student: ${model.name}');
    // TODO: Implement transactions log functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionsLogScreen(student: model)));
  }

  void _onDriverLocation(StudentModel model) {
    print('Driver Location tapped for student: ${model.name}');
    // TODO: Implement driver location functionality
    // Navigator.push(context, MaterialPageRoute(builder: (context) => DriverLocationScreen(student: model)));
  }

}