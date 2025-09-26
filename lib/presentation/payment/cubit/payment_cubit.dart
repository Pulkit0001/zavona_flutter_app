import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/payment_models.dart';
import '../../../third_party_services/razorpay_payment_service.dart';

class PaymentCubit extends Cubit<PaymentStatus> {
  final RazorpayPaymentService _paymentService;

  PaymentCubit(this._paymentService) : super(const PaymentPending());

  /// Initiates payment for a booking
  void processPayment(PaymentRequest request) {
    emit(const PaymentProcessing());

    _paymentService.startPayment(
      amount: request.amount,
      bookingId: request.bookingId,
      userEmail: request.userEmail,
      userPhone: request.userPhone,
      userName: request.userName,
      onSuccess: (paymentId) {
        emit(PaymentSuccess(paymentId));
      },
      onError: (error) {
        emit(PaymentFailed(error));
      },
      onWallet: () {
        // Handle external wallet selection if needed
        emit(const PaymentProcessing());
      },
    );
  }

  /// Resets payment status to pending
  void resetPayment() {
    emit(const PaymentPending());
  }

  /// Cancels current payment
  void cancelPayment() {
    emit(const PaymentCancelled());
  }
}
