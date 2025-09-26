import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_toggle_bar.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_filters_widget.dart';
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
              controller: context.read<ParkingFormCubit>().dailyRentController,
              onInputActionPressed: () {},
              focusNode: context.read<ParkingFormCubit>().dailyRentFocusNode,
              leadingAsset: CustomIcons.rentIcon(20, 20),
              label: "Daily Rent",
              hint: "Add Rent Price Per Day",
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: context.read<ParkingFormCubit>().hourlyRentController,
              onInputActionPressed: () {},
              focusNode: context.read<ParkingFormCubit>().hourlyRentFocusNode,
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
              controller: context
                  .read<ParkingFormCubit>()
                  .sellingPriceController,
              onInputActionPressed: () {},
              leadingAsset: CustomIcons.sellIcon(20, 20),
              focusNode: context.read<ParkingFormCubit>().sellingPriceFocusNode,
              label: "Selling Price",
              hint: "Add Selling Price",
            ),
            SizedBox(height: 24),
            Text(
              "Amenities",
              style: GoogleFonts.workSans(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: context.onSurfaceColor,
              ),
            ),
            Text(
              "What extra amenities does your parking spot offer?",
              style: GoogleFonts.workSans(
                fontSize: 13,
                height: 1.3,
                fontWeight: FontWeight.w400,
                color: context.onSurfaceColor,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              children: [
                ...ParkingAmenities.values
                    .map(
                      (amenity) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          checkmarkColor: context.onPrimaryColor,
                          label: Text(
                            amenity.displayName,
                            style: GoogleFonts.workSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: state.selectedAmenities.contains(amenity)
                                  ? context.onSurfaceColor
                                  : context.onSurfaceColor,
                            ),
                          ),
                          selected: state.selectedAmenities.contains(amenity),
                          onSelected: (isSelected) {
                            context
                                .read<ParkingFormCubit>()
                                .toggleAmenitySelection(amenity);
                          },
                          selectedColor: context.primaryColor,
                          backgroundColor: Color(0xfffffff8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: state.selectedAmenities.contains(amenity)
                                  ? AppColors.secondaryDarkBlue
                                  : context.onSurfaceColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ],
        );
      },
    );
  }
}
