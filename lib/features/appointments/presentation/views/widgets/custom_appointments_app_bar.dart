import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/core/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/features/home/presentation/views/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:appointify_app/core/theme/theme_provider.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';

AppBar buildAppBar(
  BuildContext context, {
  required String title,
  bool showBackButton = true,
  bool showSettingsButton = true,
  TabController? tabController,
  bool isAppointmentsList = false,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDarkMode = themeProvider.isDarkMode;
  final primaryColor = themeProvider.primaryColor;
  final accentColor = themeProvider.accentColor;
  final theme = Theme.of(context);

  return AppBar(
    backgroundColor: isDarkMode ? ThemeConstants.darkAppBar : ThemeConstants.lightAppBar,
    elevation: ThemeConstants.appBarElevation,
    bottom: tabController != null
        ? TabBar(
            controller: tabController,
            labelColor: primaryColor,
            unselectedLabelColor: isDarkMode ? ThemeConstants.darkSecondaryText : ThemeConstants.lightSecondaryText,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Passed'),
            ],
          )
        : null,
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
          if (isAppointmentsList) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainLayout.routeName,
              (route) => false,
            );
          } else {
            Navigator.pop(context);
          }
        },
        child: Icon(
          Icons.arrow_back_ios_new,
          color: isDarkMode ? ThemeConstants.darkIcon : ThemeConstants.lightIcon,
        ),
      ),
    ),
    centerTitle: true,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: ThemeConstants.appBarTitleStyle.copyWith(
        color: isDarkMode ? ThemeConstants.darkText : ThemeConstants.lightText,
      ),
    ),
  );
}