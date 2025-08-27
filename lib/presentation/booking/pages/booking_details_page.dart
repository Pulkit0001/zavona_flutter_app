import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    // Mock booking data
    final booking = {
      'id': bookingId,
      'parkingSpotTitle': 'Downtown Parking',
      'address': '123 Main Street, Downtown',
      'date': '25/08/2025',
      'startTime': '09:00 AM',
      'endTime': '05:00 PM',
      'duration': 8.0,
      'pricePerHour': 50.0,
      'totalPrice': 400.0,
      'status': 'Active',
      'bookingDate': '20/08/2025',
      'paymentStatus': 'Paid',
      'vehicleNumber': 'MH01AB1234',
      'contactNumber': '+91 9876543210',
      'notes': 'Need covered parking for the entire day',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking ${booking['status']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            'Booking ID: ${booking['id']}',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Parking Spot Details
            _buildDetailsCard('Parking Spot Details', [
              _DetailItem('Spot Name', booking['parkingSpotTitle'] as String),
              _DetailItem('Address', booking['address'] as String),
              _DetailItem('Type', 'Covered Parking'),
            ]),

            const SizedBox(height: 16),

            // Booking Details
            _buildDetailsCard('Booking Information', [
              _DetailItem('Date', booking['date'] as String),
              _DetailItem('Start Time', booking['startTime'] as String),
              _DetailItem('End Time', booking['endTime'] as String),
              _DetailItem('Duration', '${booking['duration']} hours'),
              _DetailItem('Booked On', booking['bookingDate'] as String),
            ]),

            const SizedBox(height: 16),

            // Vehicle Details
            _buildDetailsCard('Vehicle Information', [
              _DetailItem('Vehicle Number', booking['vehicleNumber'] as String),
              _DetailItem('Contact Number', booking['contactNumber'] as String),
              _DetailItem('Special Notes', booking['notes'] as String),
            ]),

            const SizedBox(height: 16),

            // Payment Details
            _buildDetailsCard('Payment Details', [
              _DetailItem('Price per Hour', '₹${booking['pricePerHour']}'),
              _DetailItem('Duration', '${booking['duration']} hours'),
              _DetailItem('Total Amount', '₹${booking['totalPrice']}'),
              _DetailItem('Payment Status', booking['paymentStatus'] as String),
              _DetailItem('Payment Method', 'UPI'),
            ]),

            const SizedBox(height: 24),

            // Action Buttons
            if (booking['status'] == 'Active') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _extendBooking(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Extend Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancelBooking(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    side: BorderSide(color: Colors.red.shade600),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Support
            Card(
              child: ListTile(
                leading: Icon(Icons.headset_mic, color: Colors.blue.shade600),
                title: const Text('Need Help?'),
                subtitle: const Text('Contact customer support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer support coming soon!'),
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

  Widget _buildDetailsCard(String title, List<_DetailItem> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.value,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _extendBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Extend Booking'),
          content: const Text(
            'This feature will allow you to extend your current booking.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Extend booking feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Extend'),
            ),
          ],
        );
      },
    );
  }

  void _cancelBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
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

class _DetailItem {
  final String label;
  final String value;

  _DetailItem(this.label, this.value);
}
