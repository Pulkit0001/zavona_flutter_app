import 'package:flutter/material.dart';

class BookingRequestsPage extends StatefulWidget {
  const BookingRequestsPage({super.key});

  @override
  State<BookingRequestsPage> createState() => _BookingRequestsPageState();
}

class _BookingRequestsPageState extends State<BookingRequestsPage>
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
        title: const Text('Booking Requests'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestsList(_pendingRequests),
          _buildRequestsList(_approvedRequests),
          _buildRequestsList(_rejectedRequests),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<_BookingRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.request_page, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No requests found',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Booking requests will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.person, color: Colors.blue.shade600),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.customerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            request.customerPhone,
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
                        color: _getStatusColor(request.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(request.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.parkingSpotTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${request.date.day}/${request.date.month}/${request.date.year}',
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
                            '${request.startTime} - ${request.endTime}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration: ${request.duration} hours',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${request.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (request.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Notes: ${request.notes}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (request.status == RequestStatus.pending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectRequest(request),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _approveRequest(request),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
    }
  }

  void _approveRequest(_BookingRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Approve Request'),
          content: Text(
            'Approve booking request from ${request.customerName}?',
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
                    content: Text('Booking request approved!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // TODO: Implement actual approval logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _rejectRequest(_BookingRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: Text('Reject booking request from ${request.customerName}?'),
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
                    content: Text('Booking request rejected'),
                    backgroundColor: Colors.red,
                  ),
                );
                // TODO: Implement actual rejection logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }
}

enum RequestStatus { pending, approved, rejected }

class _BookingRequest {
  final String id;
  final String customerName;
  final String customerPhone;
  final String parkingSpotTitle;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double duration;
  final double totalPrice;
  final String notes;
  final RequestStatus status;

  _BookingRequest({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.parkingSpotTitle,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalPrice,
    required this.notes,
    required this.status,
  });
}

final List<_BookingRequest> _pendingRequests = [
  _BookingRequest(
    id: '1',
    customerName: 'Rahul Sharma',
    customerPhone: '+91 9876543210',
    parkingSpotTitle: 'Downtown Parking',
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: '09:00 AM',
    endTime: '05:00 PM',
    duration: 8.0,
    totalPrice: 400.0,
    notes: 'Need covered parking for business meeting',
    status: RequestStatus.pending,
  ),
  _BookingRequest(
    id: '2',
    customerName: 'Priya Patel',
    customerPhone: '+91 9876543211',
    parkingSpotTitle: 'Mall Parking',
    date: DateTime.now().add(const Duration(days: 2)),
    startTime: '02:00 PM',
    endTime: '06:00 PM',
    duration: 4.0,
    totalPrice: 120.0,
    notes: 'Shopping with family',
    status: RequestStatus.pending,
  ),
];

final List<_BookingRequest> _approvedRequests = [
  _BookingRequest(
    id: '3',
    customerName: 'Amit Kumar',
    customerPhone: '+91 9876543212',
    parkingSpotTitle: 'Office Complex Parking',
    date: DateTime.now().add(const Duration(days: 3)),
    startTime: '08:00 AM',
    endTime: '06:00 PM',
    duration: 10.0,
    totalPrice: 400.0,
    notes: 'Regular office parking',
    status: RequestStatus.approved,
  ),
];

final List<_BookingRequest> _rejectedRequests = [
  _BookingRequest(
    id: '4',
    customerName: 'Sneha Singh',
    customerPhone: '+91 9876543213',
    parkingSpotTitle: 'Downtown Parking',
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: '07:00 PM',
    endTime: '11:00 PM',
    duration: 4.0,
    totalPrice: 200.0,
    notes: 'Evening event parking',
    status: RequestStatus.rejected,
  ),
];
