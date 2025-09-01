import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_toggle_bar.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class PricingSectionForm extends StatelessWidget {
  const PricingSectionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingFormCubit, ParkingFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Want to Rent",
                  style: GoogleFonts.workSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryDarkBlue,
                  ),
                ),
                Spacer(),
                CustomToggleBar(
                  onToggle: context.read<ParkingFormCubit>().toggleRenOptIn,
                  initialValue: state.optToRent,
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: TextEditingController(),
              onInputActionPressed: () {},
              focusNode: FocusNode(),
              leadingAsset: CustomIcons.rentIcon(20, 20),
              label: "Daily Rent",
              hint: "Add Rent Price Per Day",
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: TextEditingController(),
              onInputActionPressed: () {},
              focusNode: FocusNode(),
              leadingAsset: CustomIcons.rentIcon(20, 20),
              label: "Hourly Rent",
              hint: "Add Rent Price Per Hour",
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Text(
                  "Want to Sell",
                  style: GoogleFonts.workSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryDarkBlue,
                  ),
                ),
                Spacer(),
                CustomToggleBar(
                  onToggle: context.read<ParkingFormCubit>().toggleSellOptIn,
                  initialValue: state.optToSell,
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: TextEditingController(),
              onInputActionPressed: () {},
              leadingAsset: CustomIcons.sellIcon(20, 20),
              focusNode: FocusNode(),
              label: "Selling Price",
              hint: "Add Selling Price",
            ),
          ],
        );
      },
    );
  }
}
