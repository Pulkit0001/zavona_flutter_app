import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_toggle_bar.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_cubit.dart';
import 'package:zavona_flutter_app/presentation/profile/bloc/update_profile_state.dart';
import 'package:zavona_flutter_app/presentation/profile/pages/profile_page.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
    _updateProfileCubit.close();
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
                  title: (appState.user?.profileCompletion?.required ?? false)
                      ? 'Complete Profile'
                      : 'Edit Profile',
                ),
                body: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 24),
                        // Profile Picture Section
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            ProfileAvatarWidget(
                              profileImageUrl:
                                  _updateProfileCubit.currentProfileImage ?? "",
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomTextField(
                                  controller:
                                      _updateProfileCubit.nameController,
                                  onInputActionPressed: () {},
                                  focusNode: FocusNode(),
                                  leadingAsset: FaIcon(
                                    Icons.person_2,
                                    size: 20,
                                    color: AppColors.secondaryDarkBlue,
                                  ),
                                  label: "Full Name",
                                  hint: "Enter your full name",
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  readOnly:
                                      appState.user?.emailVerified ?? false,
                                  controller:
                                      _updateProfileCubit.emailController,
                                  onInputActionPressed: () {},
                                  focusNode: FocusNode(),
                                  leadingAsset: FaIcon(
                                    Icons.email_rounded,
                                    size: 20,
                                    color: AppColors.secondaryDarkBlue,
                                  ),
                                  label: "Email",
                                  hint: "Enter your email address",
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  readOnly:
                                      appState.user?.mobileVerified ?? false,
                                  controller:
                                      _updateProfileCubit.mobileController,
                                  onInputActionPressed: () {},
                                  leadingAsset: FaIcon(
                                    Icons.phone_android_rounded,
                                    size: 20,
                                    color: AppColors.secondaryDarkBlue,
                                  ),
                                  focusNode: FocusNode(),
                                  label: "Mobile Number",
                                  hint: "Enter your mobile number",
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Want to sell/rent your parking?",
                                        style: GoogleFonts.workSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.secondaryDarkBlue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    CustomToggleBar(
                                      onToggle: (value) {
                                        _updateProfileCubit.updateUserRole(
                                          value,
                                        );
                                      },
                                      initialValue:
                                          _updateProfileCubit.isSeller,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        PrimaryButton(
                          isLoading: updateState.isLoading,
                          label: updateState.isLoading
                              ? "Updating..."
                              : "Continue",
                          onPressed: updateState.isLoading
                              ? null
                              : () async {
                                  await _updateProfileCubit.updateProfile();
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
