import 'package:appointify_app/core/helper_functions/on_generate_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:appointify_app/features/settings/presentation/views/settings_screen.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';

import '../utils/app_images.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: ShapeDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(
          Icons.settings_outlined,
          color: theme.colorScheme.primary,
        ),
        onPressed: () {
          Navigator.pushNamed(context, SettingsScreen.routeName);
        },
      ),
    );
  }
}