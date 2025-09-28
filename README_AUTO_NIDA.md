# Auto Nida - School Management App

## Overview
Auto Nida (أوتو نداء) is a comprehensive school management mobile application built with Flutter. The app provides features for safe school pickups, smart canteen control, and real-time bus tracking.

## Features

### 🚀 Splash Screen
- Modern gradient design with app branding
- Arabic and English app names
- "Powered by: Automation Technology" tagline

### 🌍 Language Selection
- Support for multiple languages:
  - العربية (Arabic)
  - English (United States)
  - اُردُو (Urdu)
  - Tagalog
- RTL/LTR layout support
- Persistent language selection

### 📱 Onboarding Viewer
- **Single Screen Experience**: All onboarding steps in one unified viewer
- **Swipe Navigation**: Users can swipe between steps or use navigation buttons
- **Progress Indicators**: Visual progress dots showing current step
- **Three Main Features**:
  1. **Safe, Simple School Pickups**: Parent-teacher interaction illustration
  2. **Smart Canteen Control**: Mobile food ordering interface
  3. **Real-time Tracking**: Bus and driver tracking on map
- **Skip Functionality**: Users can skip to the end from any step
- **Smooth Transitions**: Animated transitions between steps

## Technical Features

### 🎨 Design System
- Modern, clean UI with rounded buttons
- Soft gradients and professional color scheme
- Responsive typography using Google Fonts
- Support for both Arabic (RTL) and English (LTR) layouts

### 🔧 Technical Stack
- **Framework**: Flutter 3.5.3+
- **State Management**: Provider
- **Navigation**: GoRouter
- **Localization**: Custom i18n system
- **UI Components**: Material Design with custom styling
- **Fonts**: Google Fonts (Cairo for Arabic, Inter for English)

### 📱 Responsive Design
- Screen size adaptation using flutter_screenutil
- Support for different device sizes
- Consistent spacing and typography

## Project Structure

```
lib/
├── Modules/
│   ├── Splash/                 # App splash screen
│   ├── LanguageSelection/      # Language selection screen
│   ├── Onboarding/            # Onboarding viewer (unified experience)
│   ├── Permissions/           # Permission request screens
│   ├── RoleSelection/         # Role selection screen
│   ├── Auth/                  # Login/Register screen
│   └── Home/                  # Main home screen
├── core/
│   ├── Language/              # Language management
│   ├── Theme/                 # Theme configuration
│   └── Font/                  # Font management
├── Utilities/                 # Helper utilities
└── Widgets/                   # Reusable widgets
```

## Getting Started

1. **Prerequisites**
   - Flutter SDK 3.5.3 or higher
   - Dart SDK
   - Android Studio / VS Code

2. **Installation**
   ```bash
   git clone <repository-url>
   cd template_2025-main
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Localization

The app supports multiple languages with proper RTL/LTR support:

- **Arabic (ar)**: Full RTL support with Arabic fonts
- **English (en)**: LTR layout with English fonts
- **Urdu**: Uses Arabic RTL layout
- **Tagalog**: Uses Arabic RTL layout

Language files are located in `i18n/` directory:
- `ar.json` - Arabic translations
- `en.json` - English translations

## Navigation Flow

1. **Splash Screen** → Language Selection
2. **Language Selection** → Onboarding Viewer
3. **Onboarding Viewer** → Notification Access
4. **Notification Access** → Location Access
5. **Location Access** → Role Selection
6. **Role Selection** → Login/Register
7. **Login/Register** → Mobile Verification
8. **Mobile Verification** → Home Screen

## Customization

### Colors
The app uses a consistent color palette:
- Primary: `#1E40AF` (Blue)
- Secondary: `#6B46C1` (Purple)
- Accent: `#EC4899` (Pink)
- Success: `#10B981` (Green)
- Warning: `#F59E0B` (Orange)

### Typography
- **Arabic Text**: Cairo font family
- **English Text**: Inter font family
- Responsive font sizes using ScreenUtil

## Future Enhancements

- [ ] User authentication system
- [ ] Real-time notifications
- [ ] Map integration for bus tracking
- [ ] Payment gateway integration
- [ ] Parent-teacher communication
- [ ] Student attendance tracking
- [ ] Meal ordering system
- [ ] Push notifications

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Powered by: Automation Technology
