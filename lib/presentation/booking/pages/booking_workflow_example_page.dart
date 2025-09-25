import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_workflow/booking_workflow_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_action_button_widget.dart';

/// Example page showing how to use the updated BookingActionButtonWidget
/// with the BookingWorkflowCubit for owner approval/rejection workflow
class BookingWorkflowExamplePage extends StatelessWidget {
  final List<Booking> bookings;

  const BookingWorkflowExamplePage({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Workflow Management'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        // Provide the BookingWorkflowCubit
        create: (context) => BookingWorkflowCubit(),
        child: BookingWorkflowView(bookings: bookings),
      ),
    );
  }
}

class BookingWorkflowView extends StatelessWidget {
  final List<Booking> bookings;

  const BookingWorkflowView({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    // Filter bookings that need owner action (pending confirmation)
    final pendingBookings = bookings
        .where(
          (booking) => booking.status?.toLowerCase() == 'pending_confirmation',
        )
        .toList();

    if (pendingBookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
              SizedBox(height: 16),
              Text(
                'No Pending Bookings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'All booking requests have been processed.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingBookings.length,
      itemBuilder: (context, index) {
        final booking = pendingBookings[index];
        return _buildBookingCard(context, booking);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.parkingSpace?.name ?? 'Unknown Parking Space',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Booking details
            _buildDetailRow('Customer', booking.renter?.name ?? 'Unknown'),
            _buildDetailRow(
              'Location',
              booking.parkingSpace?.address ?? 'Unknown',
            ),
            _buildDetailRow(
              'Check-in',
              booking.checkInDateTime?.toString().split(' ').first ?? 'Unknown',
            ),
            _buildDetailRow(
              'Check-out',
              booking.checkOutDateTime?.toString().split(' ').first ??
                  'Unknown',
            ),
            _buildDetailRow('Amount', '₹${booking.pricing?.finalAmount ?? 0}'),

            const SizedBox(height: 16),

            // Action buttons using the updated BookingActionButtonWidget
            BookingActionButtonWidget(
              booking: booking,
              currentUserRole: UserRole.owner, // Owner can approve/reject
              onActionCompleted: () {
                // Optional: Refresh the list or show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking action completed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Alternative usage example showing batch operations
class BatchBookingWorkflowExample extends StatefulWidget {
  final List<Booking> bookings;

  const BatchBookingWorkflowExample({super.key, required this.bookings});

  @override
  State<BatchBookingWorkflowExample> createState() =>
      _BatchBookingWorkflowExampleState();
}

class _BatchBookingWorkflowExampleState
    extends State<BatchBookingWorkflowExample> {
  final Set<String> selectedBookingIds = {};

  @override
  Widget build(BuildContext context) {
    final pendingBookings = widget.bookings
        .where(
          (booking) => booking.status?.toLowerCase() == 'pending_confirmation',
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Booking Management'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => BookingWorkflowCubit(),
        child: Column(
          children: [
            // Batch action controls
            if (selectedBookingIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    Text('${selectedBookingIds.length} selected'),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _performBatchApproval(context),
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: const Text('Approve All'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _performBatchRejection(context),
                      icon: const Icon(Icons.cancel, size: 16),
                      label: const Text('Reject All'),
                    ),
                  ],
                ),
              ),

            // Booking list with selection
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingBookings.length,
                itemBuilder: (context, index) {
                  final booking = pendingBookings[index];
                  final bookingId = booking.id ?? '';
                  final isSelected = selectedBookingIds.contains(bookingId);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedBookingIds.add(bookingId);
                          } else {
                            selectedBookingIds.remove(bookingId);
                          }
                        });
                      },
                      title: Text(booking.parkingSpace?.name ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer: ${booking.renter?.name ?? 'Unknown'}',
                          ),
                          Text('Amount: ₹${booking.pricing?.finalAmount ?? 0}'),
                        ],
                      ),
                      secondary: BookingActionButtonWidget(
                        booking: booking,
                        currentUserRole: UserRole.owner,
                        onActionCompleted: () {
                          // Remove from selection when individual action is taken
                          setState(() {
                            selectedBookingIds.remove(bookingId);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performBatchApproval(BuildContext context) async {
    final cubit = context.read<BookingWorkflowCubit>();
    await cubit.batchApproveBookings(selectedBookingIds.toList());

    setState(() {
      selectedBookingIds.clear();
    });
  }

  Future<void> _performBatchRejection(BuildContext context) async {
    final cubit = context.read<BookingWorkflowCubit>();
    await cubit.batchRejectBookings(selectedBookingIds.toList());

    setState(() {
      selectedBookingIds.clear();
    });
  }
}
