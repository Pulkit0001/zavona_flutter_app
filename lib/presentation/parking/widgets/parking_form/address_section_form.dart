import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/pages/select_location_page.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class AddressSectionForm extends StatefulWidget {
  const AddressSectionForm({super.key});

  @override
  State<AddressSectionForm> createState() => _AddressSectionFormState();
}

class _AddressSectionFormState extends State<AddressSectionForm> {
  final selectLocationCubit = SelectLocationCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationService.getCurrentLocation(context).then((location) {
        if (location != null) {
          selectLocationCubit.setSelectedLocation(location);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParkingFormCubit, ParkingFormState>(
      listener: (context, state) {
        if (state.locationDTO != null) {
          selectLocationCubit.setSelectedLocation(state.locationDTO!);
        }
      },
      child: Column(
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
            controller: context
                .read<ParkingFormCubit>()
                .parkingNumberController,
            onInputActionPressed: () {},
            focusNode: context.read<ParkingFormCubit>().parkingNumberFocusNode,
            leadingAsset: CustomIcons.parkingIcon(20, 20),
            label: "Parking Number",
            hint: "Please specify the parking number",
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: context.read<ParkingFormCubit>().societyNameController,
            onInputActionPressed: () {},
            focusNode: context.read<ParkingFormCubit>().societyNameFocusNode,
            leadingAsset: CustomIcons.societyIcon(20, 20),
            label: "Society Name",
            hint: "Please enter the society name",
          ),
          SizedBox(height: 20),
          CustomTextField(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: selectLocationCubit,
                    child: SelectLocationPage(),
                  ),
                ),
              );
              selectLocationCubit.state.selectedLocation != null
                  ? context.read<ParkingFormCubit>().setLocationDTO(
                      selectLocationCubit.state.selectedLocation!,
                    )
                  : null;
            },
            controller: context.read<ParkingFormCubit>().addressController,
            onInputActionPressed: () {},
            leadingAsset: CustomIcons.locationIcon(20, 20),
            focusNode: context.read<ParkingFormCubit>().addressFocusNode,
            label: "Address",
            hint: "Please specify the location/address of parking",
          ),
        ],
      ),
    );
  }
}
