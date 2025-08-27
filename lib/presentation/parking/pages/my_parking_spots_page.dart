import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';

class MyParkingSpotsPage extends StatelessWidget {
  const MyParkingSpotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Parking Spots'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(RouteNames.parkingCreate),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '3',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          const Text('Total Spots'),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '2',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                          const Text('Available'),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '1',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade600,
                            ),
                          ),
                          const Text('Occupied'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Parking Spots List
            Expanded(
              child: ListView.builder(
                itemCount: _mockParkingSpots.length,
                itemBuilder: (context, index) {
                  final spot = _mockParkingSpots[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: spot.isOccupied
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_parking,
                          color: spot.isOccupied
                              ? Colors.orange.shade600
                              : Colors.green.shade600,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        spot.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(spot.address),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '₹${spot.pricePerHour}/hr',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: spot.isOccupied
                                      ? Colors.orange.shade100
                                      : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  spot.isOccupied ? 'Occupied' : 'Available',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: spot.isOccupied
                                        ? Colors.orange.shade700
                                        : Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              context.pushNamed(
                                RouteNames.updateParkingSpace,
                                pathParameters: {'parkingSpaceId': spot.id},
                              );
                              break;
                            case 'requests':
                              context.pushNamed(RouteNames.bookingRequests);
                              break;
                            case 'delete':
                              _showDeleteDialog(context, spot.title);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'requests',
                            child: Row(
                              children: [
                                Icon(Icons.request_page, size: 20),
                                SizedBox(width: 8),
                                Text('View Requests'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.parkingCreate),
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String spotTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Parking Spot'),
          content: Text('Are you sure you want to delete "$spotTitle"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$spotTitle deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ParkingSpot {
  final String id;
  final String title;
  final String address;
  final double pricePerHour;
  final bool isOccupied;

  _ParkingSpot({
    required this.id,
    required this.title,
    required this.address,
    required this.pricePerHour,
    required this.isOccupied,
  });
}

final List<_ParkingSpot> _mockParkingSpots = [
  _ParkingSpot(
    id: '1',
    title: 'Downtown Parking',
    address: '123 Main Street, Downtown',
    pricePerHour: 50.0,
    isOccupied: true,
  ),
  _ParkingSpot(
    id: '2',
    title: 'Mall Parking',
    address: '456 Shopping Center, Mall Road',
    pricePerHour: 30.0,
    isOccupied: false,
  ),
  _ParkingSpot(
    id: '3',
    title: 'Office Complex Parking',
    address: '789 Business District, IT Park',
    pricePerHour: 40.0,
    isOccupied: false,
  ),
];
