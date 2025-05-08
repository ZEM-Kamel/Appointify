import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

/// Handles deep links for the Appointify app, particularly for password reset.
class DeepLinkHandler {
  static StreamSubscription<PendingDynamicLinkData>? _dynamicLinkSubscription;
  static final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  /// Initialize deep link handling.
  static Future<void> initDeepLinks(BuildContext context) async {
    // Handle links that opened the app
    final PendingDynamicLinkData? initialLink = await _dynamicLinks.getInitialLink();
    _handleDeepLink(initialLink, context);

    // Handle links that are received while the app is running
    _dynamicLinkSubscription = _dynamicLinks.onLink.listen(
      (dynamicLinkData) {
        _handleDeepLink(dynamicLinkData, context);
      },
    );
  }

  /// Handle the deep link data.
  static void _handleDeepLink(PendingDynamicLinkData? data, BuildContext context) async {
    if (data == null) return;

    final Uri deepLink = data.link;
    
    // Check if this is a password reset link
    if (deepLink.path.contains('reset-password')) {
      final code = _extractCodeFromUri(deepLink);
      if (code != null) {
        // Verify the code is valid
        try {
          await FirebaseAuth.instance.verifyPasswordResetCode(code);
          
          // // Navigate to password reset view
          // Navigator.of(context, rootNavigator: true).pushNamed(
          //   NewPasswordView.routeName,
          //   arguments: code
          // );
        } catch (e) {
          print('Invalid password reset code: $e');
          // Show error message or navigate to error screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset link is invalid or has expired'))
          );
        }
      }
    }
  }

  /// Extract the reset code from the URI.
  static String? _extractCodeFromUri(Uri uri) {
    // Check query parameters for 'oobCode' which Firebase uses for password reset
    if (uri.queryParameters.containsKey('oobCode')) {
      return uri.queryParameters['oobCode'];
    }
    return null;
  }

  /// Clean up subscriptions.
  static void dispose() {
    _dynamicLinkSubscription?.cancel();
  }
}
