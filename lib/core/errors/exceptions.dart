class CustomException implements Exception {
  final String messageKey;
  CustomException({required this.messageKey});

  @override
  String toString() => messageKey;
}
