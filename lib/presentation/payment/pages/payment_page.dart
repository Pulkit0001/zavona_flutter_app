import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/payment_models.dart';
import '../../../third_party_services/razorpay_payment_service.dart';
import '../cubit/payment_cubit.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;
  final double amount; // Amount in rupees
  final String userEmail;
  final String userPhone;
  final String userName;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailed;

  const PaymentPage({
    Key? key,
    required this.bookingId,
    required this.amount,
    required this.userEmail,
    required this.userPhone,
    required this.userName,
    this.onPaymentSuccess,
    this.onPaymentFailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(RazorpayPaymentService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<PaymentCubit, PaymentStatus>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment successful!'),
                  backgroundColor: Colors.green,
                ),
              );
              onPaymentSuccess?.call();
              Navigator.of(context).pop(true);
            } else if (state is PaymentFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment failed: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
              onPaymentFailed?.call();
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Booking ID', bookingId),
                          _buildDetailRow(
                            'Amount',
                            '₹${amount.toStringAsFixed(2)}',
                          ),
                          _buildDetailRow('Email', userEmail),
                          _buildDetailRow('Phone', userPhone),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state is PaymentProcessing)
                    const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Processing payment...'),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is PaymentProcessing
                            ? null
                            : () => _initiatePayment(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Pay ₹${amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (state is PaymentFailed)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.error, color: Colors.red.shade600),
                              const SizedBox(width: 8),
                              Text(
                                'Payment Failed',
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.error,
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _initiatePayment(BuildContext context) {
    final paymentRequest = PaymentRequest(
      bookingId: bookingId,
      amount: (amount * 100).toInt(), // Convert to paise
      currency: 'INR',
      userEmail: userEmail,
      userPhone: userPhone,
      userName: userName,
      description: 'Parking booking payment for $bookingId',
    );

    context.read<PaymentCubit>().processPayment(paymentRequest);
  }
}
