# Booking Workflow Cubit

A comprehensive Flutter Bloc cubit that manages booking approval and rejection workflows for owners in the Zavona parking app.

## Overview

The `BookingWorkflowCubit` provides a centralized state management solution for handling booking workflow actions like:
- **Approve** bookings (Owner action)
- **Reject** bookings (Owner action) 
- **Cancel** bookings (Renter action)
- **Batch operations** for multiple bookings

## Features

- ✅ **State Management**: Centralized state for all booking workflow actions
- ✅ **Loading States**: Individual loading states per booking to prevent duplicate actions
- ✅ **Error Handling**: Comprehensive error handling with user-friendly messages
- ✅ **Batch Operations**: Support for approving/rejecting multiple bookings at once
- ✅ **Integration**: Seamlessly integrates with existing `BookingActionButtonWidget`
- ✅ **Backward Compatibility**: Maintains existing callback interfaces

## Architecture

```
BookingWorkflowCubit
├── BookingWorkflowState
│   ├── formState: EFormState
│   ├── errorMessage: String?
│   ├── successMessage: String?
│   └── actionStates: Map<String, WorkflowActionState>
└── Methods
    ├── approveBooking(String bookingId)
    ├── rejectBooking(String bookingId)
    ├── cancelBooking(String bookingId)
    ├── batchApproveBookings(List<String> bookingIds)
    └── batchRejectBookings(List<String> bookingIds)
```

## Usage

### Basic Usage with BookingActionButtonWidget

The existing `BookingActionButtonWidget` has been enhanced to work with the `BookingWorkflowCubit`:

```dart
// Provide the cubit at a higher level
BlocProvider(
  create: (context) => BookingWorkflowCubit(),
  child: YourBookingListWidget(),
)

// Use the enhanced BookingActionButtonWidget
BookingActionButtonWidget(
  booking: booking,
  currentUserRole: UserRole.owner, // or UserRole.renter
  onActionCompleted: () {
    // Optional callback when action completes
    print('Booking action completed');
  },
)
```

### Advanced Usage with Custom Implementation

```dart
class OwnerBookingManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Bookings')),
      body: BlocProvider(
        create: (context) => BookingWorkflowCubit(),
        child: BlocBuilder<BookingWorkflowCubit, BookingWorkflowState>(
          builder: (context, state) {
            return Column(
              children: [
                // Individual booking actions
                BookingActionButtonWidget(
                  booking: booking,
                  currentUserRole: UserRole.owner,
                ),
                
                // Batch operations
                ElevatedButton(
                  onPressed: () {
                    final cubit = context.read<BookingWorkflowCubit>();
                    cubit.batchApproveBookings(['booking1', 'booking2']);
                  },
                  child: Text('Approve Selected'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

### Listening to State Changes

```dart
BlocListener<BookingWorkflowCubit, BookingWorkflowState>(
  listener: (context, state) {
    if (state.formState == EFormState.submittingSuccess) {
      // Action completed successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking action completed')),
      );
    } else if (state.formState == EFormState.submittingFailed) {
      // Action failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Action failed')),
      );
    }
  },
  child: YourWidget(),
)
```

## API Methods

### Individual Actions

```dart
final cubit = context.read<BookingWorkflowCubit>();

// Approve a booking (Owner only)
await cubit.approveBooking('booking_id');

// Reject a booking (Owner only) 
await cubit.rejectBooking('booking_id');

// Cancel a booking (Renter only)
await cubit.cancelBooking('booking_id');
```

### Batch Actions

```dart
// Batch approve multiple bookings
await cubit.batchApproveBookings(['id1', 'id2', 'id3']);

// Batch reject multiple bookings  
await cubit.batchRejectBookings(['id1', 'id2', 'id3']);
```

### State Queries

```dart
// Check if a specific booking is being processed
bool isProcessing = state.isBookingProcessing('booking_id');

// Get action state for a specific booking
WorkflowActionState? actionState = state.getBookingActionState('booking_id');

// Check if any bookings are currently being processed
bool hasProcessing = state.hasProcessingBookings;
```

## Workflow States

### BookingWorkflowAction Enum
- `approve` → Target status: 'confirmed'
- `reject` → Target status: 'rejected'  
- `cancel` → Target status: 'cancelled'

### WorkflowActionState
```dart
class WorkflowActionState {
  final bool isProcessing;
  final String? lastAction;
  final String? errorMessage;
  final String? successMessage;
  final DateTime? lastActionTime;
}
```

## Integration with Existing Code

The cubit seamlessly integrates with existing booking components:

1. **BookingActionButtonWidget**: Enhanced with cubit integration
2. **BookingListCubit**: Can be used alongside for list management
3. **BookingsRepository**: Uses existing repository methods
4. **Existing callbacks**: Maintains backward compatibility

## Error Handling

The cubit provides comprehensive error handling:

- **Network errors**: Gracefully handled with user-friendly messages
- **Validation errors**: Prevents invalid actions (e.g., processing same booking twice)
- **API response errors**: Parses and displays server error messages
- **Loading states**: Prevents duplicate actions during processing

## Example Pages

See `booking_workflow_example_page.dart` for complete implementation examples including:
- Individual booking management
- Batch operations
- State listening
- Error handling

## Migration Guide

### From Direct API Calls

**Before:**
```dart
onPressed: () async {
  try {
    await BookingsRepository().acceptBooking(bookingId: bookingId);
    // Handle success
  } catch (e) {
    // Handle error
  }
}
```

**After:**
```dart
BookingActionButtonWidget(
  booking: booking,
  currentUserRole: UserRole.owner,
  onActionCompleted: () {
    // Handle completion
  },
)
```

### From Custom Action Buttons

**Before:**
```dart
ElevatedButton(
  onPressed: () => _handleApproval(),
  child: Text('Approve'),
)
```

**After:**
```dart
BlocProvider(
  create: (context) => BookingWorkflowCubit(),
  child: BookingActionButtonWidget(
    booking: booking,
    currentUserRole: UserRole.owner,
  ),
)
```

## Files Structure

```
lib/presentation/booking/bloc/booking_workflow/
├── booking_workflow_cubit.dart       # Main cubit implementation
├── booking_workflow_state.dart       # State classes and enums
└── booking_workflow_example_page.dart # Usage examples

lib/presentation/booking/widgets/
└── booking_action_button_widget.dart # Enhanced widget with cubit integration
```

## Dependencies

- `flutter_bloc`: State management
- `zavona_flutter_app/domain/repositories/bookings_repository.dart`: API calls
- `zavona_flutter_app/core/presentation/utils/message_utils.dart`: User messages
- `zavona_flutter_app/core/presentation/blocs/e_states.dart`: Common state enums