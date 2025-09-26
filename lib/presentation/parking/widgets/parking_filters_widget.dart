import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';

class ParkingFiltersWidget extends StatefulWidget {
  const ParkingFiltersWidget._({this.onApplyFilters, this.initialFilters});

  final void Function(List<ParkingFilterOption>)? onApplyFilters;
  final List<ParkingFilterOption>? initialFilters;

  static Future<void> show(
    BuildContext context, {
    void Function(List<ParkingFilterOption>)? onApplyFilters,
    List<ParkingFilterOption>? initialFilters,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ParkingFiltersWidget._(
          onApplyFilters: onApplyFilters,
          initialFilters: initialFilters,
        );
      },
    );
  }

  @override
  State<ParkingFiltersWidget> createState() => _ParkingFiltersWidgetState();
}

class _ParkingFiltersWidgetState extends State<ParkingFiltersWidget> {
  ParkingFilterCategory _selectedCategory = ParkingFilterCategory.distance;
  List<ParkingFilterOption> _selectedFilters = [];

  @override
  void initState() {
    _selectedFilters = widget.initialFilters ?? [];
    super.initState();
  }

  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _optionsScrollController = ScrollController();

  void onFilterChanged(ParkingFilterOption option) {
    var newFilters;
    var selected = !_selectedFilters.any((o) => o.code == option.code);
    if (selected) {
      if (option.category.allowMultipleSelection) {
        newFilters = [..._selectedFilters, option];
      } else {
        newFilters = [
          ..._selectedFilters.where((o) => o.category != option.category),
          option,
        ];
      }
    } else {
      newFilters = _selectedFilters
          .where((o) => o.code != option.code)
          .toList(growable: false);
    }
    setState(() {
      _selectedFilters = newFilters;
    });
  }

  void clearFilters() {
    setState(() {
      _selectedFilters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: context.onSurfaceColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters & Sort',
                      style: GoogleFonts.workSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: context.onSurfaceColor,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                          color: context.onSurfaceColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add filter options here
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: context.onSurfaceColor,
              ),
              _buildFilterOptions(context),
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: context.onSurfaceColor,
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.onApplyFilters?.call([]);
                        },
                        child: Text(
                          'Clear Filters',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: context.onSurfaceColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Apply Filters',
                        onPressed: () {
                          widget.onApplyFilters?.call(_selectedFilters);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.0),
            ],
          ),
        ),
      ],
    );
  }

  Expanded _buildFilterOptions(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Categories
          SizedBox(
            width: 72,
            child: SingleChildScrollView(
              controller: _categoryScrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  ...ParkingFilterCategory.values.map((category) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        // Scroll to the selected category in options
                        _optionsScrollController.jumpTo(
                          _categoryScrollController.position.pixels,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    category.icon,
                                    color: context.onSurfaceColor,
                                    size: 16,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    category.displayName,
                                    style: GoogleFonts.workSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: context.onSurfaceColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedCategory == category)
                              Container(
                                width: 4.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: context.onSurfaceColor,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(12.0),
                                  ),
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
          VerticalDivider(
            width: 0.5,
            thickness: 0.5,
            color: context.onSurfaceColor,
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              controller: _optionsScrollController,
              child: Column(
                children: [
                  ...ParkingFilterCategory.values.map((category) {
                    return Container(
                      key: ValueKey(category),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.primaryColor,
                          width: 0.5,
                        ),
                        color: Color(0xfffffff8),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              category.displayName,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.workSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: context.onSurfaceColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              children: [
                                ...createChunks<ParkingFilterOption>(
                                  category.filterOptions,
                                  3,
                                ).map(
                                  (sublitst) => IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        ...sublitst.map((option) {
                                          return _buildFilterOptionTile(
                                            option,
                                            context,
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.0),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Add more filter options as needed
        ],
      ),
    );
  }

  Expanded _buildFilterOptionTile(
    ParkingFilterOption option,
    BuildContext context,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onFilterChanged(option);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedFilters.any((o) => o.code == option.code) == true
                  ? context.onSurfaceColor
                  : context.primaryColor,
              width: 0.5,
            ),
            color: _selectedFilters.any((o) => o.code == option.code) == true
                ? context.primaryColor.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(option.icon, color: context.onSurfaceColor, size: 14),
              SizedBox(height: 4.0),
              Text(
                option.displayName,
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: context.onSurfaceColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<List<T>> createChunks<T>(List<T> list, int chunkSize) {
    List<T> originalList = list;
    List<List<T>> sublists = [];

    for (int i = 0; i < originalList.length; i += chunkSize) {
      int end = (i + chunkSize < originalList.length)
          ? (i + chunkSize)
          : originalList.length;
      sublists.add(originalList.sublist(i, end));
    }
    return sublists;
  }
}

enum ParkingFilterCategory {
  distance,
  price,
  availability,
  rating,
  amenities;

  String get displayName {
    switch (this) {
      case ParkingFilterCategory.distance:
        return 'Distance';
      case ParkingFilterCategory.price:
        return 'Price';
      case ParkingFilterCategory.availability:
        return 'Availability';
      case ParkingFilterCategory.rating:
        return 'Rating';
      case ParkingFilterCategory.amenities:
        return 'Amenities';
    }
  }

  bool get allowMultipleSelection {
    switch (this) {
      case ParkingFilterCategory.distance:
      case ParkingFilterCategory.price:
      case ParkingFilterCategory.availability:
      case ParkingFilterCategory.rating:
        return false;
      case ParkingFilterCategory.amenities:
        return true;
    }
  }

  IconData get icon {
    switch (this) {
      case ParkingFilterCategory.distance:
        return FontAwesomeIcons.locationDot;
      case ParkingFilterCategory.price:
        return FontAwesomeIcons.dollarSign;
      case ParkingFilterCategory.availability:
        return FontAwesomeIcons.clock;
      case ParkingFilterCategory.rating:
        return FontAwesomeIcons.star;
      case ParkingFilterCategory.amenities:
        return FontAwesomeIcons.wifi;
    }
  }

  List<ParkingFilterOption> get filterOptions {
    switch (this) {
      case ParkingFilterCategory.distance:
        return [
          ParkingFilterOption(
            ParkingFilter.underShortDistance.displayName,
            ParkingFilter.underShortDistance.icon,
            ParkingFilter.underShortDistance.name,
            ParkingFilterCategory.distance,
          ),
          ParkingFilterOption(
            ParkingFilter.underMidDistance.displayName,
            ParkingFilter.underMidDistance.icon,
            ParkingFilter.underMidDistance.name,
            ParkingFilterCategory.distance,
          ),
          ParkingFilterOption(
            ParkingFilter.underLongDistance.displayName,
            ParkingFilter.underLongDistance.icon,
            ParkingFilter.underLongDistance.name,
            ParkingFilterCategory.distance,
          ),
        ];
      case ParkingFilterCategory.price:
        return [
          ParkingFilterOption(
            ParkingFilter.cheapestPricePerHour.displayName,
            ParkingFilter.cheapestPricePerHour.icon,
            ParkingFilter.cheapestPricePerHour.name,
            ParkingFilterCategory.price,
          ),
          ParkingFilterOption(
            ParkingFilter.mindPricePerHour.displayName,
            ParkingFilter.mindPricePerHour.icon,
            ParkingFilter.mindPricePerHour.name,
            ParkingFilterCategory.price,
          ),
          ParkingFilterOption(
            ParkingFilter.premiumPricePerHour.displayName,
            ParkingFilter.premiumPricePerHour.icon,
            ParkingFilter.premiumPricePerHour.name,
            ParkingFilterCategory.price,
          ),
          ParkingFilterOption(
            ParkingFilter.cheapestPricePerDay.displayName,
            ParkingFilter.cheapestPricePerDay.icon,
            ParkingFilter.cheapestPricePerDay.name,
            ParkingFilterCategory.price,
          ),
          ParkingFilterOption(
            ParkingFilter.mindPricePerDay.displayName,
            ParkingFilter.mindPricePerDay.icon,
            ParkingFilter.mindPricePerDay.name,
            ParkingFilterCategory.price,
          ),
          ParkingFilterOption(
            ParkingFilter.premiumPricePerDay.displayName,
            ParkingFilter.premiumPricePerDay.icon,
            ParkingFilter.premiumPricePerDay.name,
            ParkingFilterCategory.price,
          ),
        ];
      case ParkingFilterCategory.availability:
        return [
          ParkingFilterOption(
            ParkingFilter.availableToSell.displayName,
            ParkingFilter.availableToSell.icon,
            ParkingFilter.availableToSell.name,
            ParkingFilterCategory.availability,
          ),
          ParkingFilterOption(
            ParkingFilter.availableToRent.displayName,
            ParkingFilter.availableToRent.icon,
            ParkingFilter.availableToRent.name,
            ParkingFilterCategory.availability,
          ),
        ];
      case ParkingFilterCategory.rating:
        return [
          ParkingFilterOption(
            ParkingFilter.rating3StarAndUp.displayName,
            ParkingFilter.rating3StarAndUp.icon,
            ParkingFilter.rating3StarAndUp.name,
            ParkingFilterCategory.rating,
          ),
          ParkingFilterOption(
            ParkingFilter.rating4StarAndUp.displayName,
            ParkingFilter.rating4StarAndUp.icon,
            ParkingFilter.rating4StarAndUp.name,
            ParkingFilterCategory.rating,
          ),
          ParkingFilterOption(
            ParkingFilter.rating5Star.displayName,
            ParkingFilter.rating5Star.icon,
            ParkingFilter.rating5Star.name,
            ParkingFilterCategory.rating,
          ),
        ];
      case ParkingFilterCategory.amenities:
        return [
          ...ParkingAmenities.values.map(
            (amenity) => ParkingFilterOption(
              amenity.displayName,
              amenity.icon,
              amenity.name,
              ParkingFilterCategory.amenities,
            ),
          ),
        ];
    }
  }
}

class ParkingFilterOption {
  final String displayName;
  final IconData icon;
  final String code;
  final ParkingFilterCategory category;

  ParkingFilterOption(this.displayName, this.icon, this.code, this.category);
}

enum ParkingFilter {
  underShortDistance,
  underMidDistance,
  underLongDistance,
  cheapestPricePerHour,
  mindPricePerHour,
  premiumPricePerHour,
  cheapestPricePerDay,
  mindPricePerDay,
  premiumPricePerDay,
  availableToSell,
  availableToRent,
  rating3StarAndUp,
  rating4StarAndUp,
  rating5Star;

  String get displayName {
    switch (this) {
      case ParkingFilter.underShortDistance:
        return 'Under 1 km';
      case ParkingFilter.underMidDistance:
        return 'Under 5 km';
      case ParkingFilter.underLongDistance:
        return 'Under 10 km';
      case ParkingFilter.cheapestPricePerHour:
        return 'Under \u20b910/Hour';
      case ParkingFilter.mindPricePerHour:
        return 'Under \u20b925/Hour';
      case ParkingFilter.premiumPricePerHour:
        return 'Under \u20b950/Hour';
      case ParkingFilter.cheapestPricePerDay:
        return 'Under \u20b9100/Day';
      case ParkingFilter.mindPricePerDay:
        return 'Under \u20b9250/Day';
      case ParkingFilter.premiumPricePerDay:
        return 'Under \u20b9500/Day';
      case ParkingFilter.availableToSell:
        return 'Available to Sell';
      case ParkingFilter.availableToRent:
        return 'Available to Rent';
      case ParkingFilter.rating3StarAndUp:
        return '3 Stars+';
      case ParkingFilter.rating4StarAndUp:
        return '4 Stars+';
      case ParkingFilter.rating5Star:
        return '5 Stars';
    }
  }

  IconData get icon {
    switch (this) {
      case ParkingFilter.underShortDistance:
      case ParkingFilter.underMidDistance:
      case ParkingFilter.underLongDistance:
        return FontAwesomeIcons.locationDot;
      case ParkingFilter.cheapestPricePerHour:
      case ParkingFilter.mindPricePerHour:
      case ParkingFilter.premiumPricePerHour:
      case ParkingFilter.cheapestPricePerDay:
      case ParkingFilter.mindPricePerDay:
      case ParkingFilter.premiumPricePerDay:
        return FontAwesomeIcons.dollarSign;
      case ParkingFilter.availableToSell:
      case ParkingFilter.availableToRent:
        return FontAwesomeIcons.clock;
      case ParkingFilter.rating3StarAndUp:
      case ParkingFilter.rating4StarAndUp:
      case ParkingFilter.rating5Star:
        return FontAwesomeIcons.star;
    }
  }
}

enum ParkingAmenities {
  evCharging,
  coveredParking,
  security,
  wheelchairAccessible,
  lighting,
  surveillanceCameras,
  gatedAccess,
  anyTimeAccess,
  onSiteStaff;

  String get displayName {
    switch (this) {
      case ParkingAmenities.evCharging:
        return 'EV Charging';
      case ParkingAmenities.coveredParking:
        return 'Covered Parking';
      case ParkingAmenities.security:
        return 'Security';
      case ParkingAmenities.wheelchairAccessible:
        return 'Wheelchair Accessible';
      case ParkingAmenities.lighting:
        return 'Lighting';
      case ParkingAmenities.surveillanceCameras:
        return 'Surveillance Cameras';
      case ParkingAmenities.gatedAccess:
        return 'Gated Access';
      case ParkingAmenities.anyTimeAccess:
        return '24/7 Access';
      case ParkingAmenities.onSiteStaff:
        return 'On-site Staff';
    }
  }

  IconData get icon {
    switch (this) {
      case ParkingAmenities.evCharging:
        return FontAwesomeIcons.bolt;
      case ParkingAmenities.coveredParking:
        return FontAwesomeIcons.car;
      case ParkingAmenities.security:
        return FontAwesomeIcons.shieldHalved;
      case ParkingAmenities.wheelchairAccessible:
        return FontAwesomeIcons.wheelchair;
      case ParkingAmenities.lighting:
        return FontAwesomeIcons.lightbulb;
      case ParkingAmenities.surveillanceCameras:
        return FontAwesomeIcons.video;
      case ParkingAmenities.gatedAccess:
        return FontAwesomeIcons.lock;
      case ParkingAmenities.anyTimeAccess:
        return FontAwesomeIcons.clock;
      case ParkingAmenities.onSiteStaff:
        return FontAwesomeIcons.userShield;
    }
  }
}
