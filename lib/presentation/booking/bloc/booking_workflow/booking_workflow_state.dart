import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_action_button_widget.dart';

/// State for BookingWorkflowCubit that manages booking approval/rejection workflow
class BookingWorkflowState {
  final EFormState formState;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, WorkflowActionState> actionStates;

  const BookingWorkflowState({
    this.formState = EFormState.initial,
    this.errorMessage,
    this.successMessage,
    this.actionStates = const {},
  });

  BookingWorkflowState copyWith({
    EFormState? formState,
    String? errorMessage,
    String? successMessage,
    Map<String, WorkflowActionState>? actionStates,
  }) {
    return BookingWorkflowState(
      formState: formState ?? this.formState,
      errorMessage: errorMessage,
      successMessage: successMessage,
      actionStates: actionStates ?? this.actionStates,
    );
  }

  /// Check if a specific booking is being processed
  bool isBookingProcessing(String bookingId) {
    return actionStates[bookingId]?.isProcessing ?? false;
  }

  /// Get the action state for a specific booking
  WorkflowActionState? getBookingActionState(String bookingId) {
    return actionStates[bookingId];
  }

  /// Check if any booking is currently being processed
  bool get hasProcessingBookings {
    return actionStates.values.any((state) => state.isProcessing);
  }

  /// Get all booking IDs that are currently being processed
  List<String> get processingBookingIds {
    return actionStates.entries
        .where((entry) => entry.value.isProcessing)
        .map((entry) => entry.key)
        .toList();
  }
}

/// Represents the state of a workflow action for a specific booking
class WorkflowActionState {
  final bool isProcessing;
  final String? lastAction;
  final String? errorMessage;
  final String? successMessage;
  final DateTime? lastActionTime;

  const WorkflowActionState({
    this.isProcessing = false,
    this.lastAction,
    this.errorMessage,
    this.successMessage,
    this.lastActionTime,
  });

  WorkflowActionState copyWith({
    bool? isProcessing,
    String? lastAction,
    String? errorMessage,
    String? successMessage,
    DateTime? lastActionTime,
  }) {
    return WorkflowActionState(
      isProcessing: isProcessing ?? this.isProcessing,
      lastAction: lastAction ?? this.lastAction,
      errorMessage: errorMessage,
      successMessage: successMessage,
      lastActionTime: lastActionTime ?? this.lastActionTime,
    );
  }

  /// Check if the last action was successful
  bool get wasLastActionSuccessful {
    return successMessage != null && errorMessage == null;
  }

  /// Check if the last action failed
  bool get didLastActionFail {
    return errorMessage != null;
  }
}

/// Enum representing possible workflow actions
enum BookingWorkflowAction {
  approve('confirmed', 'Approve'),
  reject('rejected', 'Reject'),
  cancel('cancelled', 'Cancel');

  const BookingWorkflowAction(this.targetStatus, this.displayName);

  final String targetStatus;
  final String displayName;
}

/// Extension to provide booking workflow validation
extension BookingWorkflowValidation on Booking {
  /// Check if the booking can be approved by owner
  bool get canBeApprovedByOwner {
    return status?.toLowerCase() == 'pending_confirmation';
  }

  /// Check if the booking can be rejected by owner
  bool get canBeRejectedByOwner {
    return status?.toLowerCase() == 'pending_confirmation' ||
        status?.toLowerCase() == 'confirmed';
  }

  /// Check if the booking can be cancelled by renter
  bool get canBeCancelledByRenter {
    return status?.toLowerCase() == 'pending_confirmation';
  }

  /// Get available actions for owner
  List<BookingWorkflowAction> get availableOwnerActions {
    final actions = <BookingWorkflowAction>[];

    if (canBeApprovedByOwner) {
      actions.add(BookingWorkflowAction.approve);
    }

    if (canBeRejectedByOwner) {
      actions.add(BookingWorkflowAction.reject);
    }

    return actions;
  }

  /// Get available actions for renter
  List<BookingWorkflowAction> get availableRenterActions {
    final actions = <BookingWorkflowAction>[];

    if (canBeCancelledByRenter) {
      actions.add(BookingWorkflowAction.cancel);
    }

    return actions;
  }

  /// Validate if a specific action can be performed
  bool canPerformAction(BookingWorkflowAction action, UserRole userRole) {
    switch (action) {
      case BookingWorkflowAction.approve:
        return userRole == UserRole.owner && canBeApprovedByOwner;
      case BookingWorkflowAction.reject:
        return userRole == UserRole.owner && canBeRejectedByOwner;
      case BookingWorkflowAction.cancel:
        return userRole == UserRole.renter && canBeCancelledByRenter;
    }
  }
}
