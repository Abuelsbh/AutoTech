# Help & Support Screen Implementation

## Overview
Created a comprehensive Help & Support screen that matches the design shown in the image. The screen includes all the features and sections visible in the reference design.

## Features Implemented

### ✅ Custom AppBar
- Uses the existing `CustomAppBarWidget` with greeting "Hey, Mohammed"
- Notification icon with red badge indicator
- Profile icon (placeholder for now)

### ✅ How to Use the App Section
- **Title**: "How to Use the App" in bold dark text
- **4 Numbered Steps** with blue circular indicators:
  1. "Install the app and enter your mobile number."
  2. "Enter the OTP sent via SMS or WhatsApp."
  3. "View and manage your student's profile."
  4. "Set up the canteen, permissions, and more."
- **Clean card design** with subtle shadows and borders

### ✅ Common Questions / Quick Tips Section
- **Accordion-style FAQ items** with expand/collapse functionality
- **3 FAQ Items**:
  - "What if I don't see my child?" (expanded by default)
  - "How to assign a delegator (like a driver)?" (collapsed)
  - "How do I deposit money for canteen?" (collapsed)
- **Interactive icons**: Red 'X' for expanded, Blue '+' for collapsed
- **Smooth animations** when expanding/collapsing items

### ✅ Contact Technical Support Section
- **WhatsApp integration** with green circular button
- **Descriptive text**: "Having issues? Need help?"
- **Subtitle**: "Click on WhatsApp Icon to contact technical"
- **Functional WhatsApp launcher** that opens WhatsApp with the support number

### ✅ Bottom Navigation
- **Updated navigation** to include Help tab
- **Proper routing** to Help & Support screen
- **Active state indication** when on Help screen

## Technical Implementation

### File Structure
```
lib/Modules/Help/
└── help_support_screen.dart          # Main Help & Support screen

lib/Widgets/
└── bottom_navbar_widget.dart         # Updated with Help navigation

lib/Utilities/
└── router_config.dart                # Added Help screen route
```

### Dependencies Added
- `url_launcher: ^6.3.1` - For WhatsApp integration

### Key Components

#### 1. HelpSupportScreen
- **StatefulWidget** for managing FAQ expansion state
- **Custom AppBar** integration
- **Responsive design** using ScreenUtil
- **Clean layout** with proper spacing and typography

#### 2. FAQ Accordion System
```dart
final Map<int, bool> _expandedItems = {};

Widget _buildFAQItem({
  required int index,
  required String question,
  required String answer,
  required bool isExpanded,
}) {
  // Accordion implementation with smooth animations
}
```

#### 3. WhatsApp Integration
```dart
void _launchWhatsApp() async {
  const String phoneNumber = '966562030903';
  final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
  
  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }
}
```

#### 4. Step-by-Step Guide
```dart
Widget _buildStepItem({required int number, required String text}) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D5EA6),
          shape: BoxShape.circle,
        ),
        child: Text(number.toString()),
      ),
      // Step text
    ],
  );
}
```

## Design Specifications

### Colors
- **Primary Blue**: `#0D5EA6` (for step numbers and icons)
- **Text Primary**: `#1F2937` (for titles and questions)
- **Text Secondary**: `#4B5563` (for step descriptions)
- **Text Tertiary**: `#6B7280` (for FAQ answers)
- **WhatsApp Green**: `#25D366` (for WhatsApp button)
- **Background**: `#F8FAFC` (light blue-gray)
- **Card Background**: `#FFFFFF` (white)
- **Borders**: `#E5E7EB` (light gray)

### Typography
- **Titles**: 18sp, bold, dark gray
- **Main Title**: 24sp, bold, dark gray
- **Step Text**: 14sp, regular, medium gray
- **FAQ Questions**: 14sp, medium weight, dark gray
- **FAQ Answers**: 14sp, regular, light gray

### Spacing
- **Section Spacing**: 32h between major sections
- **Item Spacing**: 12h-16h between items
- **Padding**: 20w for main content
- **Card Padding**: 16w-20w for internal content

## Navigation Integration

### Bottom Navigation Update
```dart
static _BottomNavBarItemModel help = _BottomNavBarItemModel(
  title: Strings.help.tr,
  iconPath: Assets.iconsHelp,
  type: SelectedBottomNavBar.help,
  routeName: HelpSupportScreen.routeName,
);
```

### Router Configuration
```dart
GoRoute(
  path: HelpSupportScreen.routeName,
  name: 'help-support',
  pageBuilder: (_, GoRouterState state) {
    return getCustomTransitionPage(
      state: state,
      child: const HelpSupportScreen(),
    );
  },
),
```

## Usage

### Accessing the Screen
1. **Bottom Navigation**: Tap the "Help" tab in the bottom navigation
2. **Direct Navigation**: Use `context.pushNamed('help-support')`

### Features Available
- **Step-by-step guide** for app usage
- **Expandable FAQ** for common questions
- **WhatsApp support** for technical assistance
- **Responsive design** that works on all screen sizes

## Customization

### Adding New FAQ Items
```dart
_buildFAQItem(
  index: 3,
  question: 'Your new question?',
  answer: 'Your detailed answer here.',
  isExpanded: _expandedItems[3] ?? false,
),
```

### Changing WhatsApp Number
```dart
const String phoneNumber = 'YOUR_WHATSAPP_NUMBER';
```

### Modifying Steps
```dart
_buildStepItem(
  number: 5,
  text: 'Your new step description.',
),
```

## Benefits

- **User-friendly interface** matching the reference design
- **Comprehensive help system** with step-by-step guidance
- **Interactive FAQ** for quick problem resolution
- **Direct support access** via WhatsApp
- **Responsive design** for all device sizes
- **Smooth animations** for better user experience
- **Consistent styling** with the rest of the app

The Help & Support screen is now fully functional and ready to use!

