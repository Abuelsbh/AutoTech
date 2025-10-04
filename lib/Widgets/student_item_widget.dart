import 'dart:convert';
import 'package:auto_tech/Models/student_model.dart';
import 'package:flutter/material.dart';

class StudentItemWidget extends StatelessWidget {

  final StudentModel? studentModel;
  final List<PopupMenuItem<String>> items;
  const StudentItemWidget({super.key, this.studentModel, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // School Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF0A2A7A), // Dark Blue background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // School Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildSchoolLogo(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    studentModel?.schoolName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Fixed PopupMenuButton - removed InkWell wrapper
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (String value) {
                    // The onTap functionality is already handled in each PopupMenuItem
                    print('Selected menu item: $value');
                  },
                  itemBuilder: (context) => items,
                ),
              ],
            ),
          ),

          // Student Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildStudentImage(),
                ),
                const SizedBox(width: 12),

                // Student Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentModel?.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          text: "Class : ",
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: studentModel?.classSection ?? '',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: const TextSpan(
                          text: "Today's Dismissal Time: ",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "2:10 PM",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: null, // disabled
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black54,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Call"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: null, // disabled
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black54,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Confirm Pick Up"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build school logo widget with fallback
  Widget _buildSchoolLogo() {
    final schoolImageData = studentModel?.imageSchool;
    
    if (schoolImageData != null && schoolImageData.isNotEmpty) {
      // Check if it's a Base64 string or a URL
      if (_isBase64String(schoolImageData)) {
        return _buildBase64Image(schoolImageData, 40, 40);
      } else {
        // It's a URL
        return Image.network(
          schoolImageData,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackLogo();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        );
      }
    }
    
    return _buildFallbackLogo();
  }

  /// Build fallback logo when school image is not available
  Widget _buildFallbackLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: const Icon(
        Icons.school,
        color: Colors.blue,
        size: 24,
      ),
    );
  }

  /// Build student image widget with fallback
  Widget _buildStudentImage() {
    final studentImageData = studentModel?.imageProfile;
    
    if (studentImageData != null && studentImageData.isNotEmpty) {
      // Check if it's a Base64 string or a URL
      if (_isBase64String(studentImageData)) {
        return _buildBase64Image(studentImageData, 70, 70);
      } else {
        // It's a URL
        return Image.network(
          studentImageData,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackStudentImage();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        );
      }
    }
    
    return _buildFallbackStudentImage();
  }

  /// Build fallback student image when student image is not available
  Widget _buildFallbackStudentImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.grey,
        size: 40,
      ),
    );
  }

  /// Check if the string is a Base64 encoded image
  bool _isBase64String(String data) {
    // Base64 strings usually start with 'data:image/' or are just Base64 without prefix
    return data.startsWith('data:image/') || 
           data.startsWith('iVBORw0KGgo') || // PNG signature
           data.startsWith('/9j/') || // JPEG signature
           data.startsWith('R0lGOD') || // GIF signature
           (data.length > 100 && RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(data));
  }

  /// Build image widget from Base64 string
  Widget _buildBase64Image(String base64String, double width, double height) {
    try {
      // Remove data URL prefix if present
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',')[1];
      }
      
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            base64Decode(cleanBase64),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error decoding Base64 image: $error');
              return _buildFallbackLogo();
            },
          ),
        ),
      );
    } catch (e) {
      print('Error parsing Base64 string: $e');
      return _buildFallbackLogo();
    }
  }

}