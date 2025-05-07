import 'package:appointify_app/core/helper_functions/on_generate_routes.dart';
import 'package:appointify_app/core/theme/theme_provider.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_images.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: buildAppBar(context, title: 'Settings',showSettingsButton: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Appearance'),
          const SizedBox(height: 8),
          _buildThemeSelector(context).animate().fadeIn(),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            icon: Assets.imagesNewProfileActive,
            title: 'Edit Profile Information',
            onTap: () {
              Navigator.pushNamed(context, EditProfileScreen.routeName);
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
          _buildSettingsCard(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              Navigator.pushNamed(
                context, 
                ForgotPasswordFlow.routeName,
                arguments: {"showAppBar": true}
              );
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Notifications'),
          const SizedBox(height: 8),
          _buildSwitchCard(
            context,
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            value: true,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('This Feature Is Coming Soon'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
          _buildSwitchCard(
            context,
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            value: true,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('This Feature Is Coming Soon'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'About'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            icon: Icons.info_outline,
            title: 'App Version',
            trailing: const Text('1.0.0'),
            onTap: () {},
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          _buildSettingsCard(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('This Feature Is Coming Soon'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
          _buildSettingsCard(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('This Feature Is Coming Soon'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Text(
                  'Theme Mode',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context,
                    title: 'Light',
                    icon: Icons.light_mode,
                    isSelected: themeProvider.themeMode == ThemeMode.light,
                    onTap: () {
                      themeProvider.setThemeMode(ThemeMode.light);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    title: 'Dark',
                    icon: Icons.dark_mode,
                    isSelected: themeProvider.themeMode == ThemeMode.dark,
                    onTap: () {
                      themeProvider.setThemeMode(ThemeMode.dark);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    title: 'System',
                    icon: Icons.settings_suggest,
                    isSelected: themeProvider.themeMode == ThemeMode.system,
                    onTap: () {
                      themeProvider.setThemeMode(ThemeMode.system);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    dynamic icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: ListTile(
        leading: icon is IconData
            ? Icon(
                icon,
                color: theme.colorScheme.primary,
              )
            : Image.asset(
                icon as String,
                width: 24,
                height: 24,
              ),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        title: Text(title),
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
} 