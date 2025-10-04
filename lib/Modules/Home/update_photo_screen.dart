import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:auto_tech/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_tech/Models/student_model.dart';
import '../../Modules/Home/home_data_handler.dart';

class UpdatePhotoScreen extends StatefulWidget {
  final StudentModel student;

  const UpdatePhotoScreen({
    super.key,
    required this.student,
  });

  @override
  State<UpdatePhotoScreen> createState() => _UpdatePhotoScreenState();
}

class _UpdatePhotoScreenState extends State<UpdatePhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.student.name ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  // Current Photo Section
                  _buildCurrentPhotoSection(),

                  SizedBox(height: 60.h),

                  // Action Buttons
                  _buildActionButtons(),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhotoSection() {
    return Column(
      children: [
        // Current Photo Circle
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 3),
          ),
          child: ClipOval(
            child: _buildStudentImage(),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Current Photo Label
        Text(
          'Current Photo',
          style: TextStyle(
            color: Colors.red[600],
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentImage() {
    final studentImageData = widget.student.imageProfile;
    
    if (studentImageData != null && studentImageData.isNotEmpty) {
      // Check if it's a Base64 string or a URL
      if (_isBase64String(studentImageData)) {
        return _buildBase64Image(studentImageData);
      } else {
        // It's a URL
        return Image.network(
          studentImageData,
          width: 120.w,
          height: 120.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackImage();
          },
        );
      }
    }
    
    return _buildFallbackImage();
  }

  Widget _buildBase64Image(String base64String) {
    try {
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',')[1];
      }
      
      return Image.memory(
        base64Decode(cleanBase64),
        width: 120.w,
        height: 120.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } catch (e) {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 80.w,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            // Take Picture Button
            Expanded(
              child: _buildActionButton(
                icon: Icons.camera_alt,
                title: 'Take Picture',
                color: Colors.purple,
                onTap: _takePicture,
              ),
            ),
            
            SizedBox(width: 20.w),
            
            // Upload Photo Button
            Expanded(
              child: _buildActionButton(
                icon: Icons.upload_file,
                title: 'Upload Photo',
                color: Colors.green,
                onTap: _uploadPhoto,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20.h),

      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48.w,
              color: color,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        await _processImage(File(image.path));
      }
    } catch (e) {
      String errorMessage = 'Error taking picture: $e';
      
      // Check for different types of errors
      if (e.toString().contains('MissingPluginException')) {
        errorMessage = 'Camera not available. Please use "Upload Photo" instead or test on a physical device with camera.';
      } else if (e.toString().contains('PlatformException')) {
        if (e.toString().contains('channel-error')) {
          errorMessage = 'Camera connection failed. This usually happens on emulators. Please try "Upload Photo" or test on a physical device.';
        } else {
          errorMessage = 'Camera permission denied or camera not available. Please check device settings.';
        }
      } else if (e.toString().contains('camera')) {
        errorMessage = 'Camera permission denied or camera not available. Please check device settings.';
      }
      
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _uploadPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        await _processImage(File(image.path));
      }
    } catch (e) {
      String errorMessage = 'Error uploading photo: $e';
      
      // Check for different types of errors
      if (e.toString().contains('MissingPluginException')) {
        errorMessage = 'Gallery not available. Please test on a physical device or check if the app has proper permissions.';
      } else if (e.toString().contains('PlatformException')) {
        if (e.toString().contains('channel-error')) {
          errorMessage = 'Gallery connection failed. This usually happens on emulators. Please try testing on a physical device.';
        } else {
          errorMessage = 'Storage permission denied. Please check app permissions in device settings.';
        }
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Storage permission denied. Please check app permissions in device settings.';
      }
      
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Convert image to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      // Update student photo in Firebase
      final success = await _updateStudentPhoto(base64String);
      
      if (success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to update photo. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error processing image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _updateStudentPhoto(String base64Image) async {
    try {
      if (widget.student.id == null || widget.student.id!.isEmpty) {
        print('Student ID is null or empty');
        return false;
      }

      final success = await HomeDataHandler.updateStudentPhoto(
        studentId: widget.student.id!,
        base64Image: base64Image,
      );

      if (success) {
        print('Student photo updated successfully');
      } else {
        print('Failed to update student photo');
      }

      return success;
    } catch (e) {
      print('Error updating student photo: $e');
      return false;
    }
  }


  bool _isBase64String(String data) {
    return data.startsWith('data:image/') || 
           data.startsWith('iVBORw0KGgo') || // PNG signature
           data.startsWith('/9j/') || // JPEG signature
           data.startsWith('R0lGOD') || // GIF signature
           (data.length > 100 && RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(data));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Photo updated successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close update photo screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
