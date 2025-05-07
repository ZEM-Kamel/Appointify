import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/core/widgets/settings_widget.dart';
import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';

AppBar buildAppBar(BuildContext context,
    {required String title,
    bool showBackButton = true,
    bool showSettingsButton = true}) {
  final theme = Theme.of(context);
  
  return AppBar(
    backgroundColor: theme.colorScheme.surface,
    elevation: ThemeConstants.appBarElevation,
    actions: [
      Visibility(
        visible: showSettingsButton,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SettingsWidget(),
        ),
      )
    ],
    leading: Visibility(
      visible: showBackButton,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Icon(
          Icons.arrow_back_ios_new,
          color: theme.colorScheme.onSurface,
        ),
      ),
    ),
    centerTitle: true,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: ThemeConstants.appBarTitleStyle.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    ),
  );
}