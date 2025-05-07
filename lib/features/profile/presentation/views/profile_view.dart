import 'package:appointify_app/core/helper_functions/get_user.dart';
import 'package:appointify_app/core/theme/theme_provider.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_images.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/features/appointments/presentation/views/appointments_list_screen.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:appointify_app/features/auth/presentation/views/signin_view.dart';
import 'package:appointify_app/features/settings/presentation/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signInCubit = context.read<SignInCubit>();
    
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInView.routeName,
            (route) => false,
          );
        } else if (state is SignOutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout Failed: ${state.message}'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: buildAppBar(
          context,
          title: 'Profile',
          showSettingsButton: false,
          showBackButton: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Image.asset(Assets.imagesProfileImage),
              ).animate().fadeIn().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 16),
              Text(
                getUser()!.name,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
              const SizedBox(height: 4),
              Text(
                getUser()!.email,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
              const SizedBox(height: 32),
              _buildProfileMenu(context),
              const SizedBox(height: 32),
              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  return OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Logout',
                              style: theme.textTheme.titleLarge,
                            ),
                            content: Text(
                              'Are You Sure You Want To Logout?',
                              style: theme.textTheme.bodyMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  signInCubit.signOut();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onError,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
                                  ),
                                ),
                                child: Text(
                                  'Logout',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onError,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      'Logout',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
                      ),
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 700));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        _buildProfileMenuItem(
          context,
          title: 'My Appointments',
          icon: Icons.calendar_today,
          onTap: () {
            Navigator.pushNamed(context, AppointmentsListScreen.routeName);
          },
          delay: 400,
        ),
        _buildProfileMenuItem(
          context,
          title: 'Settings',
          icon: Icons.settings,
          onTap: () {
            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
          delay: 500,
        ),
        _buildProfileMenuItem(
          context,
          title: 'Help & Support',
          icon: Icons.help_outline,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('This Feature Is Coming Soon'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          },
          delay: 600,
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required int delay,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
      elevation: ThemeConstants.cardElevation,
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
        onTap: onTap,
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay));
  }
} 