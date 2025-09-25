import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/size_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/core/router/route_names.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_details_response.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_form/booking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/booking_form/booking_form_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';

class CreateBookingsPage extends StatefulWidget {
  const CreateBookingsPage({
    super.key,
    required this.parkingSpaceId,
    required this.parkingSpotId,
  });

  final String parkingSpaceId;
  final String parkingSpotId;

  @override
  State<CreateBookingsPage> createState() => _CreateBookingsPageState();
}

class _CreateBookingsPageState extends State<CreateBookingsPage> {
  bool _summaryExpanded = true;

  Future<void> _selectTime(
    TextEditingController controller,
    String helpText,
    SelectionType selectionType,
  ) async {
    var cubit = context.read<BookingFormCubit>();
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      helpText: helpText,
      initialTime: TimeOfDay.fromDateTime(
        cubit.state.checkInDateTime ?? DateTime.now(),
      ),
      initialEntryMode: TimePickerEntryMode.dial,

      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Offstage(),
        );
      },
    );
    if (picked != null) {
      if (selectionType == SelectionType.checkIn) {
        var currentSelectedDateTime = cubit.state.checkInDateTime;
        var mergedDateTime = mergeInDateAndTime(
          currentSelectedDateTime,
          null,
          picked,
        );
        if (mergedDateTime != null) {
          cubit.updateCheckInDateTime(mergedDateTime);
        }
      } else {
        var currentSelectedDateTime = cubit.state.checkOutDateTime;
        var mergedDateTime = mergeInDateAndTime(
          currentSelectedDateTime,
          null,
          picked,
        );
        if (mergedDateTime != null) {
          cubit.updateCheckOutDateTime(mergedDateTime);
        }
      }
      controller.text = localizations.formatTimeOfDay(
        picked,
        alwaysUse24HourFormat: false,
      );
    }
  }

  Future<void> _selectDate(
    TextEditingController controller,
    String helpText,
    SelectionType selectionType,
  ) async {
    var cubit = context.read<BookingFormCubit>();
    final DateTime? picked = await showDatePicker(
      context: context,
      helpText: helpText,
      initialDate:
          context.read<BookingFormCubit>().state.checkInDateTime ??
          DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      if (selectionType == SelectionType.checkIn) {
        var currentSelectedDateTime = cubit.state.checkInDateTime;
        var mergedDateTime = mergeInDateAndTime(
          currentSelectedDateTime,
          picked,
          null,
        );
        if (mergedDateTime != null) {
          cubit.updateCheckInDateTime(mergedDateTime);
        }
      } else {
        var currentSelectedDateTime = cubit.state.checkOutDateTime;
        var mergedDateTime = mergeInDateAndTime(
          currentSelectedDateTime,
          picked,
          null,
        );
        if (mergedDateTime != null) {
          cubit.updateCheckOutDateTime(mergedDateTime);
        }
      }
      setState(() {
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  Widget _buildPriceInfo(ParkingSpot? spot) {
    if (spot == null) {
      return Text(
        'Price not available',
        style: GoogleFonts.workSans(
          fontSize: 12,
          color: context.onPrimaryColor,
        ),
      );
    }

    List<String> priceTexts = [];

    if (spot.availableToRent == true) {
      if (spot.rentPricePerHour != null) {
        priceTexts.add('₹${spot.rentPricePerHour}/hr');
      }
      if (spot.rentPricePerDay != null) {
        priceTexts.add('₹${spot.rentPricePerDay}/day');
      }
    }

    // if (spot.availableToSell == true && spot.sellingPrice != null) {
    //   priceTexts.add('₹${spot.sellingPrice} (Sale)');
    // }

    return priceTexts.isNotEmpty
        ? Text(
            priceTexts.join(' • '),
            textAlign: TextAlign.end,
            style: GoogleFonts.workSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.onSurfaceColor,
            ),
          )
        : Offstage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingFormCubit, BookingFormState>(
      listener: (context, state) {
        if (state.formState == EFormState.submittingSuccess) {
          context.pop();
          context.pushNamed(RouteNames.myBookings);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Parking spot image and info
                      Container(
                        width: double.infinity,
                        height: context.screenHeight * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              "${NetworkConstants.bucketBaseUrl}/${state.parkingSpace?.thumbnailUrl}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Back button
                            Positioned(
                              top: 16,
                              left: 16,
                              child: SafeArea(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.arrowLeftLong,
                                        size: 24,
                                        color: AppColors.secondaryDarkBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      // Parking details section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Status and availability
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          state.parkingSpace?.name ?? "",
                                          style: GoogleFonts.workSans(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                            color: context.onSurfaceColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      CustomIcons.verifiedGreenIcon(20, 20),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                      colors: [
                                        Color(0xffFFD700),
                                        Color(0xffFFC107),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.workSans(
                                        color: AppColors.secondaryDarkBlue,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(text: "Available For "),
                                        if (state
                                                .parkingSpot
                                                ?.availableToRent ??
                                            false)
                                          TextSpan(
                                            text: "Rent",
                                            style: GoogleFonts.workSans(
                                              color:
                                                  AppColors.secondaryDarkBlue,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        if (state
                                                .parkingSpot
                                                ?.availableToSell ??
                                            false) ...[
                                          TextSpan(text: ", "),

                                          TextSpan(
                                            text: "Sale",
                                            style: GoogleFonts.workSans(
                                              color:
                                                  AppColors.secondaryDarkBlue,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            // Location and rating
                            Row(
                              children: [
                                CustomIcons.locationIcon(16, 16),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    state.parkingSpace?.address ?? "",
                                    style: GoogleFonts.workSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryDarkBlue,
                                    ),
                                  ),
                                ),
                                // Star rating
                                Row(
                                  children:
                                      List.generate(
                                        4,
                                        (index) => Icon(
                                          Icons.star,
                                          color: AppColors.primaryYellow,
                                          size: 14,
                                        ),
                                      ) +
                                      [
                                        Icon(
                                          Icons.star_border,
                                          color: AppColors.primaryYellow,
                                          size: 14,
                                        ),
                                      ],
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            // Suitable for text and price
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Suitable for ${state.parkingSpot?.parkingSize?.join(", ") ?? ""}",
                                    style: GoogleFonts.workSans(
                                      fontSize: 12,
                                      color: Color(0xff525B6A),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: _buildPriceInfo(state.parkingSpot),
                                ),
                              ],
                            ),

                            SizedBox(height: 24),

                            // Check-In Time
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: context
                                        .read<BookingFormCubit>()
                                        .checkInDateController,
                                    onInputActionPressed: () {},
                                    focusNode: context
                                        .read<BookingFormCubit>()
                                        .checkInDateFocusNode,
                                    leadingAsset: FaIcon(
                                      FontAwesomeIcons.arrowRightToBracket,
                                      color: AppColors.secondaryDarkBlue,
                                      size: 16,
                                    ),
                                    label: "Check-In Date",
                                    hint: "Select date",
                                    onTap: () => _selectDate(
                                      context
                                          .read<BookingFormCubit>()
                                          .checkInDateController,
                                      "Select check-in date for booking",
                                      SelectionType.checkIn,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: context
                                        .read<BookingFormCubit>()
                                        .checkInTimeController,
                                    onInputActionPressed: () {},
                                    focusNode: context
                                        .read<BookingFormCubit>()
                                        .checkInTimeFocusNode,
                                    leadingAsset: Icon(
                                      Icons.access_time,
                                      color: AppColors.secondaryDarkBlue,
                                      size: 20,
                                    ),
                                    label: "Check-In Time",
                                    hint: "Select time",
                                    onTap: () => _selectTime(
                                      context
                                          .read<BookingFormCubit>()
                                          .checkInTimeController,
                                      "Select check-in time for booking",
                                      SelectionType.checkIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            // Check-In Date
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: context
                                        .read<BookingFormCubit>()
                                        .checkOutDateController,
                                    onInputActionPressed: () {},
                                    focusNode: context
                                        .read<BookingFormCubit>()
                                        .checkOutDateFocusNode,
                                    leadingAsset: FaIcon(
                                      FontAwesomeIcons.arrowRightFromBracket,
                                      color: AppColors.secondaryDarkBlue,
                                      size: 16,
                                    ),
                                    label: "Check-Out Date",
                                    hint: "Select date",
                                    onTap: () => _selectDate(
                                      context
                                          .read<BookingFormCubit>()
                                          .checkOutDateController,
                                      "Select check-out date for booking",
                                      SelectionType.checkOut,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: context
                                        .read<BookingFormCubit>()
                                        .checkOutTimeController,
                                    onInputActionPressed: () {},
                                    focusNode: context
                                        .read<BookingFormCubit>()
                                        .checkOutTimeFocusNode,
                                    leadingAsset: Icon(
                                      Icons.access_time,
                                      color: AppColors.secondaryDarkBlue,
                                      size: 20,
                                    ),
                                    label: "Check-Out Time",
                                    hint: "Select time",
                                    onTap: () => _selectTime(
                                      context
                                          .read<BookingFormCubit>()
                                          .checkOutTimeController,
                                      "Select check-out time for booking",
                                      SelectionType.checkOut,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24),

                            // Summary section
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFF8),
                                border: Border.all(
                                  color: AppColors.primaryYellow.withOpacity(
                                    0.5,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  // Summary header
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _summaryExpanded = !_summaryExpanded;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Summary",
                                          style: GoogleFonts.workSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.secondaryDarkBlue,
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          _summaryExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: AppColors.secondaryDarkBlue,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (_summaryExpanded &&
                                      state.pricing != null) ...[
                                    SizedBox(height: 16),
                                    _buildSummaryRow(
                                      "Item Total",
                                      state.pricing?.rateType == RateType.daily
                                          ? "${state.pricing!.duration?.days.toString() ?? "0"} Days"
                                          : "${state.pricing!.duration?.hours.toString() ?? "0"} Hours",
                                    ),
                                    SizedBox(height: 8),
                                    _buildSummaryRow(
                                      "Base Price (${state.pricing?.duration?.days.toString() ?? "0"} × ₹${NumberFormat("##,##,###.00").format(state.pricing?.rate ?? 0)}/${state.pricing?.rateType == RateType.daily ? "day" : "hour"})",
                                      "₹${NumberFormat("##,##,###.00").format(state.pricing?.totalAmount ?? 0)}",
                                    ),
                                    // SizedBox(height: 8),
                                    // _buildSummaryRow(
                                    //   "Discount (10% Off)",
                                    //   "-₹${NumberFormat("##,##,###.00").format(state.pricing?.finalAmount ?? 0 * 0.1)}",
                                    // ),
                                    SizedBox(height: 8),
                                    _buildSummaryRow(
                                      "Platform Fee (10%)",
                                      "₹${NumberFormat("##,##,###.00").format(state.pricing?.platformFee ?? 0)}",
                                    ),
                                    SizedBox(height: 8),
                                    _buildSummaryRow(
                                      "Subtotal",
                                      "₹${NumberFormat("##,##,###.00").format(state.pricing?.subTotal ?? 0)}",
                                    ),
                                    SizedBox(height: 8),
                                    _buildSummaryRow(
                                      "GST (18%)",
                                      "₹${NumberFormat("##,##,###.00").format(state.pricing?.gstAmount ?? 0)}",
                                    ),
                                    SizedBox(height: 12),
                                    Divider(
                                      color: AppColors.secondaryDarkBlue
                                          .withOpacity(0.3),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          "Grand Total",
                                          style: GoogleFonts.workSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.secondaryDarkBlue,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "₹${NumberFormat("##,##,###.00").format(state.pricing?.finalAmount ?? 0)}",
                                          style: GoogleFonts.workSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.secondaryDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Book Now Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: PrimaryButton(
                  size: ButtonSize.large,
                  label: "Book Now",
                  onPressed: () {
                    context.read<BookingFormCubit>().createBooking(
                      context.read<AppCubit>().state.user?.id ?? "",
                    );
                  },
                  trailingIcon: CustomIcons.rightArrowIcon(16, 16),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.workSans(
            fontSize: 14,
            color: AppColors.secondaryDarkBlue,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryDarkBlue,
          ),
        ),
      ],
    );
  }

  /// Taking current selected DateTime one of the date or time will be applied.
  /// Only one of selectedDate and selectedTime will come as non-null
  DateTime? mergeInDateAndTime(
    DateTime? currentSelectedDateTime,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  ) {
    DateTime? mergedDateTime;

    if (currentSelectedDateTime != null) {
      if (selectedDate != null) {
        mergedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          currentSelectedDateTime.hour,
          currentSelectedDateTime.minute,
        );
      } else if (selectedTime != null) {
        mergedDateTime = DateTime(
          currentSelectedDateTime.year,
          currentSelectedDateTime.month,
          currentSelectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    } else if (selectedDate != null) {
      mergedDateTime = selectedDate;
    } else if (selectedTime != null) {
      mergedDateTime = DateTime(
        1970,
        1,
        1,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
    return mergedDateTime;
  }
}

enum SelectionType { checkIn, checkOut }
