import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/bookings/booking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_state.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/bookings_list_widget.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';

enum BookingsPageMode { owner, renter }

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key, this.mode = BookingsPageMode.renter});

  final BookingsPageMode mode;

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.mode == BookingsPageMode.owner
            ? 'Booking Requests'
            : 'My Bookings',
        bottomWidget: TabBar(
          controller: _tabController,
          indicatorColor: context.onPrimaryColor,
          labelColor: context.onPrimaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicatorWeight: 3,
          indicatorPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
          unselectedLabelColor: context.onPrimaryColor.withOpacity(0.7),
          labelStyle: GoogleFonts.mulish(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.mulish(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            BlocProvider(
              create: (context) => BookingListCubit(),
              child: BookingListWidget(
                shrinkWrap: true,
                showFilters: false,
                initialFilter: BookingListFilter(
                  owner: widget.mode == BookingsPageMode.owner
                      ? context.read<AppCubit>().state.user?.id
                      : null,
                  renter: widget.mode == BookingsPageMode.renter
                      ? context.read<AppCubit>().state.user?.id
                      : null,
                  status: [
                    BookingStatus.pendingConfirmation,
                    BookingStatus.confirmed,
                    BookingStatus.paymentCompleted,
                    BookingStatus.checkedIn,
                    BookingStatus.checkedOut,
                  ].map((e) => e.code).toList(),
                ),
              ),
            ),

            BlocProvider(
              create: (context) => BookingListCubit(),
              child: BookingListWidget(
                shrinkWrap: true,
                showFilters: false,
                initialFilter: BookingListFilter(
                  owner: widget.mode == BookingsPageMode.owner
                      ? context.read<AppCubit>().state.user?.id
                      : null,
                  renter: widget.mode == BookingsPageMode.renter
                      ? context.read<AppCubit>().state.user?.id
                      : null,
                  status: [
                    BookingStatus.completed,
                    BookingStatus.cancelled,
                    BookingStatus.rejected,
                    BookingStatus.expired,
                  ].map((e) => e.code).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
