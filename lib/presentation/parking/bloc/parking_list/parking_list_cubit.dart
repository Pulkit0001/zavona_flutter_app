import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/domain/models/parking/get_parking_list_response.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_list_filter.dart';
import 'package:zavona_flutter_app/domain/repositories/parkings_repository.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_filters_widget.dart';

class ParkingListCubit extends Cubit<ParkingListState> {
  final ParkingsRepository _parkingsRepository = locator<ParkingsRepository>();

  ParkingListCubit() : super(const ParkingListState());

  /// Initialize the cubit with location and fetch initial data
  Future<void> initialize({ParkingListFilter? initialFilter}) async {
    final filter = initialFilter;
    emit(state.copyWith(filter: filter));
    await fetchParkings(isRefresh: false);
  }

  /// Fetch parking list with current filter and pagination
  Future<void> fetchParkings({
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
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

      final response = await _parkingsRepository.listParkings(
        page: currentPage,
        limit: state.limit,
        latitude: state.filter!.latitude,
        longitude: state.filter!.longitude,
        maxDistance: state.filter!.maxDistance,
        owner: state.filter!.owner,
        societyName: state.filter!.societyName,
        isVerified: state.filter!.isVerified,
        minSellingPrice: state.filter!.minSellingPrice,
        maxSellingPrice: state.filter!.maxSellingPrice,
        minRentPricePerDay: state.filter!.minRentPricePerDay,
        maxRentPricePerDay: state.filter!.maxRentPricePerDay,
        minRentPricePerHour: state.filter!.minRentPricePerHour,
        maxRentPricePerHour: state.filter!.maxRentPricePerHour,
        availableToSell: state.filter!.availableToSell,
        availableToRent: state.filter!.availableToRent,
      );

      final newParkings = response.data ?? [];
      final pagination = response.pagination;

      List<Datum> updatedParkingList;

      if (isRefresh || !isLoadMore) {
        // Replace the list for refresh or initial load
        updatedParkingList = newParkings;
      } else {
        // Append to the list for load more
        updatedParkingList = [...state.parkingList, ...newParkings];
      }

      // Check if we've reached the maximum
      final hasReachedMax =
          pagination?.page == pagination?.totalPages || newParkings.isEmpty;

      // Determine final state
      final finalState = updatedParkingList.isEmpty
          ? EListState.empty
          : EListState.loaded;

      emit(
        state.copyWith(
          listState: finalState,
          parkingList: updatedParkingList,
          pagination: pagination,
          currentPage: currentPage,
          hasReachedMax: hasReachedMax,
          isRefreshing: false,
          isLoadingMore: false,
          errorMessage: null,
        ),
      );
    } catch (e, stackTrace) {
      log('Error fetching parkings: $e', stackTrace: stackTrace);

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
        'Failed to load parking spots. Please try again.',
      );
    }
  }

  /// Refresh the parking list (pull-to-refresh)
  Future<void> refresh() async {
    await fetchParkings(isRefresh: true);
  }

  /// Load more parkings (pagination)
  Future<void> loadMore() async {
    if (state.canLoadMore) {
      await fetchParkings(isLoadMore: true);
    }
  }

  /// Update filter and fetch new results
  Future<void> updateFilter(ParkingListFilter newFilter) async {
    emit(state.copyWith(filter: newFilter));
    await fetchParkings(isRefresh: true);
  }

  /// Update location and refresh
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    if (state.filter != null) {
      final updatedFilter = ParkingListFilter.updateLocation(
        state.filter!,
        latitude: latitude,
        longitude: longitude,
      );
      await updateFilter(updatedFilter);
    }
  }

  /// Apply specific filter for selling/renting
  Future<void> filterByAvailability({
    bool? availableToSell,
    bool? availableToRent,
  }) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(
        availableToSell: availableToSell?.toString(),
        availableToRent: availableToRent?.toString(),
      );
      await updateFilter(updatedFilter);
    }
  }

  /// Apply price range filter
  Future<void> filterByPriceRange({
    String? minSellingPrice,
    String? maxSellingPrice,
    String? minRentPricePerDay,
    String? maxRentPricePerDay,
    String? minRentPricePerHour,
    String? maxRentPricePerHour,
  }) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(
        minSellingPrice: minSellingPrice,
        maxSellingPrice: maxSellingPrice,
        minRentPricePerDay: minRentPricePerDay,
        maxRentPricePerDay: maxRentPricePerDay,
        minRentPricePerHour: minRentPricePerHour,
        maxRentPricePerHour: maxRentPricePerHour,
      );
      await updateFilter(updatedFilter);
    }
  }

  /// Filter by society name
  Future<void> filterBySociety(String? societyName) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(societyName: societyName);
      await updateFilter(updatedFilter);
    }
  }

  /// Filter by verification status
  Future<void> filterByVerification(bool? isVerified) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(
        isVerified: isVerified?.toString(),
      );
      await updateFilter(updatedFilter);
    }
  }

  /// Update maximum distance filter
  Future<void> updateMaxDistance(String maxDistance) async {
    if (state.filter != null) {
      final updatedFilter = state.filter!.copyWith(maxDistance: maxDistance);
      await updateFilter(updatedFilter);
    }
  }

  /// Clear all filters except location and distance
  Future<void> clearFilters() async {
    if (state.filter != null) {
      final clearedFilter = ParkingListFilter.initial(
        latitude: state.filter!.latitude,
        longitude: state.filter!.longitude,
        maxDistance: state.filter!.maxDistance,
      );
      await updateFilter(clearedFilter);
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const ParkingListState());
  }

  /// Get a specific parking by ID from the current list
  Datum? getParkingById(String parkingId) {
    try {
      return state.parkingList.firstWhere((parking) => parking.id == parkingId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a specific parking exists in the current list
  bool containsParking(String parkingId) {
    return state.parkingList.any((parking) => parking.id == parkingId);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void applyFilters(List<ParkingFilterOption> options) {
    emit(state.copyWith(selectedFilters: options));
  }
}
