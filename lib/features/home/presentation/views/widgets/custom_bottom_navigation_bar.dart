import 'package:appointify_app/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/features/home/presentation/cubits/main_layout_cubit/main_layout_cubit.dart';
import 'package:appointify_app/features/home/presentation/cubits/main_layout_cubit/main_layout_state.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<MainLayoutCubit>().changePage(index);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.5),
            selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: theme.textTheme.labelSmall,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildAnimatedNavItem(
                context,
                state.currentIndex == 0,
                Assets.imagesNewHome,
                Assets.imagesNewHomeActive,
                'Home',
              ),
              _buildAnimatedNavItem(
                context,
                state.currentIndex == 1,
                Assets.imagesNewCalender,
                Assets.imagesNewCalenderActive,
                'Appointments',
              ),
              _buildAnimatedNavItem(
                context,
                state.currentIndex == 2,
                Assets.imagesNewProfile,
                Assets.imagesNewProfileActive,
                'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildAnimatedNavItem(
    BuildContext context,
    bool isSelected,
    String iconPath,
    String activeIconPath,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Image.asset(
          isSelected ? activeIconPath : iconPath,
          key: ValueKey<bool>(isSelected),
          width: 24,
          height: 24,
        ),
      ),
      label: label,
    );
  }
}