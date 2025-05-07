import 'dart:io';
import 'package:appointify_app/constants.dart';
import 'package:appointify_app/core/helper_functions/on_generate_routes.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_images.dart';
import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/core/widgets/custom_text_field.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/forgot_password_view.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/dont_have_account_widget.dart';
import 'package:appointify_app/core/widgets/password_field.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/social_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/signin_cubit/signin_cubit.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key, this.credentials});

  final Map<String, String>? credentials;

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, password;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    
    if (widget.credentials != null) {
      emailController.text = widget.credentials!['email'] ?? '';
      passwordController.text = widget.credentials!['password'] ?? '';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kHorizintalPadding,
        ),
        child: Form(
          key: formKey,
          autovalidateMode: autoValidateMode,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              CustomTextFormField(
                controller: emailController,
                onSaved: (value) {
                  email = value!.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                      .hasMatch(value.trim())) {
                    return 'Invalid email format';
                  }
                  return null;
                },
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._]'))
                ],
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xffC9CECF),
                ),
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
              ),
              const SizedBox(
                height: 16,
              ),
               PasswordField(
                controller: passwordController,
                onSaved: (value) {
                  password = value!;
                },
                prefixIcon: const Icon(
                  Icons.lock_outlined,
                  color: Color(0xffC9CECF),
                ),
              ).animate().fadeIn(
                 duration: const Duration(milliseconds: 600),
                 delay: const Duration(milliseconds: 400),
               ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        ForgotPasswordFlow.routeName,
                        arguments: {"showAppBar": false}
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyles.semiBold13.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 600),
              ),
              const SizedBox(
                height: 33,
              ),
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    context.read<SignInCubit>().signIn(email, password);
                  } else {
                    autoValidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
                text: 'Sign In',
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 800),
              ),
              const SizedBox(
                height: 33,
              ),
              const DontHaveAnAccountWidget().animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 1000),
              ),
              const SizedBox(
                height: 33,
              ),
              const OrDivider().animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 1200),
              ),
              const SizedBox(
                height: 16,
              ),
              SocialSignInButton(
                onPressed: () {
                  context.read<SignInCubit>().signInWithGoogle();
                },
                image: Assets.imagesGoogleIcon,
                title: 'Sign In With Google',
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 1400),
              ),
              const SizedBox(
                height: 16,
              ),
              Platform.isIOS
                  ? Column(
                children: [
                  SocialSignInButton(
                    onPressed: () {
                      context.read<SignInCubit>().signInWithApple();
                    },
                    image: Assets.imagesAppleIcon,
                    title: 'Sign In With Apple',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )
                  : const SizedBox(),
              SocialSignInButton(
                onPressed: () {
                  context.read<SignInCubit>().signInWithFacebook();
                },
                image: Assets.imagesFacebookIcon,
                title: 'Sign In With Facebook',
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 1600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}