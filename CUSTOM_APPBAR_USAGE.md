# Custom AppBar Widget Usage Guide

## Overview
The `CustomAppBarWidget` is a reusable Flutter widget that creates a custom app bar matching the design shown in the image. It includes a greeting text, notification icon with badge, and profile image. The widget implements `PreferredSizeWidget` so it can be used directly as an AppBar in a Scaffold.

## Features
- ✅ Implements PreferredSizeWidget for AppBar usage
- ✅ Greeting text with customizable name
- ✅ Notification icon with red badge indicator
- ✅ Profile image support (base64 or network URL)
- ✅ Fallback to default avatar icon
- ✅ Tap callbacks for both icons
- ✅ Responsive design with ScreenUtil
- ✅ SafeArea handling for proper display
- ✅ Clean, modern design matching the provided image

## Usage

### Basic Implementation as AppBar
```dart
import 'package:your_app/Widgets/custom_app_bar_widget.dart';

// In your Scaffold
Scaffold(
  appBar: CustomAppBarWidget(
    name: 'Mohammed',
    profileImage: null, // or base64 string or network URL
    hasNotification: true,
    onNotificationTap: () {
      // Handle notification tap
    },
    onProfileTap: () {
      // Handle profile tap
    },
  ),
  body: YourContentWidget(),
)
```

### With Profile Image (Base64)
```dart
Scaffold(
  appBar: CustomAppBarWidget(
    name: 'Mohammed',
    profileImage: 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQ...', // Base64 string
    hasNotification: true,
    onNotificationTap: () => _handleNotificationTap(),
    onProfileTap: () => _handleProfileTap(),
  ),
  body: YourContentWidget(),
)
```

### With Profile Image (Network URL)
```dart
Scaffold(
  appBar: CustomAppBarWidget(
    name: 'Mohammed',
    profileImage: 'https://example.com/profile.jpg', // Network URL
    hasNotification: false,
    onNotificationTap: () => _handleNotificationTap(),
    onProfileTap: () => _handleProfileTap(),
  ),
  body: YourContentWidget(),
)
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | `String` | ✅ | The user's name to display in the greeting |
| `profileImage` | `String?` | ❌ | Base64 encoded image or network URL for profile picture |
| `hasNotification` | `bool` | ❌ | Whether to show the red notification badge (default: false) |
| `onNotificationTap` | `VoidCallback?` | ❌ | Callback when notification icon is tapped |
| `onProfileTap` | `VoidCallback?` | ❌ | Callback when profile icon is tapped |

## Design Specifications

### Colors
- **Greeting "Hey," text**: `#4B5563` (Dark blue-gray)
- **Name text**: `#1F2937` (Darker blue)
- **Icon color**: `#4B5563` (Dark blue-gray)
- **Background**: `#F3F4F6` (Light gray)
- **Notification badge**: `#EF4444` (Red)
- **Default avatar**: `#E5E7EB` (Light gray)

### Typography
- **Font size**: 20sp
- **Font weight**: 600 (Semi-bold)
- **Font family**: System default

### Spacing
- **Horizontal padding**: 20w
- **Vertical padding**: 16h
- **Icon spacing**: 12w-16w
- **Icon size**: 44w x 44h

## Integration Examples

### In a Scaffold (Recommended)
```dart
Scaffold(
  appBar: CustomAppBarWidget(
    name: user.name,
    profileImage: user.profileImage,
    hasNotification: user.hasUnreadNotifications,
    onNotificationTap: () => Navigator.push(context, 
      MaterialPageRoute(builder: (_) => NotificationsScreen())),
    onProfileTap: () => Navigator.push(context, 
      MaterialPageRoute(builder: (_) => ProfileScreen())),
  ),
  body: YourContentWidget(),
)
```

### With State Management
```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool hasNotification = false;
  String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        name: 'Mohammed',
        profileImage: profileImage,
        hasNotification: hasNotification,
        onNotificationTap: _toggleNotification,
        onProfileTap: _openProfile,
      ),
      body: YourContentWidget(),
    );
  }

  void _toggleNotification() {
    setState(() {
      hasNotification = !hasNotification;
    });
  }

  void _openProfile() {
    // Navigate to profile screen
  }
}
```

## File Structure
```
lib/Widgets/
├── custom_app_bar_widget.dart      # Main widget implementation
└── custom_app_bar_example.dart     # Usage example
```

## Dependencies
The widget uses the following packages:
- `flutter_screenutil` for responsive design
- `dart:convert` for base64 image handling
- `dart:typed_data` for image data handling

## Notes
- The widget automatically handles both base64 encoded images and network URLs
- If no profile image is provided or loading fails, it shows a default avatar icon
- The notification badge only appears when `hasNotification` is true
- All tap callbacks are optional and can be null
- The widget is fully responsive and adapts to different screen sizes
