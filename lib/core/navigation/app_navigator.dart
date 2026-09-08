import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static Future<T?> push<T>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  static void pop<T>(
      BuildContext context, [
        T? result,
      ]) {
    Navigator.pop(context, result);
  }

  static Future<T?> pushReplacement<T, TO>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }
}