import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/domain/repositories/bookings_repository.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_workflow/booking_workflow_state.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_action_button_widget.dart';

/// Cubit that manages booking workflow actions like approval, rejection, and cancellation
class BookingWorkflowCubit extends Cubit<BookingWorkflowState> {
  final BookingsRepository _bookingsRepository = locator<BookingsRepository>();

  BookingWorkflowCubit() : super(const BookingWorkflowState());

  /// Approve a booking (Owner action)
  Future<void> approveBooking(String bookingId) async {
    await _performWorkflowAction(
      bookingId: bookingId,
      action: BookingWorkflowAction.approve,
      apiCall: () => _bookingsRepository.acceptBooking(bookingId: bookingId),
    );
  }

  /// Reject a booking (Owner action)
  Future<void> rejectBooking(String bookingId) async {
    await _performWorkflowAction(
      bookingId: bookingId,
      action: BookingWorkflowAction.reject,
      apiCall: () => _bookingsRepository.rejectBooking(bookingId: bookingId),
    );
  }

  /// Cancel a booking (Renter action)
  Future<void> cancelBooking(String bookingId) async {
    await _performWorkflowAction(
      bookingId: bookingId,
      action: BookingWorkflowAction.cancel,
      apiCall: () => _bookingsRepository.cancelBooking(bookingId: bookingId),
    );
  }

  /// Generic method to perform workflow actions
  Future<void> _performWorkflowAction({
    required String bookingId,
    required BookingWorkflowAction action,
    required Future<dynamic> Function() apiCall,
  }) async {
    // Prevent multiple simultaneous actions on the same booking
    if (state.isBookingProcessing(bookingId)) {
      log('Booking $bookingId is already being processed');
      return;
    }

    try {
      // Set processing state for this specific booking
      _setBookingProcessingState(bookingId, true, action);

      // Perform the API call
      final response = await apiCall();

      // Check if the response indicates success
      final success = response?.success ?? false;

      if (success) {
        // Set success state
        _setBookingActionSuccess(
          bookingId,
          action,
          '${action.displayName} successful',
        );

        // Show success message
        MessageUtils.showSuccessMessage(
          'Booking ${action.displayName.toLowerCase()}d successfully',
        );

        log(
          'Booking $bookingId ${action.displayName.toLowerCase()}d successfully',
        );
      } else {
        // Handle API response error
        final errorMessage =
            response?.message ??
            'Failed to ${action.displayName.toLowerCase()} booking';

        _setBookingActionError(bookingId, action, errorMessage);
        MessageUtils.showErrorMessage(errorMessage);
      }
    } catch (e, stackTrace) {
      log(
        'Error ${action.displayName.toLowerCase()}ing booking $bookingId: $e',
        stackTrace: stackTrace,
      );

      final errorMessage =
          'Failed to ${action.displayName.toLowerCase()} booking. Please try again.';

      // Set error state
      _setBookingActionError(bookingId, action, errorMessage);

      // Show error message to user
      MessageUtils.showErrorMessage(errorMessage);
    }
  }

  /// Set processing state for a specific booking
  void _setBookingProcessingState(
    String bookingId,
    bool isProcessing,
    BookingWorkflowAction action,
  ) {
    final updatedActionStates = Map<String, WorkflowActionState>.from(
      state.actionStates,
    );

    updatedActionStates[bookingId] = WorkflowActionState(
      isProcessing: isProcessing,
      lastAction: action.displayName,
      lastActionTime: DateTime.now(),
    );

    emit(
      state.copyWith(
        actionStates: updatedActionStates,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  /// Set success state for a booking action
  void _setBookingActionSuccess(
    String bookingId,
    BookingWorkflowAction action,
    String successMessage,
  ) {
    final updatedActionStates = Map<String, WorkflowActionState>.from(
      state.actionStates,
    );

    updatedActionStates[bookingId] = WorkflowActionState(
      isProcessing: false,
      lastAction: action.displayName,
      successMessage: successMessage,
      lastActionTime: DateTime.now(),
    );

    emit(
      state.copyWith(
        formState: EFormState.submittingSuccess,
        actionStates: updatedActionStates,
        successMessage: successMessage,
        errorMessage: null,
      ),
    );
  }

  /// Set error state for a booking action
  void _setBookingActionError(
    String bookingId,
    BookingWorkflowAction action,
    String errorMessage,
  ) {
    final updatedActionStates = Map<String, WorkflowActionState>.from(
      state.actionStates,
    );

    updatedActionStates[bookingId] = WorkflowActionState(
      isProcessing: false,
      lastAction: action.displayName,
      errorMessage: errorMessage,
      lastActionTime: DateTime.now(),
    );

    emit(
      state.copyWith(
        formState: EFormState.submittingFailed,
        actionStates: updatedActionStates,
        errorMessage: errorMessage,
        successMessage: null,
      ),
    );
  }

  /// Clear the action state for a specific booking
  void clearBookingActionState(String bookingId) {
    final updatedActionStates = Map<String, WorkflowActionState>.from(
      state.actionStates,
    );
    updatedActionStates.remove(bookingId);

    emit(
      state.copyWith(
        actionStates: updatedActionStates,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  /// Clear all action states
  void clearAllActionStates() {
    emit(
      state.copyWith(
        actionStates: {},
        errorMessage: null,
        successMessage: null,
        formState: EFormState.initial,
      ),
    );
  }

  /// Clear global error and success messages
  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  /// Batch approve multiple bookings
  Future<void> batchApproveBookings(List<String> bookingIds) async {
    final List<String> successfulIds = [];
    final List<String> failedIds = [];

    for (final bookingId in bookingIds) {
      try {
        await approveBooking(bookingId);

        // Check if the action was successful
        final actionState = state.getBookingActionState(bookingId);
        if (actionState?.wasLastActionSuccessful ?? false) {
          successfulIds.add(bookingId);
        } else {
          failedIds.add(bookingId);
        }
      } catch (e) {
        failedIds.add(bookingId);
      }
    }

    // Show batch result message
    if (successfulIds.isNotEmpty && failedIds.isEmpty) {
      MessageUtils.showSuccessMessage(
        '${successfulIds.length} bookings approved successfully',
      );
    } else if (successfulIds.isNotEmpty && failedIds.isNotEmpty) {
      MessageUtils.showWarningMessage(
        '${successfulIds.length} bookings approved, ${failedIds.length} failed',
      );
    } else if (failedIds.isNotEmpty) {
      MessageUtils.showErrorMessage(
        'Failed to approve ${failedIds.length} bookings',
      );
    }
  }

  /// Batch reject multiple bookings
  Future<void> batchRejectBookings(List<String> bookingIds) async {
    final List<String> successfulIds = [];
    final List<String> failedIds = [];

    for (final bookingId in bookingIds) {
      try {
        await rejectBooking(bookingId);

        // Check if the action was successful
        final actionState = state.getBookingActionState(bookingId);
        if (actionState?.wasLastActionSuccessful ?? false) {
          successfulIds.add(bookingId);
        } else {
          failedIds.add(bookingId);
        }
      } catch (e) {
        failedIds.add(bookingId);
      }
    }

    // Show batch result message
    if (successfulIds.isNotEmpty && failedIds.isEmpty) {
      MessageUtils.showSuccessMessage(
        '${successfulIds.length} bookings rejected successfully',
      );
    } else if (successfulIds.isNotEmpty && failedIds.isNotEmpty) {
      MessageUtils.showWarningMessage(
        '${successfulIds.length} bookings rejected, ${failedIds.length} failed',
      );
    } else if (failedIds.isNotEmpty) {
      MessageUtils.showErrorMessage(
        'Failed to reject ${failedIds.length} bookings',
      );
    }
  }

  /// Validate if a booking can have the specified action performed
  bool canPerformAction(
    Booking booking,
    BookingWorkflowAction action,
    UserRole userRole,
  ) {
    // Check if booking is currently being processed
    if (state.isBookingProcessing(booking.id ?? '')) {
      return false;
    }

    // Use the extension method to validate
    return booking.canPerformAction(action, userRole);
  }

  /// Get available actions for a booking based on user role
  List<BookingWorkflowAction> getAvailableActions(
    Booking booking,
    UserRole userRole,
  ) {
    // Return empty list if booking is being processed
    if (state.isBookingProcessing(booking.id ?? '')) {
      return [];
    }

    switch (userRole) {
      case UserRole.owner:
        return booking.availableOwnerActions;
      case UserRole.renter:
        return booking.availableRenterActions;
      case UserRole.system:
        return []; // System actions are automated
    }
  }

  @override
  Future<void> close() {
    // Clean up any pending operations
    return super.close();
  }
}
