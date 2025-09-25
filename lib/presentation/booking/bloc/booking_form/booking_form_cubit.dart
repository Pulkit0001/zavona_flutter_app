import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/domain/repositories/bookings_repository.dart';
import 'package:zavona_flutter_app/domain/repositories/parkings_repository.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_form/booking_form_state.dart';

class BookingFormCubit extends Cubit<BookingFormState> {
  BookingFormCubit({this.parkingSpaceId = ''})
    : super(const BookingFormState());

  final String parkingSpaceId;

  final checkInTimeController = TextEditingController();
  final checkOutTimeController = TextEditingController();
  final checkInDateController = TextEditingController();
  final checkOutDateController = TextEditingController();

  final checkInTimeFocusNode = FocusNode();
  final checkOutTimeFocusNode = FocusNode();
  final checkInDateFocusNode = FocusNode();
  final checkOutDateFocusNode = FocusNode();

  final BookingsRepository _bookingsRepository = locator<BookingsRepository>();
  final ParkingsRepository _parkingsRepository = locator<ParkingsRepository>();

  void initializeForm() async {
    if (parkingSpaceId.isNotEmpty) {
      emit(state.copyWith(formState: EFormState.loadingForm));
      var res = await _parkingsRepository.getParkingById(parkingSpaceId);
      if (res.data != null) {
        final parkingSpace = res.data!.parkingSpace;
        final parkingSpot = res.data!.parkingSpot?.firstOrNull;
        if (parkingSpot != null && parkingSpace != null) {
          emit(
            state.copyWith(
              formState: EFormState.initial,
              parkingSpace: parkingSpace,
              parkingSpot: parkingSpot,
            ),
          );
        } else {
          emit(
            state.copyWith(
              formState: EFormState.failure,
              errorMessage: 'Invalid parking space or spot data',
            ),
          );
        }
      }
    }
  }

  void updateCheckInDateTime(DateTime dateTime) {
    emit(state.copyWith(checkInDateTime: dateTime));
    _recalculatePricing();
  }

  void updateCheckOutDateTime(DateTime dateTime) {
    emit(state.copyWith(checkOutDateTime: dateTime));
    _recalculatePricing();
  }

  void _recalculatePricing() {
    if (state.checkInDateTime == null || state.checkOutDateTime == null) {
      return;
    }
    var duration = state.calculateDuration();
    if (duration.days > 0) {
      emit(
        state.copyWith(
          pricing: PricingData(
            rateType: RateType.daily,
            rate: (state.parkingSpot?.rentPricePerDay ?? 0).toDouble(),
            platformFee: 10,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          pricing: PricingData(
            rateType: RateType.hourly,
            rate: (state.parkingSpot?.rentPricePerHour ?? 0).toDouble(),
            platformFee: 0,
          ),
        ),
      );
    }

    // Calculate total amount based on rate type
    double totalAmount = 0.0;
    if (state.pricing!.rateType == RateType.hourly) {
      totalAmount = duration.hours * state.pricing!.rate;
    } else if (state.pricing!.rateType == RateType.daily) {
      totalAmount = duration.days * state.pricing!.rate;
    }

    /// Apply 10 percent plaftorm fee
    var platformFee = totalAmount * 0.1;

    var subtotal = totalAmount + platformFee;

    /// Apply 18 percent GST Fee
    var gstAmount = subtotal * 0.18;

    // Calculate final amount
    final finalAmount = subtotal + gstAmount;

    // Update pricing with calculated values
    emit(
      state.copyWith(
        pricing: state.pricing!.copyWith(
          duration: duration,
          totalAmount: totalAmount,
          finalAmount: finalAmount,
          platformFee: platformFee,
          gstAmount: gstAmount,
          subTotal: subtotal,
        ),
      ),
    );
  }

  /// Clear all error messages
  void clearErrors() {
    emit(state.copyWith(errorMessage: null, fieldErrors: {}));
  }

  /// Validate datetime section
  void validateDateTimeSection() {
    final errors = Map<String, String?>.from(state.fieldErrors);
    errors['checkInDateTime'] = _validateCheckInDateTime();
    errors['checkOutDateTime'] = _validateCheckOutDateTime();
    errors['dateTimeRange'] = _validateDateTimeRange();
    emit(state.copyWith(fieldErrors: errors));
  }

  /// Validate all sections
  void validateAllSections() {
    validateDateTimeSection();
  }

  String? _validateCheckInDateTime() {
    if (state.checkInDateTime == null) {
      return 'Check-in date and time is required';
    }

    final now = DateTime.now();
    if (state.checkInDateTime!.isBefore(now)) {
      return 'Check-in time cannot be in the past';
    }

    return null;
  }

  String? _validateCheckOutDateTime() {
    if (state.checkOutDateTime == null) {
      return 'Check-out date and time is required';
    }

    if (state.checkInDateTime != null) {
      if (state.checkOutDateTime!.isBefore(state.checkInDateTime!) ||
          state.checkOutDateTime!.isAtSameMomentAs(state.checkInDateTime!)) {
        return 'Check-out time must be after check-in time';
      }
    }

    return null;
  }

  String? _validateDateTimeRange() {
    if (state.checkInDateTime != null && state.checkOutDateTime != null) {
      final duration = state.checkOutDateTime!.difference(
        state.checkInDateTime!,
      );

      // Minimum 30 minutes booking
      if (duration.inMinutes < 30) {
        return 'Minimum booking duration is 30 minutes';
      }

      // Maximum 30 days booking
      if (duration.inDays > 30) {
        return 'Maximum booking duration is 30 days';
      }
    }

    return null;
  }

  Future<void> createBooking(String renterId) async {
    // Validate all sections first
    validateAllSections();

    if (!state.isFormValid) {
      MessageUtils.showErrorMessage(
        state.fieldErrors.values.whereType<String>().join('\n'),
      );
      return;
    }

    emit(
      state.copyWith(
        formState: EFormState.submittingForm,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      await _bookingsRepository.createBooking(
        parkingspace: state.parkingSpace!.id!,
        parkingspot: state.parkingSpot!.id!,
        renter: renterId,
        checkindatetime: state.checkInDateTime!.toIso8601String(),
        checkoutdatetime: state.checkOutDateTime!.toIso8601String(),
        pricingPlatformfee: state.pricing!.platformFee,
        pricingRate: state.pricing!.rate,
        pricingRatetype: state.pricing!.rateType.name.toString(),
      );

      emit(
        state.copyWith(
          formState: EFormState.submittingSuccess,
          successMessage: 'Booking created successfully',
        ),
      );

      MessageUtils.showSuccessMessage('Booking created successfully');

      emit(
        state.copyWith(
          formState: EFormState.submittingSuccess,
          successMessage: 'Booking created successfully',
        ),
      );

      MessageUtils.showSuccessMessage('Booking created successfully');
    } catch (e) {
      emit(
        state.copyWith(
          formState: EFormState.submittingFailed,
          errorMessage: e.toString(),
        ),
      );

      MessageUtils.showErrorMessage(e.toString());
    }
  }

  @override
  Future<void> close() {
    checkInDateController.dispose();
    checkOutDateController.dispose();
    checkInTimeController.dispose();
    checkOutTimeController.dispose();

    checkInDateFocusNode.dispose();
    checkOutDateFocusNode.dispose();
    checkInTimeFocusNode.dispose();
    checkOutTimeFocusNode.dispose();

    return super.close();
  }
}
