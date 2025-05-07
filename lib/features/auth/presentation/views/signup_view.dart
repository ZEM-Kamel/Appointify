import 'package:appointify_app/core/services/get_it_service.dart';
import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'widgets/signup_view_body_bloc_consumer.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  static const String routeName = '/signUp';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        getIt<AuthRepo>(),
      ),
      child: Scaffold(
        appBar: buildAppBar(context, title: 'New Account' , showSettingsButton: false),
        body: const SignupViewBodyBlocConsumer(),
      ),
    );
  }
}
