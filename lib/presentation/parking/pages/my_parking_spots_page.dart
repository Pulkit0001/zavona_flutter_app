import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/parking/parking_list_filter.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_app_bar.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_list/parking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_list_widget.dart';
import '../../../core/router/route_names.dart';

class MyParkingSpotsPage extends StatelessWidget {
  const MyParkingSpotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Parking Spots'),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            BlocProvider(
              create: (context) => ParkingListCubit()
                ..initialize(
                  initialFilter: ParkingListFilter(
                    owner: context.read<AppCubit>().state.user?.id,
                  ),
                ),
              child: ParkingListWidget(
                showFilters: false,
                shrinkWrap: true,
                initialFilter: ParkingListFilter(
                  owner: context.read<AppCubit>().state.user?.id,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.parkingCreate),
        backgroundColor: context.primaryColor,
        child: Icon(Icons.add, color: context.onPrimaryColor),
      ),
    );
  }
}
