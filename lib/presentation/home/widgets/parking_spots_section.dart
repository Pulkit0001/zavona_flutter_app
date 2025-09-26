import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_filters_widget.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_list_widget.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

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

        BlocBuilder<ParkingListCubit, ParkingListState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            ParkingFiltersWidget.show(
                              context,
                              onApplyFilters: (options) {
                                Navigator.of(context).pop();
                                context.read<ParkingListCubit>().applyFilters(
                                  options,
                                );
                              },
                              initialFilters: context
                                  .read<ParkingListCubit>()
                                  .state
                                  .selectedFilters,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xfffffff8),
                              border: Border.all(
                                color: context.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.sliders,
                                  size: 14,
                                  color: context.primaryColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(width: 8),
                                FaIcon(
                                  FontAwesomeIcons.pencil,
                                  size: 12,
                                  color: context.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Add more filter chips here if needed
                        ...state.selectedFilters.map((filter) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: context.primaryColor.withOpacity(0.1),
                                border: Border.all(
                                  color: context.primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    filter.icon,
                                    size: 12,
                                    color: context.onSurfaceColor,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    filter.displayName,
                                    style: GoogleFonts.workSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: context.onSurfaceColor,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  InkWell(
                                    onTap: () {
                                      var newFilters = List.of(
                                        context
                                            .read<ParkingListCubit>()
                                            .state
                                            .selectedFilters,
                                      );
                                      newFilters.removeWhere(
                                        (element) =>
                                            element.code == filter.code,
                                      );
                                      context
                                          .read<ParkingListCubit>()
                                          .applyFilters(newFilters);
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: 12,
                                      color: context.onSurfaceColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
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
          },
        ),
      ],
    );
  }
}
