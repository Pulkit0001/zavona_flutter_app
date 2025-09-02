import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zavona_flutter_app/core/router/app_router.dart';
import 'package:zavona_flutter_app/presentation/dashboard/widgets/center_action_bottom_bar.dart';
import 'package:zavona_flutter_app/presentation/home/pages/home_page.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import '../../../core/router/route_names.dart';

class DashboardPage extends StatefulWidget {
  final Widget child;

  const DashboardPage({super.key, required this.child});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
        break;
      case 1:
        context.goNamed(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton:
          // Center Floating Action Button
          Padding(
            padding: EdgeInsets.all(0),
            child: FloatingActionButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              onPressed: () {
               context.goNamed(RouteNames.parkingCreate);
              },
              backgroundColor: Color(0xffFFD700),
              child: const Icon(Icons.add, color: AppColors.secondaryDarkBlue),
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CenterActionBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        icons: const [FontAwesomeIcons.house, FontAwesomeIcons.user],
        labels: ['Home', 'Profile'],
      ),
    );
  }
}
