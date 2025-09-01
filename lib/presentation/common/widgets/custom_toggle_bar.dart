import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';

/// A custom toggle bar widget with "NO" and "YES" options.
/// Calls [onToggle] with `true` for "YES" and `false` for "NO".
/// Initial value can be set with [initialValue].
/// Defaults to "YES".
///
/// Usage:
/// ```dart
/// CustomToggleBar(
///  initialValue: true, // or false
///  onToggle: (value) {
///  // Handle toggle change
///  },
///  )
/// ```
class CustomToggleBar extends StatefulWidget {
  const CustomToggleBar({
    super.key,
    required this.onToggle,
    this.initialValue = true,
  });

  final void Function(bool value) onToggle;
  final bool initialValue;
  @override
  State<CustomToggleBar> createState() => _CustomToggleBarState();
}

class _CustomToggleBarState extends State<CustomToggleBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 90,
      decoration: BoxDecoration(
        color: Color(0xfffffff8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.primaryColor, width: 1),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(32),
        child: TabBar(
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [Color(0xffFFD700), Color(0xffFFC107)],
            ),
          ),
          labelColor: context.onPrimaryColor,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: "NO"),
            Tab(text: "YES"),
          ],
          labelStyle: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.onPrimaryColor,
            height: 1.0,
          ),
          controller: TabController(
            length: 2,
            vsync: this,
            initialIndex: widget.initialValue ? 1 : 0,
          ),
          onTap: (index) {
            widget.onToggle(index == 1);
          },
        ),
      ),
    );
  }
}
