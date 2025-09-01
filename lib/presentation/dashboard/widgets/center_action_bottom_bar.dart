import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class CenterActionBottomNavBar extends StatelessWidget {
  const CenterActionBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.icons,
    required this.labels,
    this.showCentreAction = false,
  }) : super(key: key);

  final int selectedIndex;
  final bool showCentreAction;
  final dynamic Function(int) onTap;
  final List<IconData> icons;
  final List<String> labels;
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      shadow: Shadow(
        color: Colors.black.withOpacity(0.25),
        offset: Offset(0, 0),
        blurRadius: 6,
      ),
      activeIndex: selectedIndex, //_selectedIndex,
      gapLocation: showCentreAction ? GapLocation.center : GapLocation.none,
      notchSmoothness: NotchSmoothness.sharpEdge,
      leftCornerRadius: 24,
      rightCornerRadius: 24,
      onTap: onTap, //_onItemTapped,
      backgroundColor: Color(0xfffffff8),
      itemCount: icons.length,
      tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[index],
              color: isActive
                  ? AppColors.secondaryDarkBlue
                  : AppColors.secondaryLightBlue,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                color: isActive
                    ? AppColors.secondaryDarkBlue
                    : AppColors.secondaryLightBlue,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        );
      },
      //other params
    );
  }
}
