import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class ParkingSpotTile extends StatelessWidget {
  const ParkingSpotTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                offset: Offset(0, 1.4),
                blurRadius: 5,
              ),
            ],
            color: Color(0XFFFFFFF8),
            border: Border.all(
              color: const Color(0xffFFD700).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/dummy_parking_image.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "D5-9005, Green",
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.workSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryDarkBlue,
                                ),
                              ),
                            ),
                            Image.asset(
                              "assets/vectors/verified_icon.png",
                              height: 16,
                              width: 16,
                            ),
                            Text(
                              "₹500",
                              style: GoogleFonts.workSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryDarkBlue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Image.asset(
                              "assets/vectors/location_vector.png",
                              height: 12,
                              width: 12,
                            ),
                            Flexible(
                              child: Text(
                                "Basement Slot 5, L-324-",
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.workSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Suitable for ',
                                    style: TextStyle(
                                      color: Color(0xff525B6A),
                                      fontFamily: 'Work Sans',
                                      fontSize: 12,
                                      letterSpacing:
                                      0.2 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'SEDAN',
                                    style: TextStyle(
                                      color: AppColors.secondaryDarkBlue,
                                      fontFamily: 'Work Sans',
                                      fontSize: 12,
                                      letterSpacing:
                                      0.2 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'For Rent, Sale',
                              style: TextStyle(
                                color: AppColors.secondaryDarkBlue,
                                fontFamily: 'Work Sans',
                                fontSize: 10,
                                letterSpacing:
                                0.15 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: 4),
                            //Ratings icons
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.primaryYellow,
                                  size: 10,
                                ),
                                Icon(
                                  Icons.star,
                                  color: AppColors.primaryYellow,
                                  size: 10,
                                ),
                                Icon(
                                  Icons.star,
                                  color: AppColors.primaryYellow,
                                  size: 10,
                                ),
                                Icon(
                                  Icons.star,
                                  color: AppColors.primaryYellow,
                                  size: 10,
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: AppColors.primaryYellow,
                                  size: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          height: 24,
          child: PrimaryButton(
            isLoading: false,
            label: "Book Now",
            size: ButtonSize.small,
          ),
        ),
      ],
    );
  }
}