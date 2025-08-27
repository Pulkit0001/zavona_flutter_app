import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(_activeBookings),
          _buildBookingsList(_completedBookings),
          _buildBookingsList(_cancelledBookings),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<_Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_online, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Your bookings will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.pushNamed(
              RouteNames.bookingDetails,
              pathParameters: {'bookingId': booking.id},
            ),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            booking.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_parking,
                          color: _getStatusColor(booking.status),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.parkingSpotTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.address,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            booking.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.status.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(booking.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.date.day}/${booking.date.month}/${booking.date.year}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.startTime} - ${booking.endTime}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Duration: ${booking.duration} hours',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${booking.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (booking.status == BookingStatus.active) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _cancelBooking(booking),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.pushNamed(
                              RouteNames.bookingDetails,
                              pathParameters: {'bookingId': booking.id},
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('View Details'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.active:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  void _cancelBooking(_Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: Text(
            'Are you sure you want to cancel this booking for "${booking.parkingSpotTitle}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Booking'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                // TODO: Implement actual cancellation logic
              },
              child: Text(
                'Cancel Booking',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum BookingStatus { active, completed, cancelled }

class _Booking {
  final String id;
  final String parkingSpotTitle;
  final String address;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double duration;
  final double totalPrice;
  final BookingStatus status;

  _Booking({
    required this.id,
    required this.parkingSpotTitle,
    required this.address,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalPrice,
    required this.status,
  });
}

final List<_Booking> _activeBookings = [
  _Booking(
    id: '1',
    parkingSpotTitle: 'Downtown Parking',
    address: '123 Main Street, Downtown',
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: '09:00 AM',
    endTime: '05:00 PM',
    duration: 8.0,
    totalPrice: 400.0,
    status: BookingStatus.active,
  ),
  _Booking(
    id: '2',
    parkingSpotTitle: 'Mall Parking',
    address: '456 Shopping Center, Mall Road',
    date: DateTime.now().add(const Duration(days: 3)),
    startTime: '02:00 PM',
    endTime: '06:00 PM',
    duration: 4.0,
    totalPrice: 120.0,
    status: BookingStatus.active,
  ),
];

final List<_Booking> _completedBookings = [
  _Booking(
    id: '3',
    parkingSpotTitle: 'Airport Parking',
    address: '789 Airport Road, Terminal 2',
    date: DateTime.now().subtract(const Duration(days: 5)),
    startTime: '06:00 AM',
    endTime: '10:00 PM',
    duration: 16.0,
    totalPrice: 960.0,
    status: BookingStatus.completed,
  ),
];

final List<_Booking> _cancelledBookings = [
  _Booking(
    id: '4',
    parkingSpotTitle: 'Hotel Parking',
    address: '321 Hotel District, City Center',
    date: DateTime.now().subtract(const Duration(days: 2)),
    startTime: '07:00 PM',
    endTime: '11:00 PM',
    duration: 4.0,
    totalPrice: 200.0,
    status: BookingStatus.cancelled,
  ),
];
