import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/confirmation_dailog.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form_widget.dart';

class ParkingCreatePage extends StatelessWidget {
  const ParkingCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParkingFormCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "List Parking Spot",
          leadingIcon: FontAwesomeIcons.xmark,
          onLeadingTap: () async {
            var res = await showDialog(
              context: context,
              builder: (_) => ConfirmationDialog(
                confirmationMessage:
                    "Are you sure you want to discard this parking spot?",
              ),
            );
            if (res ?? false) {
              Navigator.pop(context);
            }
          },
        ),
        body: ParkingFormWidget(),
      ),
    );
  }
}
