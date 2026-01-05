# Overtime Tracker for iOS

A beautiful, fully functional iOS application designed specifically for postal workers to track overtime hours with Apple's Liquid Glass design language.

## Features

### Core Functionality
- **Daily Overtime Tracking**: Record overtime hours before and after contracted working hours
- **Weekly View**: Track your week from Monday to Sunday
- **Automatic Calculations**: Real-time daily and weekly totals
- **Data Persistence**: Your entries are automatically saved locally on your device
- **Week Navigation**: Browse previous and future weeks

### Design
- **Liquid Glass Design Language**: Beautiful translucent materials and subtle gradients
- **Apple-Native Typography**: San Francisco Rounded font for a modern, friendly feel
- **Elegant Color Scheme**: Soft blues and cyans with subtle gradient accents
- **Smooth Animations**: Native SwiftUI animations for a polished experience
- **Dark Mode Ready**: Full support for iOS light and dark modes

## Project Structure

```
OvertimeTracker/
├── OvertimeTracker/
│   ├── OvertimeTrackerApp.swift          # App entry point
│   ├── Models/
│   │   ├── OvertimeEntry.swift           # Daily overtime data model
│   │   └── WeekData.swift                # Weekly data aggregation
│   ├── ViewModels/
│   │   └── OvertimeViewModel.swift       # Business logic and state management
│   ├── Views/
│   │   ├── ContentView.swift             # Main app view
│   │   └── DayEntryView.swift            # Individual day entry component
│   ├── Assets.xcassets/                  # App icons and color assets
│   └── Info.plist                        # App configuration
```

## Requirements

- **iOS 16.0+**
- **Xcode 14.0+**
- **Swift 5.7+**

## Installation

1. Clone or download this repository
2. Open `OvertimeTracker.xcodeproj` in Xcode
3. Select your target device (iPhone or iOS Simulator)
4. Build and run (⌘R)

## Usage

### Recording Overtime

1. **Select a Day**: The app displays the current week by default
2. **Enter Hours**:
   - Tap "Before" to enter overtime worked before your contracted hours
   - Tap "After" to enter overtime worked after your contracted hours
3. **View Totals**:
   - Each day shows its total automatically
   - The weekly total card displays your cumulative overtime

### Navigating Weeks

- Tap the **left arrow** to view the previous week
- Tap the **right arrow** to view the next week
- Tap **"Current Week"** to jump back to the present week

### Data Persistence

- All data is automatically saved as you type
- Your current week's data persists between app launches
- Historical data can be extended with cloud storage (future feature)

## Technical Details

### Architecture

- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **Combine Framework**: Reactive state management
- **UserDefaults**: Local data persistence

### Key Components

#### OvertimeViewModel
Manages app state, handles data persistence, and provides week navigation functionality.

#### OvertimeEntry
Represents a single day's overtime data with before/after contracted hours tracking.

#### WeekData
Aggregates 7 days of overtime entries and calculates weekly totals.

### Design System

- **Materials**: `.ultraThinMaterial` for Liquid Glass effect
- **Typography**: San Francisco Rounded (`.rounded` design)
- **Colors**:
  - Primary: Blue (#007AFF)
  - Accent: Cyan
  - Background: Soft gradient (light blue/purple tones)
- **Spacing**: 8pt grid system
- **Corner Radius**: 12-24pt for cards and inputs

## Future Enhancements

- [ ] iCloud sync for multi-device access
- [ ] Historical data export (CSV, PDF)
- [ ] Monthly and yearly views
- [ ] Overtime rate calculations
- [ ] Notifications for logging hours
- [ ] Widgets for quick entry
- [ ] Apple Watch companion app

## Development Notes

### Building from Source

This project uses standard SwiftUI and requires no external dependencies. Simply open in Xcode and build.

### Customization

You can customize the app's appearance by modifying:
- **Colors**: Update the gradient colors in `ContentView.swift`
- **Typography**: Adjust font weights and sizes throughout the views
- **Week Start Day**: Currently set to Monday in `WeekData.swift`

## License

This project is created for personal use. Feel free to modify and adapt it to your needs.

## Support

For issues or questions about the app, please refer to the code comments or iOS development documentation.

---

**Built with ❤️ for postal workers tracking their hard work**
