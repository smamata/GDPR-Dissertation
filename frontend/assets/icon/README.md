# App Icon Instructions

## How to Change Your App Icon

1. **Prepare your icon image:**
   - Create a square image (recommended: 1024x1024 pixels)
   - Use PNG format with transparent background
   - Save it as `app_icon.png` in this directory

2. **Replace the placeholder:**
   - Delete the current `app_icon.png` file
   - Add your new icon file as `app_icon.png`

3. **Generate icons for all platforms:**
   ```bash
   cd frontend
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

4. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Icon Requirements

- **Size**: 1024x1024 pixels (minimum)
- **Format**: PNG with transparent background
- **Design**: Simple, recognizable design that works at small sizes
- **Colors**: Consider how it looks on both light and dark backgrounds

## Platform-Specific Notes

- **Android**: Icons will be generated in multiple densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- **iOS**: Icons will be generated for all required sizes (20x20 to 1024x1024)
- **Web**: Icons will be generated for PWA support
- **Windows/macOS/Linux**: Desktop app icons will be generated

## Current Configuration

The app is configured to use `assets/icon/app_icon.png` as the source image for all platforms.
