import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/size_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';

class ParkingDocsSection extends StatelessWidget {
  const ParkingDocsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Parking Thumbnail",
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.3,
            color: context.onSurfaceColor,
          ),
        ),
        Text(
          "Upload a clear image of your parking space.",
          style: GoogleFonts.workSans(
            fontSize: 13,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: context.onSurfaceColor,
          ),
        ),
        SizedBox(height: 12),
        ImagePickerButton(onPressed: () {}),
        SizedBox(height: 24),
        Text(
          "Address Proof",
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.3,
            color: context.onSurfaceColor,
          ),
        ),
        Text(
          "Upload a clear image of your address proof.",
          style: GoogleFonts.workSans(
            fontSize: 13,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: context.onSurfaceColor,
          ),
        ),
        SizedBox(height: 12),
        ImagePickerButton(onPressed: () {}),
      ],
    );
  }
}

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: context.screenHeight * 0.15,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xfffffff8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.primaryColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 32,
              width: 32,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.primaryColor,
              ),
              child: CustomIcons.cameraIcon(20, 20),
            ),
            Text(
              "Upload",
              style: GoogleFonts.workSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.onSurfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
