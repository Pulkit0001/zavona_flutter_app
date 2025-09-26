import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/domain/models/parking/get_parking_list_response.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_filters_widget.dart';

class ParkingListState {
  final EListState listState;
  final List<Datum> parkingList;
  final String? errorMessage;
  final ParkingListFilter? filter;
  final List<ParkingFilterOption> selectedFilters;
  final Pagination? pagination;
  final int currentPage;
  final int limit;
  final bool hasReachedMax;
  final bool isRefreshing;
  final bool isLoadingMore;

  const ParkingListState({
    this.listState = EListState.initial,
    this.parkingList = const [],
    this.errorMessage,
    this.filter,
    this.pagination,
    this.currentPage = 1,
    this.limit = 10,
    this.hasReachedMax = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.selectedFilters = const [],
  });

  /// Check if there are any parking spots
  bool get isEmpty => parkingList.isEmpty;

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
  int get totalCount => pagination?.total?.toInt() ?? 0;

  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Get next page number
  int get nextPage => currentPage + 1;

  ParkingListState copyWith({
    EListState? listState,
    List<Datum>? parkingList,
    String? errorMessage,
    ParkingListFilter? filter,
    List<ParkingFilterOption>? selectedFilters,
    Pagination? pagination,
    int? currentPage,
    int? limit,
    bool? hasReachedMax,
    bool? isRefreshing,
    bool? isLoadingMore,
  }) {
    return ParkingListState(
      listState: listState ?? this.listState,
      parkingList: parkingList ?? this.parkingList,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
      pagination: pagination ?? this.pagination,
      currentPage: currentPage ?? this.currentPage,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
