import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_app_bar_widget.dart';

/// Example screen showing how to use the CustomAppBarWidget
class CustomAppBarExampleScreen extends StatelessWidget {
  const CustomAppBarExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using CustomAppBarWidget as AppBar
      appBar: CustomAppBarWidget(
        name: 'Mohammed',
        profileImage: null, // You can pass a base64 string or network URL here
        hasNotification: true,
        onNotificationTap: () {
          // Handle notification tap
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification tapped!')),
          );
        },
        onProfileTap: () {
          // Handle profile tap
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile tapped!')),
          );
        },
      ),
      
      // Rest of your screen content
      body: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Example Usage as AppBar:',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            Text(
              'Scaffold(\n'
              '  appBar: CustomAppBarWidget(\n'
              '    name: "Mohammed",\n'
              '    profileImage: base64String, // or network URL\n'
              '    hasNotification: true,\n'
              '    onNotificationTap: () {},\n'
              '    onProfileTap: () {},\n'
              '  ),\n'
              '  body: YourContent(),\n'
              ')',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'monospace',
              ),
            ),
            
            SizedBox(height: 24.h),
            
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            
            _buildFeatureItem('• Implements PreferredSizeWidget for AppBar usage'),
            _buildFeatureItem('• Greeting text with customizable name'),
            _buildFeatureItem('• Notification icon with red badge indicator'),
            _buildFeatureItem('• Profile image support (base64 or network)'),
            _buildFeatureItem('• Fallback to default avatar icon'),
            _buildFeatureItem('• Tap callbacks for both icons'),
            _buildFeatureItem('• Responsive design with ScreenUtil'),
            _buildFeatureItem('• SafeArea handling for proper display'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}
