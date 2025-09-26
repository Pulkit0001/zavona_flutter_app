import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_workflow/booking_workflow_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_workflow/booking_workflow_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/confirmation_dailog.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';

/// Enum to define user roles for booking actions
enum UserRole { owner, renter, system }

/// Callback function type for booking actions
typedef BookingActionCallback =
    void Function(String bookingId, String newStatus);

/// A widget that displays the appropriate action button based on booking status and user role
/// Now integrated with BookingWorkflowCubit for state management
class BookingActionButtonWidget extends StatelessWidget {
  final Booking booking;
  final UserRole currentUserRole;
  final VoidCallback?
  onActionCompleted; // Optional callback when action is completed

  const BookingActionButtonWidget({
    super.key,
    required this.booking,
    required this.currentUserRole,
    this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingWorkflowCubit, BookingWorkflowState>(
      builder: (context, state) {
        final cubit = context.read<BookingWorkflowCubit>();
        final bookingId = booking.id ?? '';
        final isBookingProcessing = state.isBookingProcessing(bookingId);
        final actionInfo = _getActionInfo(cubit, isBookingProcessing);

        // If no action is available, return empty container
        if (actionInfo == null || actionInfo.isEmpty) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...actionInfo.map(
              (info) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildActionButton(
                  context,
                  info,
                  isBookingProcessing,
                  state.getBookingActionState(bookingId),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build individual action button with workflow integration
  Widget _buildActionButton(
    BuildContext context,
    BookingActionInfo info,
    bool isBookingProcessing,
    WorkflowActionState? actionState,
  ) {
    final cubit = context.read<BookingWorkflowCubit>();
    final isThisActionProcessing =
        isBookingProcessing &&
        actionState?.lastAction ==
            _getWorkflowActionFromStatus(info.nextStatus)?.displayName;

    return PrimaryButton(
      size: ButtonSize.medium,
      label: isThisActionProcessing ? 'Processing...' : info.buttonText,
      isLoading: isThisActionProcessing,
      trailingIcon: Icon(
        info.icon,
        size: ButtonSize.medium.buttonTextSize,
        color: context.onPrimaryColor,
      ),
      onPressed: (isBookingProcessing || isThisActionProcessing)
          ? null
          : () => _handleActionPress(context, cubit, info),
    );
  }

  /// Handle action button press with workflow integration
  Future<void> _handleActionPress(
    BuildContext context,
    BookingWorkflowCubit cubit,
    BookingActionInfo info,
  ) async {
    final bookingId = booking.id ?? '';

    // Show confirmation dialog for destructive actions
    if (info.nextStatus == 'rejected' || info.nextStatus == 'cancelled') {
      final confirmed = await _showConfirmationDialog(context, info);
      if (!confirmed) return;
    }

    // Use workflow cubit to perform the action
    final workflowAction = _getWorkflowActionFromStatus(info.nextStatus);
    if (workflowAction != null) {
      switch (workflowAction) {
        case BookingWorkflowAction.approve:
          await cubit.approveBooking(bookingId);
          break;
        case BookingWorkflowAction.reject:
          await cubit.rejectBooking(bookingId);
          break;
        case BookingWorkflowAction.cancel:
          await cubit.cancelBooking(bookingId);
          break;
      }

      // Call completion callback if provided
      onActionCompleted?.call();
    }
  }

  /// Show confirmation dialog for destructive actions
  Future<bool> _showConfirmationDialog(
    BuildContext context,
    BookingActionInfo info,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          confirmationMessage:
              'Are you sure you want to ${info.buttonText.toLowerCase().split(" ").firstOrNull ?? ''} this booking?\n\n'
              'This action cannot be undone.',
        );
      },
    );
    return result ?? false;
  }

  /// Convert status string to workflow action enum
  BookingWorkflowAction? _getWorkflowActionFromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return BookingWorkflowAction.approve;
      case 'rejected':
        return BookingWorkflowAction.reject;
      case 'cancelled':
        return BookingWorkflowAction.cancel;
      default:
        return null;
    }
  }

  /// Determines the appropriate action based on current status and user role
  /// Now integrated with workflow cubit validation
  List<BookingActionInfo>? _getActionInfo(
    BookingWorkflowCubit cubit,
    bool isProcessing,
  ) {
    // // Return empty if booking is being processed
    // if (isProcessing) {
    //   return [];
    // }

    final status = booking.status?.toLowerCase();

    switch (status) {
      case 'pending_confirmation':
        return _getPendingConfirmationActions();
      case 'confirmed':
        return _getConfirmedActions();
      case 'payment_completed':
        return _getPaymentCompletedActions();
      case 'checked_in':
        return _getCheckedInActions();
      case 'checked_out':
        return _getCheckedOutActions();
      default:
        return null; // No actions for completed, rejected, cancelled, expired
    }
  }

  /// Actions available when booking is pending confirmation
  List<BookingActionInfo>? _getPendingConfirmationActions() {
    switch (currentUserRole) {
      case UserRole.owner:
        return [
          BookingActionInfo(
            buttonText: 'Reject',
            nextStatus: 'rejected',
            buttonColor: Colors.red,
            icon: Icons.cancel,
          ),
          BookingActionInfo(
            buttonText: 'Confirm',
            nextStatus: 'confirmed',
            buttonColor: Colors.green,
            icon: Icons.check_circle,
          ),
        ];
      case UserRole.renter:
        return [
          BookingActionInfo(
            buttonText: 'Cancel Booking',
            nextStatus: 'cancelled',
            buttonColor: Colors.red,
            icon: Icons.cancel,
          ),
        ];
      case UserRole.system:
        return null; // System actions are handled automatically
    }
  }

  /// Actions available when booking is confirmed
  List<BookingActionInfo>? _getConfirmedActions() {
    switch (currentUserRole) {
      case UserRole.owner:
        return [
          BookingActionInfo(
            buttonText: 'Cancel Booking',
            nextStatus: 'cancelled',
            buttonColor: Colors.red,
            icon: Icons.cancel,
          ),
        ];
      case UserRole.renter:
        return [
          BookingActionInfo(
            buttonText: 'Make Payment',
            nextStatus: 'payment_completed',
            buttonColor: Colors.blue,
            icon: Icons.payment,
          ),
        ];
      case UserRole.system:
        return null;
    }
  }

  /// Actions available when payment is completed
  List<BookingActionInfo>? _getPaymentCompletedActions() {
    switch (currentUserRole) {
      case UserRole.renter:
        return [
          BookingActionInfo(
            buttonText: 'Check In',
            nextStatus: 'checked_in',
            buttonColor: Colors.purple,
            icon: Icons.login,
          ),
        ];
      case UserRole.owner:
      case UserRole.system:
        return null; // No actions for owner/system at this stage
    }
  }

  /// Actions available when checked in
  List<BookingActionInfo>? _getCheckedInActions() {
    switch (currentUserRole) {
      case UserRole.renter:
        return [
          BookingActionInfo(
            buttonText: 'Check Out',
            nextStatus: 'checked_out',
            buttonColor: Colors.indigo,
            icon: Icons.logout,
          ),
        ];
      case UserRole.owner:
      case UserRole.system:
        return null; // No actions for owner/system at this stage
    }
  }

  /// Actions available when checked out
  List<BookingActionInfo>? _getCheckedOutActions() {
    // System automatically moves to completed, no manual action needed
    return null;
  }
}

/// Class to hold information about available booking actions
class BookingActionInfo {
  final String buttonText;
  final String nextStatus;
  final Color buttonColor;
  final IconData icon;

  const BookingActionInfo({
    required this.buttonText,
    required this.nextStatus,
    required this.buttonColor,
    required this.icon,
  });
}

/// Extension to provide utility methods for booking status management
extension BookingActionExtension on Booking {
  /// Check if the booking can be acted upon by the given user role
  bool canBeActedUponBy(UserRole userRole) {
    final status = this.status?.toLowerCase();

    switch (status) {
      case 'pending_confirmation':
        return userRole == UserRole.owner || userRole == UserRole.renter;
      case 'confirmed':
        return userRole == UserRole.owner || userRole == UserRole.renter;
      case 'payment_completed':
        return userRole == UserRole.renter;
      case 'checked_in':
        return userRole == UserRole.renter;
      case 'checked_out':
        return false; // System handles completion automatically
      default:
        return false; // No actions for completed, rejected, cancelled, expired
    }
  }

  /// Get the next possible statuses for the current booking status and user role
  List<String> getNextPossibleStatuses(UserRole userRole) {
    final status = this.status?.toLowerCase();

    switch (status) {
      case 'pending_confirmation':
        switch (userRole) {
          case UserRole.owner:
            return ['confirmed', 'rejected'];
          case UserRole.renter:
            return ['cancelled'];
          case UserRole.system:
            return ['expired'];
        }
      case 'confirmed':
        switch (userRole) {
          case UserRole.owner:
            return ['rejected'];
          case UserRole.renter:
            return ['payment_completed'];
          case UserRole.system:
            return ['expired'];
        }
      case 'payment_completed':
        switch (userRole) {
          case UserRole.renter:
            return ['checked_in'];
          case UserRole.owner:
          case UserRole.system:
            return [];
        }
      case 'checked_in':
        switch (userRole) {
          case UserRole.renter:
            return ['checked_out'];
          case UserRole.owner:
          case UserRole.system:
            return [];
        }
      case 'checked_out':
        // System automatically completes
        return userRole == UserRole.system ? ['completed'] : [];
      default:
        return []; // Terminal states
    }
  }

  /// Check if the booking is in a terminal state (no further actions possible)
  bool get isInTerminalState {
    final status = this.status?.toLowerCase();
    return ['completed', 'rejected', 'cancelled', 'expired'].contains(status);
  }

  /// Check if the booking is in progress (between confirmed and checked_out)
  bool get isInProgress {
    final status = this.status?.toLowerCase();
    return ['confirmed', 'payment_completed', 'checked_in'].contains(status);
  }
}
