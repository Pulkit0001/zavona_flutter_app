import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.pushNamed(RouteNames.editProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+91 9876543210',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Menu Options
            _buildMenuSection(context, 'My Activity', [
              _MenuOption(
                'My Bookings',
                Icons.book_online,
                () => context.pushNamed(RouteNames.myBookings),
              ),
              _MenuOption(
                'My Parking Spots',
                Icons.local_parking,
                () => context.pushNamed(RouteNames.myParkingSpots),
              ),
              _MenuOption(
                'Booking Requests',
                Icons.request_page,
                () => context.pushNamed(RouteNames.bookingRequests),
              ),
            ]),

            const SizedBox(height: 16),

            _buildMenuSection(context, 'Account', [
              _MenuOption(
                'Edit Profile',
                Icons.edit,
                () => context.pushNamed(RouteNames.editProfile),
              ),
              _MenuOption(
                'Update Profile',
                Icons.update,
                () => context.pushNamed(RouteNames.updateProfile),
              ),
              _MenuOption('Notifications', Icons.notifications, () {
                // TODO: Implement notifications settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications settings coming soon!'),
                  ),
                );
              }),
            ]),

            const SizedBox(height: 16),

            _buildMenuSection(context, 'Support', [
              _MenuOption('Help & Support', Icons.help, () {
                // TODO: Implement help & support
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon!')),
                );
              }),
              _MenuOption('Terms & Conditions', Icons.description, () {
                // TODO: Implement terms & conditions
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms & Conditions coming soon!'),
                  ),
                );
              }),
              _MenuOption('Privacy Policy', Icons.privacy_tip, () {
                // TODO: Implement privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy Policy coming soon!')),
                );
              }),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<_MenuOption> options,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...options.map(
              (option) => ListTile(
                leading: Icon(option.icon, color: Colors.blue.shade600),
                title: Text(option.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: option.onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual logout logic
                context.goNamed(RouteNames.mobileEmail);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuOption {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _MenuOption(this.title, this.icon, this.onTap);
}
