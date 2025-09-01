import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class ParkingFormStepperWidget extends StatelessWidget {
  const ParkingFormStepperWidget({super.key, required this.currentStep});

  final int currentStep;

  static const List<String> stepLabels = [
    'Location/\nAddress',
    'Parking\nSize',
    'Upload\nDocuments',
    'Pricing',
  ]; // Change this value to set the current step

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyMedium: GoogleFonts.workSans(
            color: AppColors.secondaryDarkBlue,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: EasyStepper(
          showScrollbar: false,
          showStepBorder: false,
          activeStep: currentStep,
          internalPadding: 0,
          lineStyle: LineStyle(
            lineType: LineType.normal,
            lineLength: (MediaQuery.of(context).size.width - 180) / 3,
            lineThickness: 2,
            unreachedLineColor: Color(0xFF111827).withValues(alpha: 0.25),
            finishedLineColor: AppColors.secondaryDarkBlue,
            activeLineColor: AppColors.secondaryDarkBlue,
          ),
          stepShape: StepShape.circle,
          stepRadius: 14,
          unreachedStepTextColor: AppColors.secondaryDarkBlue,
          activeStepTextColor: AppColors.secondaryDarkBlue,
          finishedStepTextColor:AppColors.secondaryDarkBlue,
          showLoadingAnimation: false,
          steps: [
            buildCustomStep(0),
            buildCustomStep(1),
            buildCustomStep(2),
            buildCustomStep(3),
          ],
        ),
      ),
    );
  }

  EasyStep buildCustomStep(int stepIndex) {
    return EasyStep(
      customStep: Container(
        decoration: BoxDecoration(
          color: currentStep < stepIndex
              ? Color(0xFF111827).withValues(alpha: 0.25)
              : AppColors.secondaryDarkBlue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF111827).withValues(alpha: 0.25),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            (stepIndex + 1).toString(),
            style: GoogleFonts.mulish(
              color: Colors.white,
              height: 1,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: stepLabels[stepIndex],
    );
  }
}
