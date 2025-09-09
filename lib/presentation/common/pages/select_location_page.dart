import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zavona_flutter_app/core/config/api_config.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/bloc/select_location_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import 'package:zavona_flutter_app/third_party_services/location_service.dart'
    as location_service;
import 'package:zavona_flutter_app/third_party_services/location_service.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  GoogleMapController? _mapController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.text =
        context.read<SelectLocationCubit>().state.selectedLocation?.address ??
        "";
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: ApiConfig.searchDebounceMilliseconds),
      () {
        context.read<SelectLocationCubit>().searchPlaces(
          _searchController.text,
        );
      },
    );
  }

  Future<void> setAsMyCurrentLocation() async {
    try {
      final location =
          await location_service.LocationService.getCurrentLocation(context);
      if (location != null) {
        context.read<SelectLocationCubit>().setSelectedLocation(location);
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(location.latitude, location.longitude),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  void _selectLocation(LocationDTO selectedLocation) {
    if (selectedLocation.isCurrentLocation) {
      setAsMyCurrentLocation();
      return;
    }
    context.read<SelectLocationCubit>().setSelectedLocation(selectedLocation);
    final location = LatLng(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, ApiConfig.selectedLocationZoom),
      );
    }
    _searchFocusNode.unfocus();
  }

  void _onMapTap(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      String address;
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final street = placemark.street ?? '';
        final locality = placemark.locality ?? '';
        final country = placemark.country ?? '';

        address =
            '$street${locality.isNotEmpty ? ', $locality' : ''}${country.isNotEmpty ? ', $country' : ''}';
        if (address.trim().startsWith(',')) {
          address = address.trim().substring(1).trim();
        }
        if (address.isEmpty) {
          address =
              "Location at ${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}";
        }
      } else {
        address =
            "Location at ${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}";
      }
      _searchController.text = address;
      _selectLocation(LocationDTO(latLng.latitude, latLng.longitude, address));
    } catch (e) {
      MessageUtils.showErrorMessage(
        ("Not able to find address for the selected area"),
      );
    }
  }

  void _confirmSelection() {
    if (context.read<SelectLocationCubit>().state.selectedLocation != null) {
      context.pop(true);
    } else {
      MessageUtils.showErrorMessage("Please select a location to continue");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectLocationCubit, SelectLocationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: const CustomAppBar(
            title: "Select Location",
            showBackArrowIcon: true,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Search Field Section
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSearchField(),
                        if (state.suggestions.isNotEmpty)
                          _buildSuggestionsList(state.suggestions),
                      ],
                    ),
                  ),

                  // Map Section
                  Expanded(child: _buildMapSection()),
                ],
              ),

              // Continue Button
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: PrimaryButton(
                  label: "Continue",
                  onPressed: _confirmSelection,
                  size: ButtonSize.large,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFF8),
        border: Border.all(color: AppColors.primaryYellow, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (_) => _onSearchChanged(),
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: "Search for places or addresses",
          hintStyle: GoogleFonts.workSans(
            color: AppColors.secondaryDarkBlue.withValues(alpha: 0.6),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: AppColors.secondaryDarkBlue,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.xmark,
                    color: AppColors.secondaryDarkBlue,
                    size: 16,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SelectLocationCubit>().searchPlaces("");
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: GoogleFonts.workSans(
          color: AppColors.secondaryDarkBlue,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(List<LocationDTO> suggestions) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: Icon(
              suggestion.isCurrentLocation
                  ? FontAwesomeIcons.locationCrosshairs
                  : FontAwesomeIcons.locationDot,
              color: suggestion.isCurrentLocation
                  ? AppColors.primaryYellow
                  : AppColors.secondaryDarkBlue,
              size: 20,
            ),
            title: Text(
              suggestion.address,
              style: GoogleFonts.workSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.secondaryDarkBlue,
              ),
            ),
            onTap: () {
              _selectLocation(suggestion);
              _searchController.text = suggestion.address;
              context.read<SelectLocationCubit>().searchPlaces("");
            },
          );
        },
      ),
    );
  }

  Widget _buildMapSection() {
    return BlocBuilder<SelectLocationCubit, SelectLocationState>(
      builder: (context, state) {
        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // Move to current location if available
            if (state.selectedLocation != null) {
              controller.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(
                    state.selectedLocation!.latitude,
                    state.selectedLocation!.longitude,
                  ),
                ),
              );
            }
          },
          initialCameraPosition: CameraPosition(
            target: state.selectedLocation != null
                ? LatLng(
                    state.selectedLocation!.latitude,
                    state.selectedLocation!.longitude,
                  )
                : const LatLng(
                    ApiConfig.defaultLatitude,
                    ApiConfig.defaultLongitude,
                  ),
            zoom: ApiConfig.defaultZoom,
          ),
          onTap: _onMapTap,
          markers: {
            Marker(
              markerId: MarkerId(state.selectedLocation.hashCode.toString()),
              position: state.selectedLocation != null
                  ? LatLng(
                      state.selectedLocation!.latitude,
                      state.selectedLocation!.longitude,
                    )
                  : const LatLng(
                      ApiConfig.defaultLatitude,
                      ApiConfig.defaultLongitude,
                    ),
            ),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false, // We'll use custom button
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        );
      },
    );
  }
}
