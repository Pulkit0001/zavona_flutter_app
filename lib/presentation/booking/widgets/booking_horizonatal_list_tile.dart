import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class BookingRequestHorizontalTile extends StatelessWidget {
  const BookingRequestHorizontalTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(0, 1.4),
            blurRadius: 5,
          ),
        ],
        color: Color.fromARGB(255, 255, 255, 235),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 235, 185),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                clipBehavior: Clip.none,
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryYellowLight,
                  border: Border.all(
                    color: AppColors.secondaryDarkBlue,
                    width: 0.75,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Image.network(
                      "",
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/images/dummy_avatar.png",
                        width: 32,
                        height: 32,
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Image.asset(
                        "assets/vectors/verified_icon.png",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Muskan",
                style: GoogleFonts.mulish(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: 0.3,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Image.asset(
                "assets/vectors/location_vector.png",
                height: 12,
                width: 12,
              ),
              SizedBox(width: 4),
              Text(
                "Street 9, park lane",
                style: GoogleFonts.mulish(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.7,
                  letterSpacing: 0.3,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Flexible(
                child: Text(
                  "Sep 5 at 8:15 AM to Sep 12 at 9:15 AM",
                  style: GoogleFonts.workSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    letterSpacing: 0.0,
                    color: AppColors.secondaryDarkBlue,
                  ),
                ),
              ),
              SizedBox(width: 6),
              FaIcon(
                FontAwesomeIcons.arrowRight,
                size: 12,
                color: AppColors.secondaryDarkBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}