import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:services_package/Interfaces/front_helper_services/imessage_helper_service.dart';

class ExceptionHelperService implements IMessengerHelperService {
  ExceptionHelperService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> sendError(
    Object sender,
    dynamic ex,
    String message, {
    BuildContext? context,
  }) async {
    // نمایش اسنک‌بار به کاربر
    if (context != null) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('$message: ${ex.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    // همچنین در کنسول لاگ کنیم
    developer.log('Error shown to user: $message', error: ex);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? message,
    BuildContext? context,
  }) async {
    // اینجا می‌توانید خطا را به سرویس خارجی مانند Firebase Crashlytics ارسال کنید
    developer.log(
      'Error recorded: ${context ?? 'No Context'}',
      error: exception,
      stackTrace: stack,
    );
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    developer.log(
      'Flutter Error recorded',
      error: details.exception,
      stackTrace: details.stack,
    );
  }
}
