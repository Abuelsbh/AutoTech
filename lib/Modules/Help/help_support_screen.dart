import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utilities/text_style_helper.dart';
import '../../Utilities/theme_helper.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar_widget.dart';
import '../../generated/assets.dart';

class HelpSupportScreen extends StatefulWidget {
  static const routeName = "/helpSupport";

  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // Track which FAQ items are expanded
  final Map<int, bool> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light blue-gray background
      appBar: CustomAppBarWidget(
        name: 'Mohammed',
        hasNotification: true,
        onNotificationTap: () {
          // Handle notification tap
        },
        onProfileTap: () {
          // Handle profile tap
        },
      ),
      body: Stack(
        children:[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Help & Support Title
                  Text(
                    'Help & Support',
                    style: TextStyleHelper.of(context).s24RegTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  Gap(24.h),

                  // How to Use the App Section
                  _buildHowToUseSection(),

                  Gap(32.h),

                  // Common Questions Section
                  _buildCommonQuestionsSection(),

                  Gap(32.h),

                  // Contact Technical Support Section
                  _buildContactSupportSection(),

                  Gap(20.h),
                ],
              ),
            ),
          ),
        ]
      ),
      bottomNavigationBar: const BottomNavBarWidget(selected: SelectedBottomNavBar.help),
    );
  }

  Widget _buildHowToUseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Use the App',
          style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        
        Gap(16.h),
        
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildStepItem(
                number: 1,
                text: 'Install the app and enter your mobile number.',
              ),
              Gap(12.h),
              _buildStepItem(
                number: 2,
                text: 'Enter the OTP sent via SMS or WhatsApp.',
              ),
              Gap(12.h),
              _buildStepItem(
                number: 3,
                text: 'View and manage your student\'s profile.',
              ),
              Gap(12.h),
              _buildStepItem(
                number: 4,
                text: 'Set up the canteen, permissions, and more.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem({required int number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: const Color(0xFF0D5EA6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
              color: const Color(0xFF4B5563),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommonQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Common Questions / Quick Tips',
          style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        
        Gap(16.h),
        
        _buildFAQItem(
          index: 0,
          question: 'What if I don\'t see my child?',
          answer: 'Add them using their National ID via "Add New Student".',
          isExpanded: _expandedItems[0] ?? false,
        ),
        
        Gap(12.h),
        
        _buildFAQItem(
          index: 1,
          question: 'How to assign a delegator (like a driver)?',
          answer: 'Go to your student\'s profile, tap on "Permissions" and select "Add Delegator". Enter the driver\'s information and they will receive access.',
          isExpanded: _expandedItems[1] ?? false,
        ),
        
        Gap(12.h),
        
        _buildFAQItem(
          index: 2,
          question: 'How do I deposit money for canteen?',
          answer: 'Navigate to your student\'s profile, tap on "Canteen" and select "Add Funds". You can add money using your preferred payment method.',
          isExpanded: _expandedItems[2] ?? false,
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required int index,
    required String question,
    required String answer,
    required bool isExpanded,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedItems[index] = !(_expandedItems[index] ?? false);
              });
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                        color: const Color(0xFF1F2937),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: isExpanded ? const Color(0xFFEF4444) : const Color(0xFF0D5EA6),
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFE5E7EB),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
              child: Text(
                answer,
                style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Technical Support',
          style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        
        Gap(16.h),
        
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Having issues? Need help?',
                      style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                        color: const Color(0xFF1F2937),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      'Click on WhatsApp Icon to contact technical',
                      style: TextStyleHelper.of(context).s12RegTextStyle.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16.w),
              GestureDetector(
                onTap: _launchWhatsApp,
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366), // WhatsApp green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchWhatsApp() async {
    // Replace with your actual WhatsApp number
    const String phoneNumber = '966562030903'; // Example number
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to regular phone call
        final Uri phoneUri = Uri.parse('tel:$phoneNumber');
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch WhatsApp: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
