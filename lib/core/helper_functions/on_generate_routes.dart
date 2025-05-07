import 'package:appointify_app/core/services/get_it_service.dart';
import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/auth/presentation/cubits/password_reset_cubit/password_reset_cubit.dart';
import 'package:appointify_app/features/profile/presentation/cubits/profile_edit_cubit/profile_edit_cubit.dart';
import 'package:appointify_app/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/forgot_password_view.dart';
import 'package:appointify_app/features/auth/presentation/views/signin_view.dart';
import 'package:appointify_app/features/auth/presentation/views/signup_view.dart';
import 'package:appointify_app/features/home/presentation/views/main_layout.dart';
import 'package:appointify_app/features/on_boarding/on_boarding_view.dart';
import 'package:appointify_app/features/settings/presentation/views/settings_screen.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialist_details_screen.dart';
import 'package:appointify_app/features/specialists/presentation/views/specialists_list_screen.dart';
import 'package:appointify_app/features/search/presentation/views/search_results_screen.dart';
import 'package:appointify_app/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/features/appointments/presentation/views/widgets/appointment_booking_screen.dart';
import 'package:appointify_app/features/appointments/presentation/views/appointments_list_screen.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';

/// A class that manages all the routes in the application.
class AppRoutes {
  /// Generates routes based on the provided settings.
  Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      // Authentication Routes
      case SplashView.routeName:
        return _buildRoute(const SplashView(), settings);
      case OnBoardingView.routeName:
        return _buildRoute(const OnBoardingView(), settings);
      case SignInView.routeName:
        return _buildRoute(const SignInView(), settings);
      case SignUpView.routeName:
        return _buildRoute(const SignUpView(), settings);
      case ForgotPasswordFlow.routeName:
        return _buildRoute(const ForgotPasswordFlow(), settings);

      // Main App Routes
      case MainLayout.routeName:
        return _buildRoute(const MainLayout(), settings);
      case SpecialistsListScreen.routeName:
        final category = settings.arguments as String;
        return _buildRoute(
          SpecialistsListScreen(category: category),
          settings,
        );
      case SpecialistDetailsScreen.routeName:
        final specialist = settings.arguments as SpecialistEntity;
        return _buildRoute(
          SpecialistDetailsScreen(),
          settings,
        );
      case SearchResultsScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          SearchResultsScreen(
            specialists: args['specialists'] as List<SpecialistEntity>,
            searchQuery: args['searchQuery'] as String,
          ),
          settings,
        );
      case AppointmentBookingScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          BlocProvider(
            create: (context) => getIt<AppointmentBloc>(),
            child: AppointmentBookingScreen(
              specialist: args['specialist'] as SpecialistEntity,
              appointmentToReschedule: args['appointmentToReschedule'] as AppointmentEntity?,
            ),
          ),
          settings,
        );
      case AppointmentsListScreen.routeName:
        return _buildRoute(
          BlocProvider(
            create: (context) => getIt<AppointmentBloc>(),
            child: const AppointmentsListScreen(),
          ),
          settings,
        );

      case SettingsScreen.routeName:
        return _buildRoute(const SettingsScreen(), settings);

      case EditProfileScreen.routeName:
        return _buildRoute(
          BlocProvider(
            create: (context) => ProfileEditCubit(authRepo: getIt<AuthRepo>()),
            child: const EditProfileScreen(),
          ),
          settings,
        );

      // Default Route
      default:
        return _buildRoute(
          const Scaffold(),
          settings,
        );
    }
  }

  /// Builds a custom page route with a slide transition animation.
  static PageRoute _buildRoute(Widget widget, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

/// A widget that manages the password reset flow navigation.
class ForgotPasswordFlow extends StatelessWidget {
  const ForgotPasswordFlow({super.key, this.showAppBar = true});

  /// Whether to show app bar in the forgot password views
  final bool showAppBar;
  
  static const String routeName = '/forgotPasswordFlow';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordResetCubit(getIt.get<AuthRepo>()),
      child: Navigator(
        initialRoute: ForgotPasswordView.routeName,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  /// Generates routes for the password reset flow.
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final page = _getPageForRoute(settings.name);
    return MaterialPageRoute(builder: (_) => page);
  }

  /// Returns the appropriate widget for the given route name.
  Widget _getPageForRoute(String? routeName) {
    switch (routeName) {
      case ForgotPasswordView.routeName:
        return ForgotPasswordView(showAppBar: showAppBar);
      // case PasswordRecoveryView.routeName:
      //   return const PasswordRecoveryView();
      // case NewPasswordView.routeName:
      //   return const NewPasswordView();
      default:
        return ForgotPasswordView(showAppBar: showAppBar);
    }
  }
}
