import 'package:flutter/material.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_horizonatal_list_tile.dart';

class BookingRequestsListWidget extends StatelessWidget {
  const BookingRequestsListWidget({
    super.key,
    this.scrollDirection = Axis.vertical,
  });

  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (context, index) {
        return SizedBox(width: 12);
      },
      shrinkWrap: true,
      scrollDirection: scrollDirection,
      itemCount: 12,
      itemBuilder: (context, index) {
        return const BookingRequestHorizontalTile();
      },
    );
  }
}