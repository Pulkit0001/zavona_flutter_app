import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/home/widgets/bookings_section.dart';
import 'package:zavona_flutter_app/presentation/home/widgets/parking_spots_section.dart';
import 'package:zavona_flutter_app/presentation/home/widgets/motivating_section.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hey Adam,",
                    style: GoogleFonts.workSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0.0,
                      color: AppColors.secondaryDarkBlue,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset(
                        "assets/vectors/location_vector.png",
                        height: 12,
                        width: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Mg Road, Street 129",
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: 0.0,
                          color: AppColors.secondaryDarkBlue,
                        ),
                      ),
                      SizedBox(width: 4),
                      // edit icon
                      InkWell(
                        onTap: () {
                          // context.pushNamed(RouteNames.locationPicker);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.pen,
                          size: 12,
                          color: AppColors.secondaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Stack(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidBell,
                    size: 24,
                    color: AppColors.secondaryDarkBlue,
                  ),
                  //red dot
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: true,
        showBackArrowIcon: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            BookingRequestSection(),
            SizedBox(height: 24),
            LatestParkingSpotsSection(),
            SizedBox(height: 24),
            MotivatingSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

















