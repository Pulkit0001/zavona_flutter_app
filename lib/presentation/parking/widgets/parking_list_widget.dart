import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/core/router/route_names.dart';
import 'package:zavona_flutter_app/domain/models/auth/kyc_status_enum.dart';
import 'package:zavona_flutter_app/domain/models/parking/get_parking_list_response.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_filters_widget.dart';
import 'package:zavona_flutter_app/presentation/profile/pages/profile_page.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';

class ParkingListWidget extends StatefulWidget {
  final ParkingListFilter? initialFilter;
  final void Function(Datum parking)? onParkingTap;
  final void Function(Datum parking)? onBookNowTap;
  final bool showFilters;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollController? scrollController;

  const ParkingListWidget({
    super.key,
    this.initialFilter,
    this.onParkingTap,
    this.onBookNowTap,
    this.showFilters = true,
    this.padding,
    this.shrinkWrap = false,
    this.scrollController,
  });

  @override
  State<ParkingListWidget> createState() => _ParkingListWidgetState();
}

class _ParkingListWidgetState extends State<ParkingListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ParkingListCubit>().loadMore();
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
    return BlocBuilder<ParkingListCubit, ParkingListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content
            _buildContent(context, state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ParkingListState state) {
    if (state.listState == EListState.loading ||
        state.listState == EListState.refreshing) {
      return _buildLoadingState();
    }

    if (state.listState == EListState.error && state.parkingList.isEmpty) {
      return _buildErrorState(context, state.errorMessage);
    }

    if (state.listState == EListState.empty ||
        (state.isLoaded && state.parkingList.isEmpty)) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ParkingListCubit>().refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: widget.shrinkWrap,
        itemCount: state.parkingList.length + (state.canLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.parkingList.length) {
            return _buildLoadingMoreIndicator(state);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildParkingCard(context, state.parkingList[index]),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ParkingCardShimmer(),
          SizedBox(height: 16),
          ParkingCardShimmer(),
        ],
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
              errorMessage ?? 'Failed to load parking spots',
              style: GoogleFonts.workSans(
                fontSize: 14,
                color: context.onSurfaceColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => context.read<ParkingListCubit>().refresh(),
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
              Icons.local_parking_outlined,
              size: 64,
              color: context.onPrimaryColor.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No parking spots found',
              style: GoogleFonts.workSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.onPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search in a different area',
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

  Widget _buildLoadingMoreIndicator(ParkingListState state) {
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

  Widget _buildParkingCard(BuildContext context, Datum parking) {
    final spot = parking.spots?.isNotEmpty == true
        ? parking.spots!.first
        : null;

    return GestureDetector(
      onTap: () => widget.onParkingTap?.call(parking),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfffffff8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: AppColors.primaryYellow.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            if (parking.thumbnailUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      '${NetworkConstants.bucketBaseUrl}/${parking.thumbnailUrl}',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 160,
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryYellow,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 160,
                    color: AppColors.surfaceVariant,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: context.onPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and verification
                  Row(
                    children: [
                      Text(
                        parking.name ?? 'Parking Space',
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryDarkBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      /// For Onwer show both KYC and Parking Verification Status giving priority to Rejected and Pending
                      /// For other users show only Verified status if any
                      if (parking.owner?.id ==
                          context.read<AppCubit>().state.user?.id) ...[
                        const SizedBox(width: 8),

                        ParkingVerificationChip(
                          ownerKycStatus: KycStatus.fromCode(
                            parking.owner?.kycStatus ?? '',
                          ),
                          parkingVerificationStatus:
                              ParkingVerificationStatus.fromCode(
                                parking.parkingVerificationStatus ?? '',
                              ),
                        ),
                      ] else if (parking.owner?.kycStatus ==
                              KycStatus.verified.code ||
                          parking.parkingVerificationStatus ==
                              ParkingVerificationStatus.verified.code) ...[
                        const SizedBox(width: 8),
                        if ((parking.owner?.kycStatus ==
                                KycStatus.verified.code) ^
                            (parking.parkingVerificationStatus ==
                                ParkingVerificationStatus.verified.code))
                          ParkingVerificationChip(
                            ownerKycStatus: KycStatus.rejected,
                            parkingVerificationStatus:
                                ParkingVerificationStatus.verified,
                          )
                        else
                          ParkingVerificationChip(
                            ownerKycStatus: KycStatus.fromCode(
                              parking.owner?.kycStatus ?? '',
                            ),
                            parkingVerificationStatus:
                                ParkingVerificationStatus.fromCode(
                                  parking.parkingVerificationStatus ?? '',
                                ),
                          ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Address
                  if (parking.address != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: context.onPrimaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            parking.address!,
                            style: GoogleFonts.workSans(
                              fontSize: 13,
                              color: context.onPrimaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 6),

                  // Price and availability
                  Row(
                    children: [
                      Expanded(child: _buildPriceInfo(spot, parking)),
                      _buildBookButton(
                        context,
                        parking.id ?? '',
                        spot?.id ?? '',
                        parking.owner?.id ?? '',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Additional info
                  _buildAdditionalInfo(parking, spot),
                ],
              ),
            ),

            // Remarks Section Only for Rejected Status and Owner
            if (parking.owner?.id == context.read<AppCubit>().state.user?.id &&
                parking.parkingVerificationStatus ==
                    ParkingVerificationStatus.rejected.code &&
                (parking.parkingVerificationRemarks?.isNotEmpty ?? false))
              Container(
                decoration: BoxDecoration(
                  color: context.errorColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                    top: Radius.circular(4),
                  ),
                  border: Border.all(color: context.errorColor, width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Remarks: ${parking.parkingVerificationRemarks}',
                      style: GoogleFonts.workSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: context.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(Spot? spot, Datum parking) {
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

    if (spot.availableToSell == true && spot.sellingPrice != null) {
      priceTexts.add('₹${spot.sellingPrice} (Sale)');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (priceTexts.isNotEmpty)
          Text(
            priceTexts.join(' • '),
            style: GoogleFonts.workSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.onSurfaceColor,
            ),
          ),
        const SizedBox(height: 4),
        _buildAvailabilityAndAmenitiesTags(spot),
      ],
    );
  }

  Widget _buildAvailabilityAndAmenitiesTags(Spot spot) {
    List<Widget> tags = [];

    if (spot.availableToRent == true) {
      tags.add(_buildTag('For Rent', context.secondaryColor));
    }

    if (spot.availableToSell == true) {
      tags.add(_buildTag('For Sale', context.secondaryColor));
    }

    if (spot.amenities != null && spot.amenities!.isNotEmpty) {
      tags.addAll([
        SizedBox(
          height: 16,
          child: VerticalDivider(
            width: 4,
            thickness: 0.5,
            color: context.onSurfaceColor,
          ),
        ),
        ...spot.amenities!.map(
          (amenity) => _buildTag(
            ParkingAmenities.values
                .where((e) => e.name == amenity)
                .firstOrNull
                ?.displayName,
            context.secondaryColor,
          ),
        ),
      ]);
    }

    return Wrap(spacing: 4, runSpacing: 4, children: tags);
  }

  Widget _buildTag(String? text, Color color) {
    if ((text ?? '').isEmpty) return SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text!,
        style: GoogleFonts.workSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBookButton(
    BuildContext context,
    String parkingSpaceId,
    String parkingSpotId,
    String ownerId,
  ) {
    return PrimaryButton(
      size: ButtonSize.small,
      label: ownerId != context.read<AppCubit>().state.user?.id
          ? 'Book Now'
          : 'Update',
      onPressed: () async {
        if (ownerId != context.read<AppCubit>().state.user?.id) {
          context.pushNamed(
            RouteNames.createBooking,
            extra: {
              'parkingSpaceId': parkingSpaceId,
              'parkingSpotId': parkingSpotId,
            },
          );
        } else {
          var cubit = context.read<ParkingListCubit>();
          var res = await context.pushNamed(
            RouteNames.updateParkingSpace,
            pathParameters: {'parkingSpaceId': parkingSpaceId},
          );
          if (res == true) {
            cubit.refresh();
          }
        }
      },
    );
  }

  Widget _buildAdditionalInfo(Datum parking, Spot? spot) {
    List<Widget> infoItems = [];

    // Distance
    if (parking.distanceInKm != null) {
      infoItems.add(
        _buildInfoItem(Icons.directions_walk, '${parking.distanceInKm}km away'),
      );
    }

    // Society name
    if (parking.areaSocietyName != null) {
      infoItems.add(
        _buildInfoItem(Icons.location_city, parking.areaSocietyName!),
      );
    }

    // Parking sizes
    if (spot?.parkingSize?.isNotEmpty == true) {
      infoItems.add(
        _buildInfoItem(Icons.directions_car, spot!.parkingSize!.join(', ')),
      );
    }

    return Wrap(spacing: 16, runSpacing: 4, children: infoItems);
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.onPrimaryColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.workSans(
            fontSize: 12,
            color: context.onSurfaceColor,
          ),
        ),
      ],
    );
  }

  bool _hasActiveFilters(ParkingListFilter filter) {
    return filter.availableToRent != null ||
        filter.availableToSell != null ||
        filter.isVerified != null ||
        filter.societyName != null ||
        filter.minSellingPrice != null ||
        filter.maxSellingPrice != null ||
        filter.minRentPricePerDay != null ||
        filter.maxRentPricePerDay != null ||
        filter.minRentPricePerHour != null ||
        filter.maxRentPricePerHour != null ||
        filter.maxDistance != '10';
  }

  void _showDistanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Distance',
          style: GoogleFonts.workSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['5', '10', '15', '25', '50'].map((distance) {
            return ListTile(
              title: Text('${distance}km'),
              onTap: () {
                context.read<ParkingListCubit>().updateMaxDistance(distance);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ParkingCardShimmer extends StatelessWidget {
  const ParkingCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfffffff8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
          ),

          // Content shimmer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and verification shimmer
                Row(
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Address shimmer
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 14,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 14,
                              width: double.infinity * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Price and book button shimmer
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 16,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 12,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 32,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Additional info shimmer
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative version without shimmer package dependency
class ParkingCardShimmerCustom extends StatefulWidget {
  const ParkingCardShimmerCustom({Key? key}) : super(key: key);

  @override
  State<ParkingCardShimmerCustom> createState() =>
      _ParkingCardShimmerCustomState();
}

class _ParkingCardShimmerCustomState extends State<ParkingCardShimmerCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfffffff8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                      stops: [
                        _animation.value - 1,
                        _animation.value,
                        _animation.value + 1,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content shimmer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and verification shimmer
                Row(
                  children: [
                    Expanded(
                      child: _buildShimmerBox(
                        height: 20,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildShimmerBox(height: 16, width: 60),
                  ],
                ),

                const SizedBox(height: 6),

                // Address shimmer
                Row(
                  children: [
                    _buildShimmerBox(height: 16, width: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        children: [
                          _buildShimmerBox(height: 14, width: double.infinity),
                          const SizedBox(height: 4),
                          _buildShimmerBox(
                            height: 14,
                            width: double.infinity * 0.7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Price and book button shimmer
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmerBox(height: 16, width: 80),
                          const SizedBox(height: 4),
                          _buildShimmerBox(height: 12, width: 60),
                        ],
                      ),
                    ),
                    _buildShimmerBox(height: 32, width: 80),
                  ],
                ),

                const SizedBox(height: 12),

                // Additional info shimmer
                Row(
                  children: [
                    _buildShimmerBox(height: 12, width: 60),
                    const SizedBox(width: 16),
                    _buildShimmerBox(height: 12, width: 80),
                    const SizedBox(width: 16),
                    _buildShimmerBox(height: 12, width: 50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({required double height, required double width}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      },
    );
  }
}
