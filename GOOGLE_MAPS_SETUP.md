# Google Maps Integration for Select Location Page

## Overview

The select location page has been successfully implemented with Google Maps integration and Google Places API autocomplete functionality. This provides a professional location selection experience with real map interaction and place search capabilities.

## Features Implemented

✅ **Google Maps Integration**
- Real Google Maps widget with full map interaction
- Tap-to-select location functionality
- Camera animation and positioning
- Custom markers for selected locations
- My location button with current location detection

✅ **Google Places API Autocomplete**
- Real-time place search with debounced input
- Google Places API integration
- Fallback to mock data for development
- "My Location" option as first suggestion
- Place details fetching for coordinates

✅ **Custom UI Components**
- Custom app bar matching app design
- Primary button for confirmation
- Professional search field with suggestions list
- Consistent styling with app theme

✅ **Location Services**
- Current location detection using device GPS
- Reverse geocoding for address lookup
- Coordinate to address conversion
- Error handling for location services

## Setup Instructions

### 1. Get Google Maps API Keys

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Places API**
   - **Geocoding API**

4. Create API keys:
   - One for Google Maps (mobile platforms)
   - One for Google Places API (server-side)

### 2. Configure API Keys

Update the API keys in `/lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  static const String googlePlacesApiKey = 'YOUR_ACTUAL_PLACES_API_KEY';
  static const String googleMapsApiKey = 'YOUR_ACTUAL_MAPS_API_KEY';
  // ... other configurations
}
```

### 3. Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="zavona_flutter_app"
    android:icon="@mipmap/ic_launcher">
    
    <!-- Add this meta-data tag -->
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_ACTUAL_MAPS_API_KEY"/>
    
    <activity>
        <!-- your existing activity configuration -->
    </activity>
</application>
```

### 4. iOS Configuration

1. Add to `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_ACTUAL_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

2. Add location permissions to `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Add these keys -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access to help you find parking spots near you.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs location access to help you find parking spots near you.</string>
    
    <!-- your existing plist content -->
</dict>
```

### 5. Android Permissions

Ensure these permissions are in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

## Usage Example

```dart
// Navigate to select location page
final result = await context.pushNamed(RouteNames.selectLocation);

if (result != null && result is Map<String, dynamic>) {
  final latitude = result['latitude'] as double?;
  final longitude = result['longitude'] as double?;
  final address = result['address'] as String?;
  final locationName = result['locationName'] as String?;
  
  // Use the selected location data
  print('Selected: $locationName');
  print('Address: $address');
  print('Coordinates: $latitude, $longitude');
}
```

## File Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart              # API configuration
│   └── router/
│       ├── route_names.dart             # Updated with selectLocation route
│       └── app_router.dart              # Updated with route configuration
├── presentation/
│   └── common/
│       └── pages/
│           └── select_location_page.dart # Complete implementation
└── third_party_services/
    ├── location_service.dart            # Existing location service
    └── navigation_service.dart          # Updated with new route
```

## API Configuration Options

The `ApiConfig` class provides centralized configuration:

```dart
class ApiConfig {
  // API Keys
  static const String googlePlacesApiKey = 'YOUR_KEY';
  static const String googleMapsApiKey = 'YOUR_KEY';
  
  // Default location (adjust to your app's target region)
  static const double defaultLatitude = 37.7749;   // San Francisco
  static const double defaultLongitude = -122.4194;
  
  // Map settings
  static const double defaultZoom = 14.0;
  static const double selectedLocationZoom = 15.0;
  
  // Search settings
  static const int searchDebounceMilliseconds = 500;
  static const String countryComponent = 'country:us'; // Adjust as needed
}
```

## Key Features Explained

### 1. Google Places Autocomplete
- Debounced search to avoid excessive API calls
- Fetches place suggestions from Google Places API
- Gets detailed place information including coordinates
- Falls back to mock data when API key is not configured

### 2. Map Interaction
- Real Google Maps with full gesture support
- Tap anywhere on map to select location
- Animated camera movements
- Custom markers for selected locations
- Reverse geocoding for tapped locations

### 3. Current Location
- Uses device GPS to get current location
- "My Location" button for quick selection
- Integrates with existing LocationService
- Handles permission requests

### 4. Data Return
Returns comprehensive location data:
```dart
{
  'latitude': 37.7749,
  'longitude': -122.4194,
  'address': '123 Main Street, San Francisco, CA',
  'locationName': 'Downtown Area'
}
```

## Error Handling

The implementation includes comprehensive error handling:
- Network errors for API calls
- Location permission denied
- GPS service disabled
- Invalid API responses
- Fallback to mock data when needed

## Testing

### Development Mode
- Works with mock data when API keys are not configured
- Shows mock suggestions for search
- Uses mock map interaction

### Production Mode
- Requires valid Google API keys
- Full Google Maps and Places functionality
- Real location services

## Security Best Practices

1. **API Key Restrictions**: In Google Cloud Console, restrict your API keys:
   - Maps API key: Restrict to your app's package name/bundle ID
   - Places API key: Restrict to your server IP addresses

2. **Environment Variables**: Consider using `flutter_dotenv` for API keys:
```dart
// .env file
GOOGLE_MAPS_API_KEY=your_maps_key_here
GOOGLE_PLACES_API_KEY=your_places_key_here
```

3. **Rate Limiting**: Implement rate limiting for API calls to avoid quota exhaustion

## Troubleshooting

### Common Issues

1. **Map not showing**: Check if Google Maps API key is correctly configured
2. **Places not loading**: Verify Google Places API is enabled and key is valid
3. **Location permission denied**: Check platform-specific permission configurations
4. **API quota exceeded**: Monitor usage in Google Cloud Console

### Debug Mode

The implementation includes extensive debug logging:
```dart
debugPrint('Error getting current location: $e');
debugPrint('Error searching places: $e');
debugPrint('Error fetching Google Places suggestions: $e');
```

Check the console output for detailed error information during development.

## Performance Optimization

1. **Debounced Search**: Prevents excessive API calls during typing
2. **Marker Management**: Efficiently manages map markers
3. **Camera Animation**: Smooth camera transitions
4. **Memory Management**: Proper disposal of controllers and listeners

This implementation provides a production-ready location selection experience that can be easily integrated into any Flutter app requiring location functionality.
