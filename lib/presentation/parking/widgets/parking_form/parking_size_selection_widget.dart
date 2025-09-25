import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/size_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

enum ParkingSize {
  suv("SUV"),
  regular("Car"),
  sedan("Sedan"),
  twoWheeler("Two Wheeler");

  final String displayName;
  const ParkingSize(this.displayName);
}

class ParkingSizeSelection extends StatelessWidget {
  const ParkingSizeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingFormCubit, ParkingFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Parking Size",
              style: GoogleFonts.workSans(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1,
                color: AppColors.secondaryDarkBlue,
              ),
            ),
            Text(
              "Select all the sizes that your parking supports",
              style: GoogleFonts.workSans(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryDarkBlue,
              ),
            ),
            SizedBox(height: 12),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: ((context.screenWidth - 52) / 2) / 114,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => ParkingSizeTile(
                parkingSize: ParkingSize.values[index],
                isSelected: state.selectedSizes.contains(
                  ParkingSize.values[index],
                ),
                onTap: () {
                  context.read<ParkingFormCubit>().toggleSizeSelection(
                    ParkingSize.values[index],
                  );
                },
              ),
              itemCount: ParkingSize.values.length,
              shrinkWrap: true,
            ),
          ],
        );
      },
    );
  }
}

class ParkingSizeTile extends StatelessWidget {
  const ParkingSizeTile({
    super.key,
    required this.isSelected,
    required this.parkingSize,
    required this.onTap,
  });

  final bool isSelected;
  final ParkingSize parkingSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.primaryColor,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: switch (parkingSize) {
                ParkingSize.suv => CustomIcons.suvIcon(100, 100),
                ParkingSize.regular => CustomIcons.carIcon(100, 100),
                ParkingSize.sedan => CustomIcons.sedanIcon(100, 100),
                ParkingSize.twoWheeler => CustomIcons.twoWheelerIcon(72, 72),
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6, right: 10),
                child: Text(
                  parkingSize.displayName,
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.onSurfaceColor,
                  ),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  size: 20,
                  color: context.onPrimaryColor,
                ),
              )
            else ...[
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.circle_outlined,
                  size: 20,
                  color: context.onSurfaceColor.withOpacity(0.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
