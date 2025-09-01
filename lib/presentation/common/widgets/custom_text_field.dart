import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    required this.onInputActionPressed,
    required this.focusNode,
    this.leadingIcon,
    this.leadingAsset,
    required this.label,
    required this.hint,
  }) : assert(
         leadingIcon != null || leadingAsset != null,
         'Should provide either one of leadingIcon and leadingAsset',
       );

  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final VoidCallback onInputActionPressed;
  final FocusNode focusNode;
  final IconData? leadingIcon;
  final Widget? leadingAsset;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            label,
            textAlign: TextAlign.start,
            style: GoogleFonts.workSans(
              color: AppColors.secondaryDarkBlue,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(height: 4),
        // Input field
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xfffffff8),
            border: Border.all(color: AppColors.primaryYellow, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 28,
                child: Row(
                  children: [
                    if (leadingIcon != null)
                      Icon(
                        leadingIcon!,
                        color: AppColors.secondaryDarkBlue,
                        size: 24,
                      )
                    else if (leadingAsset != null)
                      leadingAsset!,
                    const SizedBox(width: 8),
                    VerticalDivider(
                      color: AppColors.secondaryDarkBlue,
                      width: 1,
                      thickness: 0.5,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  onSubmitted: (_) => onInputActionPressed,
                  controller: controller,
                  keyboardType: inputType,
                  textCapitalization: inputType == TextInputType.name
                      ? TextCapitalization.words
                      : TextCapitalization.none,
                  style: GoogleFonts.workSans(
                    color: AppColors.secondaryDarkBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    letterSpacing: 0,
                  ),
                  textInputAction: inputAction,
                  cursorColor: AppColors.secondaryDarkBlue,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    isDense: true,
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    constraints: BoxConstraints(maxHeight: 40),
                    fillColor: Colors.transparent,
                    hintText: hint,
                    hintStyle: GoogleFonts.workSans(
                      color: AppColors.secondaryDarkBlue,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
