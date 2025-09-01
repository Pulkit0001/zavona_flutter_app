import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.confirmationMessage});

  final String confirmationMessage;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Wrap(
        runAlignment: WrapAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        color: AppColors.secondaryDarkBlue,
                        size: 26,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    confirmationMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryDarkBlue,
                    ),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFD6),
                                border: Border.all(
                                  color: AppColors.secondaryDarkBlue,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Yes",
                                  style: GoogleFonts.mulish(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryDarkBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFD6),
                                border: Border.all(
                                  color: AppColors.secondaryDarkBlue,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "No",
                                  style: GoogleFonts.mulish(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryDarkBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
