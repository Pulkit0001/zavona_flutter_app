import 'package:flutter/material.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_outlined_button.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/address_section_form.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/create_parking_stepper.dart';

class ParkingFormWidget extends StatefulWidget {
  const ParkingFormWidget({super.key});

  @override
  State<ParkingFormWidget> createState() => _ParkingFormWidgetState();
}

class _ParkingFormWidgetState extends State<ParkingFormWidget> {
  int currentStep = 0;

  void goToNextStep() {
    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Stepper to identify the steps
        ParkingFormStepperWidget(currentStep: currentStep),
        SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IndexedStack(children: [AddressSectionForm()]),
          ),
        ),
        SizedBox(height: 20),
        SafeArea(
          bottom: true,
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: SecondaryButton(
                      label: "Back",
                      leadingIcon: CustomIcons.leftArrowIcon(16, 16),
                      onPressed: goToPreviousStep,
                      size: ButtonSize.regular,
                    ),
                  ),
                if (currentStep > 0) SizedBox(width: 14),
                if (currentStep < 4)
                  Expanded(
                    child: PrimaryButton(
                      label: "Next",
                      onPressed: goToNextStep,
                      size: ButtonSize.regular,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
