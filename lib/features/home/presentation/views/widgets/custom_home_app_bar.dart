import 'package:appointify_app/core/helper_functions/get_user.dart';
import 'package:appointify_app/core/utils/app_images.dart';
import 'package:appointify_app/core/widgets/settings_widget.dart';
import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      trailing: const SettingsWidget(),
      leading: Image.asset(Assets.imagesProfileImage),
      title: Text(
        'Welcome',
        textAlign: TextAlign.right,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      subtitle: Text(
        getUser()!.name,
        textAlign: TextAlign.right,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
