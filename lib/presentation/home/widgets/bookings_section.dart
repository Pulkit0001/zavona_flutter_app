import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/bookings_list_widget.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class BookingRequestSection extends StatelessWidget {
  const BookingRequestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),

          child: Row(
            children: [
              Text(
                "Booking Requests",
                style: GoogleFonts.workSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: 0.0,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
              Spacer(),
              Text(
                "View All",
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0.0,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
              SizedBox(width: 6),
              Image.asset(
                "assets/vectors/right_arrow_icon.png",
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
          child: BookingRequestsListWidget(scrollDirection: Axis.horizontal),
        ),
      ],
    );
  }
}