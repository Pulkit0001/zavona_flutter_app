import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class MotivatingSection extends StatelessWidget {
  const MotivatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Start Today",
                style: GoogleFonts.mulish(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
              SizedBox(width: 4),
              Image.asset(
                "assets/vectors/green_leaf_vector.png",
                height: 24,
                width: 24,
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            "- Every space has value, make yours Count.",
            style: GoogleFonts.mulish(
              color: Color(0xff8C8C8C),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}