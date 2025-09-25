import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/bookings/booking_list_filter.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';

class BookingListState {
  final EListState listState;
  final List<Booking> bookingList;
  final String? errorMessage;
  final BookingListFilter? filter;
  final Pagination? pagination;
  final int currentPage;
  final int limit;
  final bool hasReachedMax;
  final bool isRefreshing;
  final bool isLoadingMore;

  const BookingListState({
    this.listState = EListState.initial,
    this.bookingList = const [],
    this.errorMessage,
    this.filter,
    this.pagination,
    this.currentPage = 1,
    this.limit = 10,
    this.hasReachedMax = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
  });

  /// Check if there are any bookings
  bool get isEmpty => bookingList.isEmpty;

  /// Check if we can load more data
  bool get canLoadMore =>
      !hasReachedMax &&
      listState != EListState.loading &&
      listState != EListState.loadingMore;

  /// Check if we're in a loading state
  bool get isLoading =>
      listState == EListState.loading ||
      listState == EListState.loadingMore ||
      listState == EListState.refreshing;

  /// Check if we're in an error state
  bool get hasError => listState == EListState.error;

  /// Check if data is loaded successfully
  bool get isLoaded => listState == EListState.loaded;

  /// Get total count from pagination
  int get totalCount => pagination?.totalBookings?.toInt() ?? 0;

  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Get next page number
  int get nextPage => currentPage + 1;

  BookingListState copyWith({
    EListState? listState,
    List<Booking>? bookingList,
    String? errorMessage,
    BookingListFilter? filter,
    Pagination? pagination,
    int? currentPage,
    int? limit,
    bool? hasReachedMax,
    bool? isRefreshing,
    bool? isLoadingMore,
  }) {
    return BookingListState(
      listState: listState ?? this.listState,
      bookingList: bookingList ?? this.bookingList,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
      pagination: pagination ?? this.pagination,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// ### Booking Status Workflow
// 1. `pending_confirmation` → 2. `confirmed` → 3. `payment_completed` → 4. `checked_in` → 5. `checked_out` → 6. `completed`

// Alternative paths: `rejected`, `cancelled`, `expired`

enum BookingStatus {
  pendingConfirmation('pending_confirmation', 'Pending Confirmation'),
  confirmed('confirmed', 'Confirmed'),
  paymentCompleted('payment_completed', 'Payment Completed'),
  checkedIn('checked_in', 'Checked In'),
  checkedOut('checked_out', 'Checked Out'),
  completed('completed', 'Completed'),
  rejected('rejected', 'Rejected'),
  cancelled('cancelled', 'Cancelled'),
  expired('expired', 'Expired');

  final String code;
  final String displayName;
  const BookingStatus(this.code, this.displayName);
}


// `pending_confirmation` → 2. `confirmed`( by owner only) → 3. `payment_completed`( by renter only) → 4. `checked_in` ( by renter only) → 5. (by renter only)` checked_out` → 6. `completed` (no acion possible)
// `pending_confirmation` → `rejected` by owner only no futher action possible
// `pending_confirmation` → `expired` by system no futher action possible
// `pending_confirmation` → `cancelled` by renter only no futher action possible