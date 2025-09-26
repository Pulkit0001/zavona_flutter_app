import 'package:flutter/material.dart';
import '../pages/payment_page.dart';

class PaymentHelper {
  /// Navigate to payment page for a booking
  static Future<bool?> navigateToPayment(
    BuildContext context, {
    required String bookingId,
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    VoidCallback? onPaymentSuccess,
    VoidCallback? onPaymentFailed,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          bookingId: bookingId,
          amount: amount,
          userEmail: userEmail,
          userPhone: userPhone,
          userName: userName,
          onPaymentSuccess: onPaymentSuccess,
          onPaymentFailed: onPaymentFailed,
        ),
      ),
    );
  }

  /// Show payment dialog as a modal
  static Future<bool?> showPaymentDialog(
    BuildContext context, {
    required String bookingId,
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    VoidCallback? onPaymentSuccess,
    VoidCallback? onPaymentFailed,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: PaymentPage(
            bookingId: bookingId,
            amount: amount,
            userEmail: userEmail,
            userPhone: userPhone,
            userName: userName,
            onPaymentSuccess: () {
              onPaymentSuccess?.call();
              Navigator.of(context).pop(true);
            },
            onPaymentFailed: () {
              onPaymentFailed?.call();
              Navigator.of(context).pop(false);
            },
          ),
        ),
      ),
    );
  }
}
