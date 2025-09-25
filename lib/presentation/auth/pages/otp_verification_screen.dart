import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:zavona_flutter_app/core/domain/session_manager.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/core/router/route_names.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/auth/bloc/auth_cubit.dart';
import 'package:zavona_flutter_app/presentation/auth/bloc/auth_state.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.identifier,
    required this.identifierType,
  });

  final String identifier;
  final String identifierType; // 'email' or 'phone'

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  Timer? timer;
  int timeLeftToResend = 30;
  bool isVerifyingOTP = false;

  @override
  void initState() {
    startCountdown();
    super.initState();
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeftToResend > 0) {
        setState(() {
          timeLeftToResend--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _submitOtp() async {
    isVerifyingOTP = true;
    var cubit = context.read<AuthCubit>();
    if (cubit.otpController.text.length == 6) {
      await cubit.verifyOtp(widget.identifier);
    } else {
      MessageUtils.showErrorMessage('Please enter a valid 6-digit OTP');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.eFormState == EFormState.submittingFailed) {
          MessageUtils.showErrorMessage(MessageUtils.defaultErrorMessage);
        } else if (state.eFormState == EFormState.submittingSuccess) {
          if (isVerifyingOTP) {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<AuthCubit>().otpController.clear();
            context.read<AppCubit>().getProfileData();
            MessageUtils.showSuccessMessage("OTP verified successfully!");
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.dashboard);
            }
          } else {
            MessageUtils.showSuccessMessage("OTP sent successfully!");
          }
        }
      },

      builder: (context, state) => Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.75],
              colors: [
                AppColors.secondaryDarkBlue,
                Color(0xFF3D578D), // slightly lighter bottom
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -48,
                left: -78,
                child: Image.asset(
                  "assets/vectors/blue_top_left_vector.png",
                  width: 300,
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // App Logo
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Hero(
                            tag: 'app_logo',
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 48.0),
                              child: Image.asset(
                                "assets/images/otp_verify_illustration.png",
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // White rounded container for login
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              "OTP Verification!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                color: Color(0xff111827),
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "We have sent you an OTP on your ${widget.identifierType == 'email' ? 'email' : 'mobile number'}.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.workSans(
                                color: AppColors.secondaryDarkBlue,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 44),

                            Pinput(
                              controller: context
                                  .read<AuthCubit>()
                                  .otpController,
                              onCompleted: (pin) {
                                _submitOtp();
                              },
                              length: 6,
                              obscureText: true,
                              obscuringCharacter: "\u2022",
                              defaultPinTheme: PinTheme(
                                width: 48,
                                height: 48,
                                textStyle: GoogleFonts.workSans(
                                  fontSize: 18,
                                  color: AppColors.secondaryDarkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFF8),
                                  border: Border.all(
                                    color: AppColors.primaryYellow,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              errorPinTheme: PinTheme(
                                width: 48,
                                height: 48,
                                textStyle: GoogleFonts.workSans(
                                  fontSize: 18,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  border: Border.all(color: AppColors.error),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 44),

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Didn’t receive OTP? ',
                                    style: GoogleFonts.workSans(
                                      color: AppColors.secondaryDarkBlue,
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (timeLeftToResend <= 0) {
                                          isVerifyingOTP = false;
                                          context
                                              .read<AuthCubit>()
                                              .requestOTP();
                                          startCountdown();
                                        }
                                      },
                                    text:
                                        "Resend${timeLeftToResend > 0 ? " in $timeLeftToResend s" : ""}",
                                    style: GoogleFonts.workSans(
                                      color: AppColors.secondaryDarkBlue,
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Continue Button
                            PrimaryButton(
                              isLoading:
                                  state.eFormState == EFormState.submittingForm,
                              label: "Submit",
                              onPressed: _submitOtp,
                            ),
                            const SizedBox(height: 72),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
