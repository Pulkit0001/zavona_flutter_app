import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/confirmation_dailog.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import '../../../core/router/route_names.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 78,
                    width: 78,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.onSurfaceColor,
                        width: 0.5,
                      ),
                    ),
                    child: Image.asset('assets/images/dummy_avatar.png'),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      height: 24,
                      width: 24,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIcons.cameraIcon(20, 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Text(
                  'John Doe | john.doe@example.com | +91 9876543210',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.workSans(
                    fontSize: 16,
                    height: 1.5,
                    color: context.onSurfaceColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ProfileMenuItem(
                    label: 'My Parking Spots',
                    leadingIcon: CustomIcons.parkingIcon(),
                    onTap: () {},
                  ),
                  SizedBox(height: 14),
                  ProfileMenuItem(
                    label: 'My Bookings',
                    leadingIcon: CustomIcons.bookingsIcon(),
                    onTap: () {},
                  ),
                  SizedBox(height: 14),
                  ProfileMenuItem(
                    label: 'Booking Requests',
                    leadingIcon: CustomIcons.bookingRequestsIcon(),
                    onTap: () {},
                  ),
                  SizedBox(height: 14),
                  ProfileMenuItem(
                    label: 'Edit Profile',
                    leadingIcon: CustomIcons.editProfileIcon(),
                    onTap: () {},
                  ),
                  SizedBox(height: 14),
                  ProfileMenuItem(
                    label: 'Contact Us',
                    leadingIcon: CustomIcons.customerSupportIcon(),
                    onTap: () {},
                  ),
                  SizedBox(height: 14),
                  ProfileMenuItem(
                    label: 'Privacy Policy',
                    leadingIcon: CustomIcons.privacyPolicyIcon(),
                    onTap: () {},
                  ),
                  SizedBox(height: 14),
                  ProfileMenuItem(
                    label: 'Logout',
                    leadingIcon: CustomIcons.logoutIcon(),
                    onTap: () async {
                      var res = await showDialog(
                        context: context,
                        builder: (_) => ConfirmationDialog(
                          confirmationMessage:
                              "Are you sure you want to logout?",
                        ),
                      );
                      if (res ?? false) {
                        context.goNamed(RouteNames.mobileEmail);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.label,
    required this.leadingIcon,
    required this.onTap,
  });

  final String label;
  final Widget leadingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xfffffff8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: context.primaryColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            leadingIcon,
            SizedBox(width: 12),
            VerticalDivider(color: context.onSurfaceColor, width: 0.5),
            SizedBox(width: 12),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                label,
                style: GoogleFonts.workSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: context.onSurfaceColor,
                ),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.arrowRight,
              color: context.onSurfaceColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
