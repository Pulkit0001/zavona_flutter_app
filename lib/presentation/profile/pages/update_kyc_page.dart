import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/auth/kyc_status_enum.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/image_upload_button.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_cubit.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_state.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class UpdateKycPage extends StatefulWidget {
  const UpdateKycPage({super.key});

  @override
  State<UpdateKycPage> createState() => _UpdateKycPageState();
}

class _UpdateKycPageState extends State<UpdateKycPage> {
  final _formKey = GlobalKey<FormState>();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (context) => _updateProfileCubit,
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, state) {
              if (state.isSuccess) {
                // Update the app state with the new user data
                if (state.user != null) {
                  context.read<AppCubit>().updateUser(state.user!);
                }
                context.pop();
              }
            },
            builder: (context, updateState) {
              return Scaffold(
                appBar: CustomAppBar(
                  title: (appState.user?.kycStatus == KycStatus.pending.code)
                      ? 'Complete KYC'
                      : 'Update KYC',
                ),
                body: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 24),
                        Expanded(child: KycDocsWidget()),
                        SizedBox(height: 24),
                        if (updateState.user?.kycStatus ==
                                KycStatus.verified.code ||
                            updateState.user?.kycStatus ==
                                KycStatus.pendingApproval.code) ...[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: KycStatus.fromCode(
                                updateState.user?.kycStatus ?? '',
                              ).color.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: KycStatus.fromCode(
                                  updateState.user?.kycStatus ?? '',
                                ).color,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (updateState.user?.kycStatus ==
                                    KycStatus.verified.code) ...[
                                  CustomIcons.verifiedGreenIcon(16, 16),
                                ] else ...[
                                  FaIcon(
                                    FontAwesomeIcons.clock,
                                    size: 16,
                                    color: KycStatus.fromCode(
                                      updateState.user?.kycStatus ?? '',
                                    ).color,
                                  ),
                                ],
                                SizedBox(width: 8),
                                Text(
                                  "KYC - ${KycStatus.fromCode(updateState.user?.kycStatus ?? '').displayName}",
                                  style: GoogleFonts.workSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                    color: KycStatus.fromCode(
                                      updateState.user?.kycStatus ?? '',
                                    ).color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                        ] else ...[
                          PrimaryButton(
                            isLoading: updateState.isLoading,
                            label: updateState.isLoading
                                ? "Submitting..."
                                : "Submit",
                            onPressed: updateState.isLoading
                                ? null
                                : () async {
                                    await _updateProfileCubit.updateKycDocs();
                                  },
                            trailingIcon: updateState.isLoading
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : CustomIcons.checkIcon(16, 16),
                          ),
                          SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class KycDocsWidget extends StatelessWidget {
  const KycDocsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((state.user?.kycRemarks ?? '').isEmpty &&
              state.user?.kycStatus == KycStatus.rejected.code) ...[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.errorColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.errorColor),
              ),
              child: Text(
                "Kyc Got Rejected - ${state.user?.kycRemarks ?? ''}",
                style: GoogleFonts.workSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: context.errorColor,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
          Text(
            "Upload KYC Documents",
            style: GoogleFonts.workSans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: context.onSurfaceColor,
            ),
          ),
          Text(
            "Upload clear images of your KYC document like Aadhar, Voter ID or Passport.",
            style: GoogleFonts.workSans(
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w400,
              color: context.onSurfaceColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            " Front Side",
            textAlign: TextAlign.start,
            style: GoogleFonts.workSans(
              fontSize: 16,
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: context.onSurfaceColor,
            ),
          ),
          SizedBox(height: 4),

          ImagePickerButton(
            onFileUploaded: (fileKey) {
              context.read<UpdateProfileCubit>().updateKycDocKey(fileKey, 0);
            },
            uploadPurpose: "verificationDocument",
            imageFileKey: state.kycDocsKey.firstOrNull ?? "",
          ),

          SizedBox(height: 12),
          Text(
            " Back Side",
            textAlign: TextAlign.start,
            style: GoogleFonts.workSans(
              fontSize: 16,
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: context.onSurfaceColor,
            ),
          ),
          SizedBox(height: 4),
          ImagePickerButton(
            onFileUploaded: (fileKey) {
              context.read<UpdateProfileCubit>().updateKycDocKey(fileKey, 1);
            },
            imageFileKey: state.kycDocsKey.lastOrNull ?? "",
            uploadPurpose: "verificationDocument",
          ),
        ],
      ),
    );
  }
}
