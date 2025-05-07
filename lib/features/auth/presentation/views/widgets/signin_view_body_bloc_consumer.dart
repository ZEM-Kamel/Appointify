import 'package:appointify_app/core/helper_functions/build_error_bar.dart';
import 'package:appointify_app/core/widgets/custom_progress_hud.dart';
import 'package:appointify_app/features/home/presentation/views/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/signin_cubit/signin_cubit.dart';
import 'signin_view_body.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({
    super.key,
    this.credentials,
  });

  final Map<String, String>? credentials;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.pushNamed(context, MainLayout.routeName);
        }

        if (state is SignInFailure) {
          showBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is SignInLoading ? true : false,
          child: SignInViewBody(credentials: credentials),
        );
      },
    );
  }
}