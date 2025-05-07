import 'package:appointify_app/features/auth/domain/repos/auth_repo.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/signin_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/get_it_service.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key, this.credentials});

  static const String routeName = '/signIn';
  final Map<String, String>? credentials;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(
        getIt.get<AuthRepo>(),
      ),
      child: Scaffold(
        appBar: buildAppBar(context, title: 'Sign In' , showSettingsButton: false, showBackButton: false),
        body: SignInViewBodyBlocConsumer(credentials: credentials),
      ),
    );
  }
}