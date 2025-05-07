import 'package:appointify_app/core/helper_functions/build_error_bar.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signup_cubit/signup_state.dart';
import 'package:appointify_app/features/auth/presentation/views/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'signup_view_body.dart';

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInView(
                credentials: {
                  'email': state.userEntity.email,
                },
              ),
            ),
          );
        }
        if (state is SignupFailure) {
          showBar(context, state.message);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupLoading ? true : false,
          child: const SignUpViewBody(),
        );
      },
    );
  }
}