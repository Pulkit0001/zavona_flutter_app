import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/domain/models/bookings/booking_list_filter.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/domain/repositories/bookings_repository.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_state.dart';

class BookingListCubit extends Cubit<BookingListState> {
  final BookingsRepository _bookingsRepository = locator<BookingsRepository>();

  BookingListCubit() : super(const BookingListState());

  /// Initialize the cubit with filter and fetch initial data
  Future<void> initialize({BookingListFilter? initialFilter}) async {
    final filter = initialFilter;
    emit(state.copyWith(filter: filter));
    await fetchBookings(isRefresh: true);
  }

  /// Fetch booking list with current filter and pagination
  Future<void> fetchBookings({
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    if (state.filter == null) {
      log('Filter is null, cannot fetch bookings');
      return;
    }

    // Prevent multiple simultaneous requests
    if (state.isLoading) return;

    // Prevent loading more if already reached max
    if (isLoadMore && state.hasReachedMax) return;

    try {
      // Set appropriate loading state
      if (isRefresh) {
        emit(
          state.copyWith(
            listState: EListState.refreshing,
            isRefreshing: true,
            currentPage: 1,
          ),
        );
      } else if (isLoadMore) {
        emit(
          state.copyWith(
            listState: EListState.loadingMore,
            isLoadingMore: true,
          ),
        );
      } else {
        emit(state.copyWith(listState: EListState.loading));
      }

      final currentPage = isRefresh
          ? 1
          : (isLoadMore ? state.nextPage : state.currentPage);

      final response = await _bookingsRepository.listBookings(
        page: currentPage,
        limit: state.limit,
        owner: state.filter!.owner,
        status: state.filter!.status,
        renter: state.filter!.renter,
        search: state.filter!.search,
        sortby: state.filter!.sortby,
      );

      final newBookings = response.bookings ?? [];
      final pagination = response.pagination;

      List<Booking> updatedBookingList;

      if (isRefresh || !isLoadMore) {
        // Replace the list for refresh or initial load
        updatedBookingList = newBookings;
      } else {
        // Append to the list for load more
        updatedBookingList = [...state.bookingList, ...newBookings];
      }

      // Check if we've reached the maximum
      final hasReachedMax =
          pagination?.currentPage == pagination?.totalPages ||
          newBookings.isEmpty;

      // Determine final state
      final finalState = updatedBookingList.isEmpty
          ? EListState.empty
          : EListState.loaded;

      emit(
        state.copyWith(
          listState: finalState,
          bookingList: updatedBookingList,
          pagination: pagination,
          currentPage: currentPage,
          hasReachedMax: hasReachedMax,
          isRefreshing: false,
          isLoadingMore: false,
          errorMessage: null,
        ),
      );
    } catch (e, stackTrace) {
      log('Error fetching bookings: $e', stackTrace: stackTrace);

      emit(
        state.copyWith(
          listState: EListState.error,
          errorMessage: e.toString(),
          isRefreshing: false,
          isLoadingMore: false,
        ),
      );

      // Show error message to user
      MessageUtils.showErrorMessage(
        'Failed to load bookings. Please try again.',
      );
    }
  }

  /// Refresh the booking list (pull-to-refresh)
  Future<void> refresh() async {
    await fetchBookings(isRefresh: true);
  }

  /// Load more bookings (pagination)
  Future<void> loadMore() async {
    if (state.canLoadMore) {
      await fetchBookings(isLoadMore: true);
    }
  }

  /// Update filter and fetch new results
  Future<void> updateFilter(BookingListFilter newFilter) async {
    emit(state.copyWith(filter: newFilter));
    await fetchBookings(isRefresh: true);
  }

  /// Filter by status
  Future<void> filterByStatus(String? status) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(
        status: status?.isNotEmpty ?? false ? [status!] : [],
      );
      await updateFilter(updatedFilter);
    }
  }

  /// Filter by renter
  Future<void> filterByRenter(String? renter) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(renter: renter);
      await updateFilter(updatedFilter);
    }
  }

  /// Search bookings
  Future<void> searchBookings(String? searchQuery) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(search: searchQuery);
      await updateFilter(updatedFilter);
    }
  }

  /// Sort bookings
  Future<void> sortBookings(String? sortBy) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(sortby: sortBy);
      await updateFilter(updatedFilter);
    }
  }

  /// Update owner filter
  Future<void> updateOwner(String owner) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(owner: owner);
      await updateFilter(updatedFilter);
    }
  }

  /// Clear all filters except owner
  Future<void> clearFilters() async {
    if (state.filter != null) {
      final clearedFilter = BookingListFilter.initial(
        owner: state.filter!.owner,
      );
      await updateFilter(clearedFilter);
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const BookingListState());
  }

  /// Get a specific booking by ID from the current list
  Booking? getBookingById(String bookingId) {
    try {
      return state.bookingList.firstWhere((booking) => booking.id == bookingId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a specific booking exists in the current list
  bool containsBooking(String bookingId) {
    return state.bookingList.any((booking) => booking.id == bookingId);
  }

  /// Get bookings by status
  List<Booking> getBookingsByStatus(String status) {
    return state.bookingList
        .where((booking) => booking.status == status)
        .toList();
  }

  /// Get active bookings count
  int get activeBookingsCount {
    return state.bookingList
        .where((booking) => booking.status == 'active')
        .length;
  }

  /// Get pending bookings count
  int get pendingBookingsCount {
    return state.bookingList
        .where((booking) => booking.status == 'pending')
        .length;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
