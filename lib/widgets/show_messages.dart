import 'package:flutter/material.dart';

///
///
///
void showSuccessMessage(
  BuildContext context,
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(context);
  s.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[400],
    ),
  );
}

///
///
///
void showErrorMessage(
  BuildContext context,
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final appTheme = Theme.of(context);
  final s = messengerState ?? ScaffoldMessenger.of(context);
  s.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: appTheme.textTheme.bodyMedium?.copyWith(
          color: Color(0xFFFFFFFF),
        ),
      ),
      backgroundColor: Colors.red[400],
    ),
  );
}
