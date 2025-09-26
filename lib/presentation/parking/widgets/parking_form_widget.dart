import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_outlined_button.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/presentation/file_upload/bloc/file_uploader_state.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/address_section_form.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/create_parking_stepper.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_docs_section.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_size_selection_widget.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/pricing_section_form.dart';

class ParkingFormWidget extends StatefulWidget {
  const ParkingFormWidget({super.key});

  @override
  State<ParkingFormWidget> createState() => _ParkingFormWidgetState();
}

class _ParkingFormWidgetState extends State<ParkingFormWidget> {
  int currentStep = 0;

  void _handleNextAction() async {
    final cubit = context.read<ParkingFormCubit>();

    if (currentStep == 3) {
      // Final step - submit the form
      ParkingFormHelpers.validateCurrentSection(cubit, currentStep);

      if (ParkingFormHelpers.isCurrentSectionValid(cubit, currentStep)) {
        // All validations passed, submit the form
        cubit.validateAllSections();

        if (cubit.state.isFormValid) {
          var ownerId = context.read<AppCubit>().state.user?.id ?? '';
          if (ownerId.isEmpty) {
            MessageUtils.showErrorMessage(
              "User not logged in. Please log in and try again.",
            );
            return;
          }

          await cubit.createParkingSpace(ownerId);

          // Navigate back or to success page based on result
          if (cubit.state.formState.toString().contains('Success')) {
            Navigator.pop(context, true);
          }
        } else {
          // Show validation errors for all sections
          ParkingFormHelpers.showAllSectionErrors(cubit);
        }
      } else {
        // Show validation errors for current section
        ParkingFormHelpers.showCurrentSectionErrors(cubit, currentStep);
      }
    } else {
      // Not final step - go to next step
      goToNextStep();
    }
  }

  void goToNextStep() {
    final cubit = context.read<ParkingFormCubit>();

    // Validate current section before moving to next
    ParkingFormHelpers.validateCurrentSection(cubit, currentStep);

    // Check if current section is valid before proceeding
    if (ParkingFormHelpers.isCurrentSectionValid(cubit, currentStep)) {
      if (currentStep < 3) {
        setState(() {
          currentStep++;
        });
      }
    } else {
      // Show validation errors for current section
      ParkingFormHelpers.showCurrentSectionErrors(cubit, currentStep);
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
    return BlocBuilder<ParkingFormCubit, ParkingFormState>(
      builder: (context, state) {
        return Column(
          children: [
            /// Stepper to identify the steps
            ParkingFormStepperWidget(currentStep: currentStep),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: IndexedStack(
                    index: currentStep,
                    children: [
                      AddressSectionForm(),
                      ParkingSizeSelection(),
                      ParkingDocsSection(),
                      PricingSectionForm(),
                    ],
                  ),
                ),
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
                    Expanded(
                      child: PrimaryButton(
                        label: ParkingFormHelpers.getNextButtonLabel(
                          currentStep,
                          context.read<ParkingFormCubit>(),
                        ),
                        onPressed: _handleNextAction,
                        size: ButtonSize.regular,
                        isLoading: state.formState.toString().contains(
                          'submittingForm',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class UpdateParkingWidget extends StatefulWidget {
  const UpdateParkingWidget({super.key});

  @override
  State<UpdateParkingWidget> createState() => _UpdateParkingWidgetState();
}

class _UpdateParkingWidgetState extends State<UpdateParkingWidget> {
  void _handleNextAction() async {
    final cubit = context.read<ParkingFormCubit>();

    // All validations passed, submit the form
    cubit.validateAllSections();
    if (cubit.state.isFormValid) {
      var ownerId = context.read<AppCubit>().state.user?.id ?? '';
      if (ownerId.isEmpty) {
        MessageUtils.showErrorMessage(
          "User not logged in. Please log in and try again.",
        );
        return;
      }
      await cubit.updateParkingSpace(ownerId);

      // Navigate back or to success page based on result
      if (cubit.state.formState.toString().contains('Success')) {
        Navigator.pop(context, true);
      }
    } else {
      // Show validation errors for all sections
      ParkingFormHelpers.showAllSectionErrors(cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingFormCubit, ParkingFormState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.formState == EFormState.loadingForm)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 56,
                        width: 56,
                        child: CircularProgressIndicator(
                          color: context.onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Loading Parking Details...",
                        style: GoogleFonts.workSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: 0.0,
                          color: context.onSurfaceColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (state.formState == EFormState.failure)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: context.errorColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? "Failed to load parking details.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        AddressSectionForm(),
                        SizedBox(height: 20),
                        ParkingSizeSelection(),
                        SizedBox(height: 20),
                        ParkingDocsSection(),
                        SizedBox(height: 20),
                        PricingSectionForm(),
                      ],
                    ),
                  ),
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
                    Expanded(
                      child: PrimaryButton(
                        label: "Update",
                        onPressed: _handleNextAction,
                        size: ButtonSize.regular,
                        isLoading: state.formState.toString().contains(
                          'submittingForm',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

abstract class ParkingFormHelpers {
  /// Validate the current section based on currentStep
  static void validateCurrentSection(ParkingFormCubit cubit, int currentStep) {
    switch (currentStep) {
      case 0: // Address section
        cubit.validateAddressSection();
        break;
      case 1: // Parking size section
        cubit.validateParkingSizeSection();
        break;
      case 2: // Docs section
        cubit.validateDocsSection();
        break;
      case 3: // Pricing section
        cubit.validatePricingSection();
        break;
    }
  }

  /// Check if current section is valid
  static bool isCurrentSectionValid(ParkingFormCubit cubit, int currentStep) {
    final state = cubit.state;

    switch (currentStep) {
      case 0: // Address section
        return state.isAddressSectionValid;
      case 1: // Parking size section
        return state.isParkingSizeSectionValid;
      case 2: // Docs section
        return state.isDocsSectionValid;
      case 3: // Pricing section
        return state.isPricingSectionValid;
      default:
        return true;
    }
  }

  /// Show validation errors for the current section
  static void showCurrentSectionErrors(
    ParkingFormCubit cubit,
    int currentStep,
  ) {
    final state = cubit.state;
    final errors = <String>[];
    String sectionName = '';

    switch (currentStep) {
      case 0: // Address section
        sectionName = 'Address Information';
        if (state.fieldErrors['parkingNumber'] != null) {
          errors.add(state.fieldErrors['parkingNumber']!);
        }
        if (state.fieldErrors['societyName'] != null) {
          errors.add(state.fieldErrors['societyName']!);
        }
        if (state.fieldErrors['address'] != null) {
          errors.add(state.fieldErrors['address']!);
        }
        if (state.fieldErrors['location'] != null) {
          errors.add(state.fieldErrors['location']!);
        }
        break;
      case 1: // Parking size section
        sectionName = 'Parking Size';
        if (state.fieldErrors['parkingSize'] != null) {
          errors.add(state.fieldErrors['parkingSize']!);
        }
        break;
      case 2: // Docs section
        sectionName = 'Documents';
        if (state.fieldErrors['thumbnail'] != null) {
          errors.add(state.fieldErrors['thumbnail']!);
        }
        if (state.fieldErrors['documents'] != null) {
          errors.add(state.fieldErrors['documents']!);
        }
        break;
      case 3: // Pricing section
        sectionName = 'Pricing';
        if (state.fieldErrors['pricing'] != null) {
          errors.add(state.fieldErrors['pricing']!);
        }
        break;
    }

    // Show the first error message with section context
    if (errors.isNotEmpty) {
      MessageUtils.showErrorMessage(
        errors.length == 1 ? errors.first : '${errors.first}',
      );
    }
  }

  /// Show validation errors for all sections (used in final submission)
  static void showAllSectionErrors(ParkingFormCubit cubit) {
    final state = cubit.state;
    final allErrors = <String>[];

    // Collect all validation errors
    state.fieldErrors.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        allErrors.add(value);
      }
    });

    if (allErrors.isNotEmpty) {
      if (allErrors.length == 1) {
        // Show single error
        MessageUtils.showErrorMessage(allErrors.first);
      } else {
        // Show summary for multiple errors
        MessageUtils.showErrorMessage(
          'Please fix ${allErrors.length} validation errors to continue',
        );

        // Optionally, you could show the first few errors
        // MessageUtils.showErrorMessage(
        //   'Errors found:\n${allErrors.take(3).join('\n')}'
        // );
      }
    }
  }

  /// Get the appropriate button label for the current step
  static getNextButtonLabel(int currentStep, ParkingFormCubit cubit) {
    if (currentStep == 3) {
      return cubit.parkingSpaceId.isNotEmpty ? "Update" : "Submit";
    }
    return "Next";
  }

  /// Handle the next/submit button action
}
