import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_text_field.dart';
import 'package:zavona_flutter_app/presentation/home/pages/home_page.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';
import '../../../core/router/route_names.dart';

class MobileEmailPage extends StatefulWidget {
  const MobileEmailPage({super.key});

  @override
  State<MobileEmailPage> createState() => _MobileEmailPageState();
}

class _MobileEmailPageState extends State<MobileEmailPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final inputController = TextEditingController();
  bool _isPhoneAuth = true;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void _proceedToOtp() {
    if (_formKey.currentState!.validate()) {
      final credential = _isPhoneAuth
          ? inputController.text
          : inputController.text;
      if (credential.isEmpty) {
        MessageUtils.showErrorMessage(
          'Please enter a valid ${_isPhoneAuth ? "phone number" : "email"}',
        );
        return;
      } else if (_isPhoneAuth &&
          !RegExp(r'^\+?[0-9]{7,15}$').hasMatch(credential)) {
        MessageUtils.showErrorMessage('Please enter a valid phone number');
        return;
      } else if (!_isPhoneAuth &&
          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(credential)) {
        MessageUtils.showErrorMessage('Please enter a valid email address');
        return;
      }

      var extra = {
        'identifier': credential,
        'identifierType': _isPhoneAuth ? 'phone' : 'email',
      };
      FocusManager.instance.primaryFocus?.unfocus();
      inputController.clear();
      context.pushNamed(RouteNames.otpVerify, extra: extra);
      MessageUtils.showSuccessMessage("OTP sent successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Center(
                        child: Hero(
                          tag: 'app_logo',
                          child: Image.asset(
                            "assets/images/login_illustration.png",
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                        ),
                      ),
                    ),
                    // White rounded container for login
                    Container(
                      transform: Matrix4.translationValues(0, -20, 0),
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
                          Text(
                            "Welcome!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mulish(
                              color: Color(0xff111827),
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Login to continue",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.workSans(
                              color: Color(0xff1E293B),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Toggle Buttons (Email / Mobile)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xfffffff8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryYellow,
                                width: 0.5,
                              ),
                            ),
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: [
                                    Color(0xffFFD700),
                                    Color(0xffFFC107),
                                  ],
                                ),
                              ),
                              labelColor: AppColors.secondaryDarkBlue,
                              unselectedLabelColor: Colors.black,
                              tabs: const [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email_outlined, size: 20),
                                      SizedBox(width: 4),
                                      Text("Email"),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone_android, size: 20),
                                      SizedBox(width: 4),

                                      Text("Mobile Number"),
                                    ],
                                  ),
                                ),
                              ],
                              controller: TabController(
                                length: 2,
                                vsync: this,
                                initialIndex: _isPhoneAuth ? 1 : 0,
                              ),
                              onTap: (index) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                inputController.clear();
                                setState(() {
                                  _isPhoneAuth = index == 1;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 48),
                          _isPhoneAuth
                              ? CustomTextField(
                                  leadingIcon: Icons.phone_android,
                                  controller: inputController,
                                  inputType: TextInputType.number,
                                  onInputActionPressed: _proceedToOtp,
                                  focusNode: FocusNode(),
                                  label: "Mobile Number",
                                  hint: "Please enter your mobile number",
                                )
                              : CustomTextField(
                                  leadingIcon: Icons.email,
                                  controller: inputController,
                                  inputType: TextInputType.emailAddress,
                                  onInputActionPressed: _proceedToOtp,
                                  focusNode: FocusNode(),
                                  label: "Email",
                                  hint: "Please enter your mobile number",
                                ),

                          const SizedBox(height: 20),

                          // Continue Button
                          PrimaryButton(
                            label: "Continue",
                            onPressed: _proceedToOtp,
                          ),

                          const SizedBox(height: 20),
                          const Text("OR", textAlign: TextAlign.center),

                          const SizedBox(height: 15),

                          // Social Login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xfffffff8),
                                    border: Border.all(
                                      color: AppColors.primaryYellow,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/google.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xfffffff8),
                                    border: Border.all(
                                      color: AppColors.primaryYellow,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/apple.png",
                                    width: 40,
                                    height: 40,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
