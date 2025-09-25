// import 'package:flutter/material.dart';
// import 'package:zavona_flutter_app/presentation/parking/widgets/parking_spot_tile.dart';

// class ParkinSpotsListWidget extends StatelessWidget {
//   const ParkinSpotsListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       clipBehavior: Clip.none,
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       separatorBuilder: (context, index) {
//         return SizedBox(height: 12);
//       },
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 4,
//       itemBuilder: (context, index) {
//         return const ParkingSpotTile();
//       },
//     );
//   }
// }