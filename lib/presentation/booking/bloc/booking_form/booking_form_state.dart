import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_details_response.dart';

enum RateType { hourly, daily }

class DurationData {
  final int hours;
  final int days;

  const DurationData({required this.hours, required this.days});

  DurationData copyWith({int? hours, int? days}) {
    return DurationData(hours: hours ?? this.hours, days: days ?? this.days);
  }

  Map<String, dynamic> toJson() {
    return {'hours': hours, 'days': days};
  }
}

class PricingData {
  final RateType rateType;
  final double rate;
  final double platformFee;
  final DurationData? duration;
  final double totalAmount;
  final double finalAmount;
  final double gstAmount;
  final double subTotal;

  const PricingData({
    required this.rateType,
    required this.rate,
    required this.platformFee,
    this.duration,
    this.totalAmount = 0.0,
    this.finalAmount = 0.0,
    this.gstAmount = 0.0,
    this.subTotal = 0.0,
  });

  PricingData copyWith({
    RateType? rateType,
    double? rate,
    double? platformFee,
    DurationData? duration,
    double? totalAmount,
    double? finalAmount,
    double? gstAmount,
    double? subTotal,
  }) {
    return PricingData(
      rateType: rateType ?? this.rateType,
      rate: rate ?? this.rate,
      platformFee: platformFee ?? this.platformFee,
      duration: duration ?? this.duration,
      totalAmount: totalAmount ?? this.totalAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      gstAmount: gstAmount ?? this.gstAmount,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rateType': rateType.name,
      'rate': rate,
      'platformFee': platformFee,
      'duration': duration?.toJson(),
      'totalAmount': totalAmount,
      'finalAmount': finalAmount,
    };
  }
}

class BookingFormState {
  final EFormState formState;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, String?> fieldErrors;

  // Form fields
  final ParkingSpace? parkingSpace;
  final ParkingSpot? parkingSpot;
  final String? renterId;
  final DateTime? checkInDateTime;
  final DateTime? checkOutDateTime;
  final PricingData? pricing;

  const BookingFormState({
    this.formState = EFormState.initial,
    this.errorMessage,
    this.successMessage,
    this.fieldErrors = const {},
    this.parkingSpace,
    this.parkingSpot,
    this.renterId,
    this.checkInDateTime,
    this.checkOutDateTime,
    this.pricing,
  });

  BookingFormState copyWith({
    EFormState? formState,
    String? errorMessage,
    String? successMessage,
    Map<String, String?>? fieldErrors,
    ParkingSpace? parkingSpace,
    ParkingSpot? parkingSpot,
    String? renterId,
    DateTime? checkInDateTime,
    DateTime? checkOutDateTime,
    PricingData? pricing,
  }) {
    return BookingFormState(
      formState: formState ?? this.formState,
      errorMessage: errorMessage,
      successMessage: successMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      parkingSpace: parkingSpace ?? this.parkingSpace,
      parkingSpot: parkingSpot ?? this.parkingSpot,
      renterId: renterId ?? this.renterId,
      checkInDateTime: checkInDateTime ?? this.checkInDateTime,
      checkOutDateTime: checkOutDateTime ?? this.checkOutDateTime,
      pricing: pricing ?? this.pricing,
    );
  }

  /// Check if the form is valid (no field errors)
  bool get isFormValid {
    return fieldErrors.values.every((error) => error == null);
  }

  /// Calculate duration following the backend logic
  DurationData calculateDuration() {
    if (checkInDateTime == null || checkOutDateTime == null) {
      return const DurationData(hours: 0, days: 0);
    }

    final diffMs = checkOutDateTime!
        .difference(checkInDateTime!)
        .inMilliseconds;
    final diffHours = (diffMs / (1000 * 60 * 60)).ceil();
    final diffDays = (diffMs / (1000 * 60 * 60 * 24)).ceil();

    return DurationData(hours: diffHours, days: diffDays);
  }

  /// Calculate pricing following the backend logic
  double calculatePricing() {
    if (pricing == null ||
        checkInDateTime == null ||
        checkOutDateTime == null) {
      return 0.0;
    }

    final duration = calculateDuration();
    double totalAmount = 0.0;

    if (pricing!.rateType == RateType.hourly) {
      totalAmount = duration.hours * pricing!.rate;
    } else if (pricing!.rateType == RateType.daily) {
      totalAmount = duration.days * pricing!.rate;
    }

    final finalAmount = totalAmount + pricing!.platformFee;
    return finalAmount;
  }

  /// Get the calculated total amount (before platform fee)
  double get totalAmount {
    if (pricing == null ||
        checkInDateTime == null ||
        checkOutDateTime == null) {
      return 0.0;
    }

    final duration = calculateDuration();

    if (pricing!.rateType == RateType.hourly) {
      return duration.hours * pricing!.rate;
    } else if (pricing!.rateType == RateType.daily) {
      return duration.days * pricing!.rate;
    }

    return 0.0;
  }

  /// Get the final amount (total + platform fee)
  double get finalAmount {
    return calculatePricing();
  }

  /// Get formatted duration string
  String get formattedDuration {
    final duration = calculateDuration();

    if (pricing?.rateType == RateType.hourly) {
      return '${duration.hours} hours';
    } else {
      return '${duration.days} days';
    }
  }
}
