import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/domain/models/bookings/booking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_state.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/bookings_list_widget.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class BookingRequestSection extends StatelessWidget {
  const BookingRequestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingListCubit>(
      create: (context) => BookingListCubit(),
      child: BlocBuilder<BookingListCubit, BookingListState>(
        builder: (context, state) {
          if (state.bookingList.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      Text(
                        "Booking Requests",
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: BookingListWidget(
                    scrollDirection: Axis.horizontal,
                    initialFilter: BookingListFilter(
                      owner: context.read<AppCubit>().state.user?.id,
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            );
          } else {
            return Offstage();
          }
        },
      ),
    );
  }
}
