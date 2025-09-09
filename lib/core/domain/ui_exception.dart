class UIException implements Exception {
  final String message;
  final String? code;
  UIException(this.message, [this.code]);

  @override
  String toString() => 'UIException: $message (code: $code)';
}
