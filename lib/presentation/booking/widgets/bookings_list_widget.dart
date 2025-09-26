import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/bookings/booking_list_filter.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_state.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_card_shimmer_widget.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_card_widget.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_horizonatal_list_tile.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class BookingListWidget extends StatefulWidget {
  final BookingListFilter? initialFilter;
  final void Function(Booking booking)? onBookingTap;
  final Widget Function(BuildContext context, Booking booking)?
  bookingCardBuilder;
  final bool showFilters;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollController? scrollController;
  final Axis scrollDirection;

  const BookingListWidget({
    super.key,
    this.initialFilter,
    this.onBookingTap,
    this.bookingCardBuilder,
    this.showFilters = true,
    this.padding,
    this.shrinkWrap = false,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<BookingListWidget> createState() => _BookingListWidgetState();
}

class _BookingListWidgetState extends State<BookingListWidget> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingListCubit>().initialize(
        initialFilter: widget.initialFilter,
      );
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<BookingListCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingListCubit, BookingListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            // Filters section
            if (widget.showFilters) _buildFiltersSection(context, state),
            // Content
            Expanded(child: _buildContent(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildFiltersSection(BuildContext context, BookingListState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.mediumGray.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryDarkBlue,
                ),
              ),
              const Spacer(),
              if (state.filter != null && _hasActiveFilters(state.filter!))
                TextButton(
                  onPressed: () =>
                      context.read<BookingListCubit>().clearFilters(),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryYellowDark,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.mediumGray),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search bookings...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.mediumGray,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.mediumGray,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context.read<BookingListCubit>().searchBookings(null);
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                context.read<BookingListCubit>().searchBookings(
                  value.isEmpty ? null : value,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Filter chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                'Pending',
                state.filter?.status == 'pending',
                () => context.read<BookingListCubit>().filterByStatus(
                  state.filter?.status == 'pending' ? null : 'pending',
                ),
              ),
              _buildFilterChip(
                'Confirmed',
                state.filter?.status == 'confirmed',
                () => context.read<BookingListCubit>().filterByStatus(
                  state.filter?.status == 'confirmed' ? null : 'confirmed',
                ),
              ),
              _buildFilterChip(
                'Active',
                state.filter?.status == 'active',
                () => context.read<BookingListCubit>().filterByStatus(
                  state.filter?.status == 'active' ? null : 'active',
                ),
              ),
              _buildFilterChip(
                'Completed',
                state.filter?.status == 'completed',
                () => context.read<BookingListCubit>().filterByStatus(
                  state.filter?.status == 'completed' ? null : 'completed',
                ),
              ),
              _buildFilterChip(
                'Cancelled',
                state.filter?.status == 'cancelled',
                () => context.read<BookingListCubit>().filterByStatus(
                  state.filter?.status == 'cancelled' ? null : 'cancelled',
                ),
              ),
              _buildSortFilterChip(context, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryYellow : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryYellowDark
                : AppColors.mediumGray,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? AppColors.secondaryDarkBlue
                : context.onPrimaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSortFilterChip(BuildContext context, BookingListState state) {
    final sortBy = state.filter?.sortby ?? 'created_at';
    final sortLabels = {
      'created_at': 'Date Created',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'amount': 'Amount',
    };

    return GestureDetector(
      onTap: () => _showSortDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: sortBy != 'created_at'
              ? AppColors.primaryYellow
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sortBy != 'created_at'
                ? AppColors.primaryYellowDark
                : AppColors.mediumGray,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort: ${sortLabels[sortBy] ?? sortBy}',
              style: GoogleFonts.workSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: sortBy != 'created_at'
                    ? AppColors.secondaryDarkBlue
                    : context.onPrimaryColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: sortBy != 'created_at'
                  ? AppColors.secondaryDarkBlue
                  : context.onPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookingListState state) {
    if (state.listState == EListState.loading ||
        state.listState == EListState.refreshing) {
      return _buildLoadingState();
    }

    if (state.listState == EListState.error && state.bookingList.isEmpty) {
      return _buildErrorState(context, state.errorMessage);
    }

    if (state.listState == EListState.empty ||
        (state.isLoaded && state.bookingList.isEmpty)) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => context.read<BookingListCubit>().refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: widget.shrinkWrap,
        itemCount: state.bookingList.length + (state.canLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.bookingList.length) {
            return _buildLoadingMoreIndicator(state);
          }

          final booking = state.bookingList[index];
          return GestureDetector(
            onTap: () => widget.onBookingTap?.call(booking),
            child:
                widget.bookingCardBuilder?.call(context, booking) ??
                BookingCardWidget(booking: booking),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
            SizedBox(height: 16),
            const BookingCardShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.errorColor),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.workSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.onSurfaceColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Failed to load bookings',
              style: GoogleFonts.workSans(
                fontSize: 14,
                color: context.onSurfaceColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => context.read<BookingListCubit>().refresh(),
              label: 'Try Again',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_online_outlined,
              size: 64,
              color: context.onPrimaryColor.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: GoogleFonts.workSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.onPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              style: GoogleFonts.workSans(
                fontSize: 14,
                color: context.onPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator(BookingListState state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryYellow),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDefaultBookingCard(BuildContext context, Booking booking) {
    return BookingCardWidget(booking: booking);
  }

  bool _hasActiveFilters(BookingListFilter filter) {
    return filter.status != null ||
        filter.renter != null ||
        filter.search != null ||
        filter.sortby != null && filter.sortby != 'created_at';
  }

  void _showSortDialog(BuildContext context) {
    final sortOptions = {
      'created_at': 'Date Created',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'amount': 'Amount',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sort By',
          style: GoogleFonts.workSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sortOptions.entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              onTap: () {
                context.read<BookingListCubit>().sortBookings(entry.key);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
