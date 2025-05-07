import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/features/home/presentation/cubits/main_layout_cubit/main_layout_cubit.dart';
import 'package:appointify_app/features/home/presentation/cubits/main_layout_cubit/main_layout_state.dart';
import 'package:appointify_app/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: const HomeViewBody(),
        );
      },
    );
  }
} 