class PaymentRequest {
  final String bookingId;
  final int amount; // Amount in paise
  final String currency;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String? description;

  const PaymentRequest({
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.userEmail,
    required this.userPhone,
    required this.userName,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'amount': amount,
    'currency': currency,
    'userEmail': userEmail,
    'userPhone': userPhone,
    'userName': userName,
    'description': description,
  };

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
    bookingId: json['bookingId'],
    amount: json['amount'],
    currency: json['currency'],
    userEmail: json['userEmail'],
    userPhone: json['userPhone'],
    userName: json['userName'],
    description: json['description'],
  );
}

class PaymentResponse {
  final String paymentId;
  final String bookingId;
  final String status;
  final int amount;
  final DateTime timestamp;
  final String? razorpayOrderId;
  final String? razorpaySignature;

  const PaymentResponse({
    required this.paymentId,
    required this.bookingId,
    required this.status,
    required this.amount,
    required this.timestamp,
    this.razorpayOrderId,
    this.razorpaySignature,
  });

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'bookingId': bookingId,
    'status': status,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'razorpayOrderId': razorpayOrderId,
    'razorpaySignature': razorpaySignature,
  };

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        paymentId: json['paymentId'],
        bookingId: json['bookingId'],
        status: json['status'],
        amount: json['amount'],
        timestamp: DateTime.parse(json['timestamp']),
        razorpayOrderId: json['razorpayOrderId'],
        razorpaySignature: json['razorpaySignature'],
      );
}

abstract class PaymentStatus {
  const PaymentStatus();
}

class PaymentPending extends PaymentStatus {
  const PaymentPending();
}

class PaymentProcessing extends PaymentStatus {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentStatus {
  final String paymentId;
  const PaymentSuccess(this.paymentId);
}

class PaymentFailed extends PaymentStatus {
  final String error;
  const PaymentFailed(this.error);
}

class PaymentCancelled extends PaymentStatus {
  const PaymentCancelled();
}
