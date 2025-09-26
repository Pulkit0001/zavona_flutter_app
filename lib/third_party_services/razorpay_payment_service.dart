import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RazorpayPaymentService {
  static final RazorpayPaymentService _instance =
      RazorpayPaymentService._internal();
  factory RazorpayPaymentService() => _instance;
  RazorpayPaymentService._internal();

  late Razorpay _razorpay;
  Function(String)? _onPaymentSuccess;
  Function(String)? _onPaymentError;
  Function()? _onPaymentWallet;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  /// Initiates payment with Razorpay
  ///
  /// [amount] - Amount in paise (multiply by 100 for rupees)
  /// [bookingId] - Unique booking identifier
  /// [userEmail] - User's email address
  /// [userPhone] - User's phone number
  /// [userName] - User's name
  /// [onSuccess] - Callback for successful payment
  /// [onError] - Callback for payment failure
  /// [onWallet] - Callback for external wallet selection
  void startPayment({
    required int amount,
    required String bookingId,
    required String userEmail,
    required String userPhone,
    required String userName,
    Function(String paymentId)? onSuccess,
    Function(String error)? onError,
    Function()? onWallet,
  }) {
    _onPaymentSuccess = onSuccess;
    _onPaymentError = onError;
    _onPaymentWallet = onWallet;

    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
      'amount': amount, // Amount in paise
      'name': 'Zavona Parking',
      'description': 'Parking Booking Payment - $bookingId',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
      'external': {
        'wallets': ['paytm'],
      },
      'order_id':
          bookingId, // This should be order ID from Razorpay if you're using orders API
      'theme': {'color': '#3399cc'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      _showToast('Payment initialization failed');
      _onPaymentError?.call('Payment initialization failed: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    _showToast('Payment Successful!');
    _onPaymentSuccess?.call(response.paymentId ?? '');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    _showToast('Payment Failed: ${response.message}');
    _onPaymentError?.call('${response.code}: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    _showToast('External Wallet Selected: ${response.walletName}');
    _onPaymentWallet?.call();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
