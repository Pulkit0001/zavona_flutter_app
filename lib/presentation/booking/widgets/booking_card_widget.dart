import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/models/bookings/get_rental_bookings_list_response.dart';
import 'package:zavona_flutter_app/presentation/app/bloc/app_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/bloc/bookings_list/booking_list_cubit.dart';
import 'package:zavona_flutter_app/presentation/booking/widgets/booking_action_button_widget.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_primary_button.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';

class BookingCardWidget extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCheckInPressed;

  const BookingCardWidget({
    super.key,
    required this.booking,
    this.onCheckInPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getBookingStatusInfo(booking.status);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: statusInfo.borderColor, width: 1.5),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Parking space image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: booking.parkingSpace?.thumbnailUrl != null
                        ? Image.network(
                            '${NetworkConstants.bucketBaseUrl}/${booking.parkingSpace!.thumbnailUrl!}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_parking,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.local_parking,
                            size: 40,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Booking details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parking spot and status
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Text(
                                    booking.parkingSpot?.parkingNumber ?? 'N/A',
                                    style: GoogleFonts.workSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: context.onSurfaceColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                CustomIcons.verifiedGreenIcon(16, 16),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (booking.status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusInfo.backgroundColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusInfo.icon,
                                    size: 12,
                                    color: statusInfo.iconColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusInfo.displayText,
                                    style: TextStyle(
                                      color: statusInfo.textColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      // Renter info
                      Text(
                        'Booking By: ${booking.renter?.name ?? 'Unknown'}',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          color: context.onSurfaceColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      // Check-in date and time
                      Text(
                        _formatDateTime(booking.checkInDateTime),
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          color: context.onSurfaceColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Check-in button
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: BookingActionButtonWidget(
                booking: booking,
                currentUserRole:
                    booking.owner?.id == context.read<AppCubit>().state.user?.id
                    ? UserRole.owner
                    : UserRole.renter,
                onActionCompleted: () {
                  context.read<BookingListCubit>().refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BookingStatusInfo _getBookingStatusInfo(String? status) {
    if (status == null) {
      return BookingStatusInfo(
        backgroundColor: Colors.grey.shade400,
        borderColor: Colors.grey.shade300,
        textColor: Colors.white,
        iconColor: Colors.white,
        icon: Icons.help_outline,
        displayText: 'Unknown',
      );
    }

    switch (status.toLowerCase()) {
      case 'pending_confirmation':
        return BookingStatusInfo(
          backgroundColor: Colors.orange.shade400,
          borderColor: Colors.orange.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.schedule,
          displayText: 'Pending',
        );
      case 'confirmed':
        return BookingStatusInfo(
          backgroundColor: Colors.green.shade500,
          borderColor: Colors.green.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.check_circle,
          displayText: 'Confirmed',
        );
      case 'payment_completed':
        return BookingStatusInfo(
          backgroundColor: Colors.blue.shade500,
          borderColor: Colors.blue.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.payment,
          displayText: 'Paid',
        );
      case 'checked_in':
        return BookingStatusInfo(
          backgroundColor: Colors.purple.shade500,
          borderColor: Colors.purple.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.login,
          displayText: 'Checked In',
        );
      case 'checked_out':
        return BookingStatusInfo(
          backgroundColor: Colors.indigo.shade500,
          borderColor: Colors.indigo.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.logout,
          displayText: 'Checked Out',
        );
      case 'completed':
        return BookingStatusInfo(
          backgroundColor: Colors.teal.shade500,
          borderColor: Colors.teal.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.check_circle_outline,
          displayText: 'Completed',
        );
      case 'rejected':
        return BookingStatusInfo(
          backgroundColor: Colors.red.shade500,
          borderColor: Colors.red.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.cancel,
          displayText: 'Rejected',
        );
      case 'cancelled':
        return BookingStatusInfo(
          backgroundColor: Colors.red.shade400,
          borderColor: Colors.red.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.close,
          displayText: 'Cancelled',
        );
      case 'expired':
        return BookingStatusInfo(
          backgroundColor: Colors.grey.shade600,
          borderColor: Colors.grey.shade400,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.access_time,
          displayText: 'Expired',
        );
      default:
        return BookingStatusInfo(
          backgroundColor: Colors.grey.shade400,
          borderColor: Colors.grey.shade300,
          textColor: Colors.white,
          iconColor: Colors.white,
          icon: Icons.help_outline,
          displayText: status,
        );
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No date';

    final formatter = DateFormat('MMM dd, yy, h:mm a');
    return formatter.format(dateTime);
  }
}

class BookingStatusInfo {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;
  final String displayText;

  const BookingStatusInfo({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
    required this.displayText,
  });
}
