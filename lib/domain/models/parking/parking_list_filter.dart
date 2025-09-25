class ParkingListFilter {
  final String? owner;
  final String? societyName;
  final String? isVerified;
  final String? minSellingPrice;
  final String? maxSellingPrice;
  final String? minRentPricePerDay;
  final String? maxRentPricePerDay;
  final String? minRentPricePerHour;
  final String? maxRentPricePerHour;
  final String? availableToSell;
  final String? availableToRent;
  final String? maxDistance;
  final double? latitude;
  final double? longitude;

  const ParkingListFilter({
    this.owner,
    this.societyName,
    this.isVerified,
    this.minSellingPrice,
    this.maxSellingPrice,
    this.minRentPricePerDay,
    this.maxRentPricePerDay,
    this.minRentPricePerHour,
    this.maxRentPricePerHour,
    this.availableToSell,
    this.availableToRent,
    this.maxDistance,
    this.latitude,
    this.longitude,
  });

  /// Creates a filter with default values
  factory ParkingListFilter.initial({
    required double? latitude,
    required double? longitude,
    String? maxDistance
  }) =>
      ParkingListFilter(
        latitude: latitude,
        longitude: longitude,
        maxDistance: maxDistance,
      );

  /// Creates a copy with updated location coordinates
  static ParkingListFilter updateLocation(
    ParkingListFilter filter, {
    required double latitude,
    required double longitude,
  }) =>
      filter.copyWith(
        latitude: latitude,
        longitude: longitude,
      );

  ParkingListFilter copyWith({
    String? owner,
    String? societyName,
    String? isVerified,
    String? minSellingPrice,
    String? maxSellingPrice,
    String? minRentPricePerDay,
    String? maxRentPricePerDay,
    String? minRentPricePerHour,
    String? maxRentPricePerHour,
    String? availableToSell,
    String? availableToRent,
    String? maxDistance,
    double? latitude,
    double? longitude,
  }) {
    return ParkingListFilter(
      owner: owner ?? this.owner,
      societyName: societyName ?? this.societyName,
      isVerified: isVerified ?? this.isVerified,
      minSellingPrice: minSellingPrice ?? this.minSellingPrice,
      maxSellingPrice: maxSellingPrice ?? this.maxSellingPrice,
      minRentPricePerDay: minRentPricePerDay ?? this.minRentPricePerDay,
      maxRentPricePerDay: maxRentPricePerDay ?? this.maxRentPricePerDay,
      minRentPricePerHour: minRentPricePerHour ?? this.minRentPricePerHour,
      maxRentPricePerHour: maxRentPricePerHour ?? this.maxRentPricePerHour,
      availableToSell: availableToSell ?? this.availableToSell,
      availableToRent: availableToRent ?? this.availableToRent,
      maxDistance: maxDistance ?? this.maxDistance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}