# gems_responsive

A professional responsive helper class for Flutter apps. Provides consistent sizing across devices with smart tablet support using `flutter_screenutil`.

## Features

- ✅ **Smart Device Detection** - Automatically detects small, medium, and large devices
- ✅ **Responsive Sizing** - Width, height, font size, padding, margin, and more
- ✅ **Tablet Optimization** - Intelligent scaling limits for tablets to prevent oversized UI
- ✅ **ScreenUtil Integration** - Works seamlessly with `flutter_screenutil` when available
- ✅ **Fallback Support** - Works even without ScreenUtil initialization
- ✅ **Safe Area Support** - Built-in safe area and viewport helpers

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  gems_responsive: ^0.1.0
  flutter_screenutil: ^5.9.0  # Required dependency
```

Then run:

```bash
flutter pub get
```

## Usage

### Initialize ScreenUtil (Recommended)

In your `main.dart`, initialize `ScreenUtil`:

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: HomePage(),
        );
      },
    );
  }
}
```

### Basic Usage

```dart
import 'package:gems_responsive/gems_responsive.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.getResponsiveWidth(context, 100),
      height: ResponsiveHelper.getResponsiveHeight(context, 50),
      padding: ResponsiveHelper.getResponsivePadding(context, all: 16),
      child: Text(
        'Hello',
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
        ),
      ),
    );
  }
}
```

### Device Detection

```dart
if (ResponsiveHelper.isSmallDevice(context)) {
  // Phone layout
} else if (ResponsiveHelper.isMediumDevice(context)) {
  // Tablet layout
} else if (ResponsiveHelper.isLargeDevice(context)) {
  // Desktop/large tablet layout
}
```

### Responsive Values

```dart
final columns = ResponsiveHelper.getResponsiveValue<int>(
  context,
  small: 1,   // 1 column on phone
  medium: 2,  // 2 columns on tablet
  large: 3,   // 3 columns on desktop
);
```

### Shorthand Methods

```dart
// Quick responsive sizing
Container(
  width: ResponsiveHelper.w(100),
  height: ResponsiveHelper.h(50),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
  ),
  child: Text(
    'Text',
    style: TextStyle(fontSize: ResponsiveHelper.sp(16)),
  ),
)
```

## API Reference

### Screen Dimensions
- `getScreenSize(BuildContext)` - Get screen size
- `getScreenWidth(BuildContext)` - Get screen width
- `getScreenHeight(BuildContext)` - Get screen height
- `getViewportWidth(BuildContext)` - Get viewport width (excluding safe areas)
- `getViewportHeight(BuildContext)` - Get viewport height (excluding safe areas)

### Responsive Sizing
- `getResponsiveWidth(BuildContext, double)` - Responsive width
- `getResponsiveHeight(BuildContext, double)` - Responsive height
- `getResponsiveSize(BuildContext, double)` - Responsive size (square)
- `getResponsiveFontSize(BuildContext, double)` - Responsive font size
- `getResponsiveRadius(BuildContext, double)` - Responsive border radius

### Padding & Margins
- `getResponsivePadding(BuildContext, {...})` - Responsive padding
- `getResponsivePaddingDirectional(BuildContext, {...})` - Directional padding
- `getResponsiveMargin(BuildContext, {...})` - Responsive margin
- `getSafeAreaPadding(BuildContext)` - Safe area padding

### Spacing
- `getResponsiveSpacing(BuildContext, double)` - Vertical spacing
- `getResponsiveHorizontalSpacing(BuildContext, double)` - Horizontal spacing

### Device Detection
- `isSmallDevice(BuildContext)` - Check if phone
- `isMediumDevice(BuildContext)` - Check if tablet
- `isLargeDevice(BuildContext)` - Check if desktop/large tablet
- `getResponsiveValue<T>(BuildContext, {small, medium?, large?})` - Get value based on device

### Constraints
- `getResponsiveConstraints(BuildContext, {...})` - Responsive box constraints
- `clampResponsive(BuildContext, double, {min?, max?})` - Clamp responsive value

### Shorthand Methods
- `w(double)` - Responsive width
- `h(double)` - Responsive height
- `sp(double)` - Responsive font size
- `r(double)` - Responsive radius

## Author

**Md. Adnan Ullah**
- Email: saadnanullah@gmail.com
- GitHub: [md-adnan-ullah](https://github.com/md-adnan-ullah)

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
