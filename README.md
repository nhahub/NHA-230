# NHA-230 - Location-Based Services Flutter App

A modern Flutter application featuring location-based services with an intuitive user interface supporting Arabic
content and onboarding experience.

## Features

### Core Features

- **Multi-language Support**: Supports Arabic text content
- **Onboarding Experience**: Three-screen onboarding flow with smooth animations
- **Authentication System**: Complete login and signup functionality
- **Location Services**: Map integration for location-based features
- **Category-based Navigation**: Browse restaurants, cafes, and malls
- **Search Functionality**: Advanced search with filtering options
- **Promotion System**: Dynamic promotion slider
- **User Profiles**: Personal profile management

### UI/UX Features

- **Responsive Design**: Optimized for different screen sizes using ScreenUtil
- **Custom Animations**: Lottie animations for enhanced user experience
- **Modern Theming**: Custom light theme with consistent styling
- **Smooth Transitions**: Page transitions with fade effects
- **Interactive Elements**: Custom buttons, cards, and navigation components

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants, colors, and assets
│   └── themes/            # Theme configurations
├── features/
│   ├── authentication/    # Login and signup screens
│   ├── home/             # Home screen and related widgets
│   │   ├── providers/    # State management for home features
│   │   ├── screens/      # Home-related screens
│   │   └── widgets/      # Reusable home widgets
│   ├── map/              # Map functionality
│   ├── onboarding/       # Onboarding screens
│   └── profile/          # User profile features
├── screens/              # Additional app screens
└── services/             # App services and utilities
```

## Screens Overview

- **Splash Screen**: Animated splash screen with Lottie animation
- **Onboarding Flow**: Three informative screens introducing app features
- **Authentication**: Login and signup with Google integration support
- **Home Screen**: Main dashboard with categories and search
- **Search Screen**: Advanced search functionality
- **Map Screen**: Location-based services
- **Profile Screen**: User profile management

## Technologies Used

### Flutter Packages

- **flutter_screenutil** (^5.9.3): Responsive screen adaptation
- **provider** (^6.1.2): State management
- **google_fonts** (^6.3.2): Custom typography
- **video_player** (^2.6.1): Video playback capabilities
- **lottie** (^3.3.2): Animation support
- **flutter_svg** (^2.0.7): SVG asset support
- **shared_preferences** (^2.5.3): Local data persistence

### Assets

- **Images**: High-quality PNG images for UI elements
- **Icons**: SVG and PNG icons for navigation and categories
- **Animations**: Lottie JSON files for smooth animations

## Getting Started

### Prerequisites

- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio / VS Code
- iOS development setup (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd NHA-230
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web
```

## Design System

The app implements a consistent design system with:

- Custom color palette defined in `colors.dart`
- Typography using Google Fonts
- Responsive sizing with ScreenUtil
- Consistent spacing and layout patterns
- Material Design components with custom styling

## Platform Support

- Android: Full support with custom launcher icons
- iOS: Complete iOS integration
- Web: Web deployment ready
- Windows: Desktop support available
- macOS: macOS compatibility
- Linux: Linux support included

## Key Components

### Custom Widgets

- `BackgroundContainer`: Consistent background styling
- `CategoriesCard`: Interactive category selection cards
- `CustomElevatedButton`: Styled button components
- `CustomTextFormField`: Form input components
- `PromotionSlider`: Dynamic content slider
- `MainBottomNavigationBar`: Custom navigation bar

### State Management

- Provider pattern implementation
- Separate providers for different features
- Clean separation of business logic and UI

## Configuration

### App Configuration

- App name: `splash_screen`
- Bundle ID: Configured in platform-specific files
- Version: 1.0.0+1
- Minimum SDK versions configured per platform

### Asset Management

Assets are organized in the `assets/` directory:

- `images/`: Application images and backgrounds
- `icons/`: UI icons and navigation elements
- `animations/`: Lottie animation files

## Development

### Code Style

The project follows Flutter/Dart coding conventions with:

- Linting rules configured in `analysis_options.yaml`
- Consistent naming conventions
- Proper documentation and comments
- Clean architecture principles

### Adding New Features

1. Create feature directory under `lib/features/`
2. Implement screens, widgets, and providers as needed
3. Update routing and navigation
4. Add assets and update `pubspec.yaml`
5. Test across different platforms

## App Flow

1. **App Launch**: Splash screen with animation
2. **Onboarding**: Three-screen introduction flow
3. **Authentication**: Login/signup process
4. **Home**: Main dashboard with categories
5. **Navigation**: Bottom navigation between main sections
6. **Features**: Access to maps, search, and profile

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is private and not published to pub.dev as indicated in `pubspec.yaml`.

## Support

For technical support or questions about the application, please refer to the development team or project documentation.

---
**Built with Flutter**
