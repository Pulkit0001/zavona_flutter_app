import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/auth/kyc_status_enum.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/confirmation_dailog.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/file_upload/bloc/file_uploader_state.dart';
import 'package:zavona_flutter_app/presentation/file_upload/widget/file_uploader_widget.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_cubit.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_state.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';
import '../../../core/router/route_names.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UpdateProfileCubit _updateProfileCubit;

  @override
  void initState() {
    super.initState();
    _updateProfileCubit = UpdateProfileCubit();
    _initializeForm();
  }

  void _initializeForm() {
    final appState = context.read<AppCubit>().state;
    if (appState.user != null) {
      _updateProfileCubit.initializeForm(appState.user!);
    }
  }

  @override
  void dispose() {
    // _updateProfileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, appState) {
        appState.user != null
            ? _updateProfileCubit.initializeForm(appState.user!)
            : null;
      },
      builder: (context, appState) => Scaffold(
        appBar: CustomAppBar(
          titleWidget: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Profile",
                  style: GoogleFonts.mulish(
                    color: Color.fromRGBO(17, 24, 39, 1),
                    fontSize: 25,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          showBackArrowIcon: false,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            if (appState.user != null &&
                (appState.user?.kycStatus ?? '').isNotEmpty) ...[
              KycStatusChip(
                kycStatus:
                    KycStatus.fromCode(appState.user?.kycStatus ?? '') ??
                    KycStatus.pending,
              ),
            ],
            const SizedBox(height: 12),
            Column(
              children: [
                BlocProvider(
                  create: (_) => _updateProfileCubit,
                  child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                    listener: (context, state) {
                      if (state.isSuccess) {
                        // Update the app state with the new user data
                        if (state.user != null) {
                          context.read<AppCubit>().updateUser(state.user!);
                        }
                      }
                    },
                    builder: (context, state) =>
                        state.formState == EFormState.submittingForm
                        ? SizedBox(
                            height: 64,
                            width: 64,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : ProfileAvatarWidget(
                            profileImageUrl: appState.user?.profileImage ?? "",
                          ),
                  ),
                ),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Text(
                    '${(appState.user?.name ?? "").isNotEmpty ? "${appState.user?.name} | " ?? "" : ""}${(appState.user?.email ?? "").isNotEmpty ? appState.user?.email ?? "" : ""}${(appState.user?.email ?? "").isNotEmpty && (appState.user?.mobile ?? "").isNotEmpty ? " | " : ""}${(appState.user?.mobile ?? "").isNotEmpty ? appState.user?.mobile ?? "" : ""}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      fontSize: 16,
                      height: 1.5,
                      color: context.onSurfaceColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (KycStatus.fromCode(
                          appState.user?.kycStatus ?? '',
                        )?.requiresAction ??
                        true) ...[
                      ProfileMenuItem(
                        label:
                            appState.user?.kycStatus == KycStatus.pending.code
                            ? 'Complete KYC'
                            : 'Update KYC',
                        leadingIcon: CustomIcons.kycIcon(),
                        onTap: () {
                          context.pushNamed(RouteNames.updateKyc);
                        },
                      ),
                      SizedBox(height: 14),
                    ],
                    if (appState.user?.userRole == "seller") ...[
                      ProfileMenuItem(
                        label: 'My Parking Spots',
                        leadingIcon: CustomIcons.parkingIcon(),
                        onTap: () {
                          context.pushNamed(RouteNames.myParkingSpots);
                        },
                      ),
                      SizedBox(height: 14),
                    ],
                    ProfileMenuItem(
                      label: 'My Bookings',
                      leadingIcon: CustomIcons.bookingsIcon(),
                      onTap: () {
                        context.pushNamed(RouteNames.myBookings);
                      },
                    ),
                    SizedBox(height: 14),

                    if (appState.user?.userRole == "seller") ...[
                      ProfileMenuItem(
                        label: 'Booking Requests',
                        leadingIcon: CustomIcons.bookingRequestsIcon(),
                        onTap: () {
                          context.pushNamed(RouteNames.bookingRequests);
                        },
                      ),
                      SizedBox(height: 14),
                    ],
                    ProfileMenuItem(
                      label: 'Edit Profile',
                      leadingIcon: CustomIcons.editProfileIcon(),
                      onTap: () {
                        context.pushNamed(RouteNames.editProfile);
                      },
                    ),
                    SizedBox(height: 14),
                    ProfileMenuItem(
                      label: 'Contact Us',
                      leadingIcon: CustomIcons.customerSupportIcon(),
                      onTap: () {},
                    ),
                    SizedBox(height: 14),
                    ProfileMenuItem(
                      label: 'Privacy Policy',
                      leadingIcon: CustomIcons.privacyPolicyIcon(),
                      onTap: () {},
                    ),
                    SizedBox(height: 14),
                    ProfileMenuItem(
                      label: 'Logout',
                      leadingIcon: CustomIcons.logoutIcon(),
                      onTap: () async {
                        var res = await showDialog(
                          context: context,
                          builder: (_) => ConfirmationDialog(
                            confirmationMessage:
                                "Are you sure you want to logout?",
                          ),
                        );
                        if (res ?? false) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<AppCubit>().logout();
                            SessionManager.instance.clearSession();
                            context.go(RouteNames.dashboard);
                            // context.goNamed(RouteNames.mobileEmail);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key, required this.profileImageUrl});

  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 78,
          width: 78,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: context.onSurfaceColor, width: 0.5),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: "${NetworkConstants.bucketBaseUrl}/$profileImageUrl",
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, child, loadingProgress) {
                return Center(
                  child: CircularProgressIndicator(
                    color: context.onPrimaryColor,
                  ),
                );
              },
              errorWidget: (_, __, ___) =>
                  Image.asset('assets/images/dummy_avatar.png'),
            ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: FileUploaderWidget.builder(
            uploadPurpose: "profilePic",
            onFilesChanged: (files) async {
              if (files.isNotEmpty &&
                  files.first.status == UploadFileStatus.uploaded &&
                  (files.first.uploadedFileKey?.isNotEmpty ?? false)) {
                log(
                  "New profile image uploaded: ${files.first.uploadedFileKey}",
                );
                context.read<UpdateProfileCubit>().updateProfileImageKey(
                  files.first.uploadedFileKey,
                );
                context.read<UpdateProfileCubit>().updateProfile();
              }
            },
            child: Container(
              height: 24,
              width: 24,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: CustomIcons.cameraIcon(20, 20),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.label,
    required this.leadingIcon,
    required this.onTap,
  });

  final String label;
  final Widget leadingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xfffffff8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: context.primaryColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            leadingIcon,
            SizedBox(width: 12),
            VerticalDivider(color: context.onSurfaceColor, width: 0.5),
            SizedBox(width: 12),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                label,
                style: GoogleFonts.workSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: context.onSurfaceColor,
                ),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.arrowRight,
              color: context.onSurfaceColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class KycStatusChip extends StatelessWidget {
  const KycStatusChip({super.key, required this.kycStatus});

  final KycStatus kycStatus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouteNames.updateKyc);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kycStatus.color.withValues(alpha: 0.25),
            border: Border.all(color: kycStatus.color, width: 0.5),
          ),
          child: Text(
            "KYC - ${kycStatus.displayName} >",
            style: GoogleFonts.workSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: kycStatus.color,
            ),
          ),
        ),
      ),
    );
  }
}

class ParkingVerificationChip extends StatelessWidget {
  const ParkingVerificationChip({
    super.key,
    required this.ownerKycStatus,
    required this.parkingVerificationStatus,
  });

  final KycStatus? ownerKycStatus;
  final ParkingVerificationStatus? parkingVerificationStatus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouteNames.updateKyc);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: parkingVerificationStatus
                .color(ownerKycStatus)
                .withValues(alpha: 0.25),
            border: Border.all(
              color: parkingVerificationStatus.color(ownerKycStatus),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                parkingVerificationStatus.icon(ownerKycStatus),
                size: 10,
                color: parkingVerificationStatus.color(ownerKycStatus),
              ),
              SizedBox(width: 4),
              Text(
                parkingVerificationStatus.displayName(ownerKycStatus),
                style: GoogleFonts.workSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: parkingVerificationStatus.color(ownerKycStatus),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
