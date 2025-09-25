import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

enum ButtonSize {
  regular(48, 16),
  small(24, 10),
  medium(32, 12),
  large(56, 16);

  final double buttonHeight;
  final double buttonTextSize;

  const ButtonSize(this.buttonHeight, this.buttonTextSize);
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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
  final IconData? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.buttonHeight / 4),
        height: size.buttonHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [Color(0xffFFD700), Color(0xffFFC107)],
          ),
          borderRadius: BorderRadius.circular(size.buttonHeight / 4),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: context.onPrimaryColor),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(leadingIcon, color: Colors.white),
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
                    trailingIcon!
                  else
                    Image.asset(
                      "assets/vectors/right_arrow_icon.png",
                      width: size.buttonTextSize,
                      height: size.buttonTextSize,
                    ),
                ],
              ),
      ),
    );
  }
}
