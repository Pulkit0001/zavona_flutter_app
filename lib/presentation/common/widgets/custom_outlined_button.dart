import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.onPressed,
    this.label,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.regular,
  });

  final VoidCallback? onPressed;
  final ButtonSize size;
  final String? label;
  final bool isLoading;
  final Widget? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.buttonHeight / 4),
        height: size.buttonHeight,
        decoration: BoxDecoration(
          color: Color(0xfffffff8),
          borderRadius: BorderRadius.circular(size.buttonHeight / 4),
          border: Border.all(color: AppColors.primaryYellow, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: leadingIcon,
              ),
            Flexible(
              child: Text(
                label ?? '',
                style: GoogleFonts.workSans(
                  fontSize: size.buttonTextSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 4),
            if (trailingIcon != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(trailingIcon, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
