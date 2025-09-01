import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class AddressSectionForm extends StatelessWidget {
  const AddressSectionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Location/Address",
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryDarkBlue,
          ),
        ),
        SizedBox(height: 14),
        CustomTextField(
          controller: TextEditingController(),
          onInputActionPressed: () {},
          focusNode: FocusNode(),
          leadingAsset: CustomIcons.parkingIcon(20, 20),
          label: "Parking Number",
          hint: "Please specify the parking number",
        ),
        SizedBox(height: 20),
        CustomTextField(
          controller: TextEditingController(),
          onInputActionPressed: () {},
          focusNode: FocusNode(),
          leadingAsset: CustomIcons.societyIcon(20, 20),
          label: "Society Name",
          hint: "Please enter the society name",
        ),
        SizedBox(height: 20),
        CustomTextField(
          controller: TextEditingController(),
          onInputActionPressed: () {},
          leadingAsset: CustomIcons.locationIcon(20, 20),
          focusNode: FocusNode(),
          label: "Address",
          hint: "Please specify the location/address of parking",
        ),
      ],
    );
  }
}
