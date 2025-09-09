class ApiConfig {
  // TODO: Replace with your actual Google Places API key
  // Get your API key from: https://developers.google.com/maps/documentation/places/web-service/get-api-key
  static const String googlePlacesApiKey =
      'AIzaSyAOwBCXcqwVH6sLmyx1VN5p0uyoyU3nCJ8';

  // TODO: Replace with your actual Google Maps API key
  // Get your API key from: https://developers.google.com/maps/documentation/android-sdk/get-api-key
  static const String googleMapsApiKey =
      'AIzaSyAjZkI0h0tSoLAVF2e5nRgoroas0PIQkhc';

  // Base URLs
  static const String googlePlacesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String googleGeocodingBaseUrl =
      'https://maps.googleapis.com/maps/api/geocode';

  // Default location (San Francisco)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;

  // Map settings
  static const double defaultZoom = 14.0;
  static const double selectedLocationZoom = 15.0;

  // API request settings
  static const int searchDebounceMilliseconds = 1500;
  static const int maxPlaceSuggestions = 5;

  // Country component (adjust as needed)
  static const String countryComponent = 'country:in';
}
