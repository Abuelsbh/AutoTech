import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/Theme/theme_model.dart';
import '../core/Theme/theme_provider.dart';

/// Theme helper class that defines light and dark theme configurations
/// Extends ThemeModel to provide consistent color schemes throughout the app
/// Supports both light and dark modes with proper contrast ratios
class ThemeClass extends ThemeModel{

  /// Light theme configuration with bright colors and dark text
  /// Optimized for daytime use with high contrast and readability
  ThemeClass.lightTheme({
    super.isDark = false,
    super.state50 = const Color(0xffF9FBFD),
    super.state200 = const Color(0xffE2E8F0),
    super.state700 = const Color(0xff314158),
    super.primaryColor = const Color(0xff0D5EA6), // Main brand blue color
    // super.background = const Color(0xffFDFDFD), // Off-white background
    super.background = const Color(0xffFFFFFF), // Off-white background
    super.strokeColor = const Color(0xffC6DFF1), // Light blue stroke/border
    super.secondary = const Color(0xffF4FAFF), // Very light blue secondary
    // super.textMainColor = const Color(0xff131D22), // Dark text for readability
    super.textMainColor = const Color(0xff1D293D), // Dark text for readability
    super.textSecondaryColor = const Color(0xff62748E), // Medium gray secondary text
    super.unreadBackground = const Color(0xffF6FBFF), // Light blue for unread items
    super.redBtnColor = const Color(0xffCC3131), // Red for delete/cancel actions
    super.greyBtnColor = const Color(0xffAAAAAA), // Gray for disabled states
    super.msgBlue = const Color(0xff3B82F6), // Blue for message indicators
    super.msgRed = const Color(0xffEF4444), // Red for error messages
    super.msgTypeYellow = const Color(0xffEAB308), // Yellow for warnings
    super.msgTypeGreen = const Color(0xff22C55E), // Green for success
    super.msgIconColor = const Color(0xff334155), // Dark gray for message icons
    super.inputFieldColor = const Color(0xffF4F4F4), // Light gray for input fields
    super.whiteColor = const Color(0xffFFFFFF), // Pure white
    super.shadowColor = const Color(0xff000000), // Black for shadows
    super.attachmentColor = const Color(0xffEEEEEE), // Light gray for attachments
    super.cardColor = const Color(0xffFFFFFF), // White for cards
    super.primaryBtnColor = const Color(0xff0A4C7D), // Primary button color
    super.filterBgColor = const Color(0xffF3F3F3), // Light gray for filter backgrounds
    super.successColor = const Color(0xFF21C164), // Green for success states
  });

  /// Static method to get current theme from provider
  /// Provides easy access to theme colors from any widget context
  static ThemeModel of(BuildContext context) => Provider.of<ThemeProvider>(context,listen: false).appTheme;

  /// Dark theme configuration with dark colors and light text
  /// Optimized for nighttime use with reduced eye strain
  ThemeClass.darkTheme({
    super.isDark = true,
    super.state50 = const Color(0xffF9FBFD),
    super.state200 = const Color(0xffE2E8F0),
    super.state700 = const Color(0xff475569),
    super.primaryColor = const Color(0xffFFFFFF), // White as primary in dark mode
    super.background = const Color(0xff171717), // Dark background
    super.strokeColor = const Color(0xff575757), // Medium gray stroke/border
    super.secondary = const Color(0xff1D1D1D), // Dark secondary background
    super.textMainColor = const Color(0xffFFFFFF), // White text for readability
    super.textSecondaryColor = const Color(0xffDEDEDE), // Light gray secondary text
    super.unreadBackground = const Color(0xff252525), // Dark gray for unread items
    super.redBtnColor = const Color(0xffCC3131), // Red for delete/cancel actions
    super.greyBtnColor = const Color(0xff3A3A3A), // Dark gray for disabled states
    super.msgBlue = const Color(0xff3B82F6), // Blue for message indicators
    super.msgRed = const Color(0xffEF4444), // Red for error messages
    super.msgTypeYellow = const Color(0xffEAB308), // Yellow for warnings
    super.msgTypeGreen = const Color(0xff22C55E), // Green for success
    super.msgIconColor = const Color(0xffC7C7C7), // Light gray for message icons
    super.inputFieldColor = const Color(0xff1D1D1D), // Dark gray for input fields
    super.whiteColor = const Color(0xffFFFFFF), // Pure white
    super.shadowColor = const Color(0xffE2E2E2), // Light gray for shadows in dark mode
    super.attachmentColor = const Color(0xff252525), // Dark gray for attachments
    super.cardColor = const Color(0xff1D1D1D), // Dark gray for cards
    super.primaryBtnColor = const Color(0xff171717), // Dark primary button color
    super.filterBgColor = const Color(0xff505050), // Medium gray for filter backgrounds
    super.successColor = const Color(0xFF21C164), // Green for success states
  });
}