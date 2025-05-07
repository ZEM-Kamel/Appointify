import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/features/home/presentation/cubits/main_layout_cubit/main_layout_cubit.dart';
import 'package:appointify_app/features/home/presentation/cubits/main_layout_cubit/main_layout_state.dart';
import 'package:appointify_app/features/home/presentation/views/widgets/home_view.dart';
import 'package:appointify_app/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:appointify_app/features/appointments/presentation/views/appointments_list_screen.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/features/profile/presentation/views/profile_view.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:appointify_app/core/services/get_it_service.dart';

class MainLayout extends StatelessWidget {
  static const String routeName = '/main-layout';

  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainLayoutCubit(),
        ),
        BlocProvider(
          create: (context) => getIt<AppointmentBloc>(),
        ),
        BlocProvider(
          create: (context) => SignInCubit(
            getIt.get<AuthRepo>(),
          ),
        ),
      ],
      child: const MainLayoutView(),
    );
  }
}

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) {
          return _getPage(state.currentIndex);
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const AppointmentsListScreen();
      case 2:
        return const ProfileView();
      default:
        return const HomeView();
    }
  }
}