import 'package:appointify_app/core/services/custom_bloc_observer.dart';
import 'package:appointify_app/core/services/deep_link_handler.dart';
import 'package:appointify_app/core/services/firebase_service.dart';
import 'package:appointify_app/core/services/get_it_service.dart';
import 'package:appointify_app/core/services/navigation_service.dart';
import 'package:appointify_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/helper_functions/on_generate_routes.dart';
import 'core/services/shared_preferences_singleton.dart';
import 'features/splash/presentation/views/splash_view.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/core/services/notification_service.dart';
import 'package:appointify_app/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:appointify_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Migrate mock data to Firebase (run this only once)
    await FirebaseService.migrateMockData();
    
    // Initialize other services
    await Prefs.init();

    // Setup dependency injection and bloc observer
    setupGetIt();
    Bloc.observer = CustomBlocObserver();

    // Initialize notification service
    await NotificationService().initialize();

    runApp(const AppointifyApp());
  } catch (e) {
    print('Error initializing app: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class AppointifyApp extends StatefulWidget {
  const AppointifyApp({super.key});

  @override
  State<AppointifyApp> createState() => _AppointifyAppState();
}

class _AppointifyAppState extends State<AppointifyApp> with WidgetsBindingObserver {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeProvider = ThemeProvider();
    
    // Initialize deep link handler after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkHandler.initDeepLinks(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    DeepLinkHandler.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _themeProvider.updateSystemTheme(WidgetsBinding.instance.window.platformBrightness);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return BlocProvider(
            create: (context) => getIt<AppointmentBloc>(),
            child: MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              title: 'Appointify',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              onGenerateRoute: AppRoutes().onGenerateRoutes,
              initialRoute: SplashView.routeName,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}