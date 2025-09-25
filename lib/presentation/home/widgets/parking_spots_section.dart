import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_state.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_list_widget.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class LatestParkingSpotsSection extends StatefulWidget {
  const LatestParkingSpotsSection({super.key});

  @override
  State<LatestParkingSpotsSection> createState() =>
      _LatestParkingSpotsSectionState();
}

class _LatestParkingSpotsSectionState extends State<LatestParkingSpotsSection> {
  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: [
              Text(
                "Latest Listed",
                style: GoogleFonts.workSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: 0.0,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
              Spacer(),
              Text(
                "View All",
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0.0,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
              SizedBox(width: 6),
              Image.asset(
                "assets/vectors/right_arrow_icon.png",
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
        SizedBox(height: 12),

        ParkingListWidget(
          shrinkWrap: true,
          showFilters: false,
          initialFilter: ParkingListFilter(
            longitude: context
                .read<SelectLocationCubit>()
                .state
                .selectedLocation
                ?.longitude,
            latitude: context
                .read<SelectLocationCubit>()
                .state
                .selectedLocation
                ?.latitude,
            maxDistance: '10000',
          ),
        ),
      ],
    );
  }
}
