import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/core/widgets/custom_progress_hud.dart';
import 'package:appointify_app/core/widgets/custom_text_field.dart';
import 'package:appointify_app/features/auth/presentation/cubits/password_reset_cubit/password_reset_cubit.dart';
import 'package:appointify_app/features/auth/presentation/cubits/password_reset_cubit/password_reset_state.dart';
import 'package:appointify_app/features/auth/presentation/views/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key, this.showAppBar = true})
    : super(key: key);

  /// Whether to show the app bar in this view
  final bool showAppBar;

  static const String routeName = 'forgotPassword';

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.showAppBar
              ? buildAppBar(
                context,
                title: 'Forgot Password',
                showSettingsButton: false,
                showBackButton: true,
              )
              : null,
      body: BlocConsumer<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is PasswordResetFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PasswordResetEmailSent) {
            // Show success message and navigate back to sign-in view
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Password reset email sent to ${_emailController.text}',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushReplacementNamed(SignInView.routeName);
            });
          }
        },
        builder: (context, state) {
          if (state is PasswordResetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child:
                _emailSent
                    ? _buildEmailSentContent()
                    : _buildResetForm(context),
          );
        },
      ),
    );
  }

  Widget _buildResetForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Icon(Icons.lock_reset, size: 100, color: AppColors.primaryColor),
          const SizedBox(height: 40),
          const Text(
            'Forgot Password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          CustomTextFormField(
            textInputType: TextInputType.emailAddress,
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xffC9CECF),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              } else if (!RegExp(
                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
              ).hasMatch(value.trim())) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<PasswordResetCubit>().sendPasswordResetEmail(
                  _emailController.text.trim(),
                );
              }
            },
            text: 'Send Reset Link',
          ),
          const SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () {
                // Exit the nested navigator completely
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushReplacementNamed(SignInView.routeName);
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSentContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.mark_email_read,
          size: 80,
          color: AppColors.primaryColor,
        ),
        const SizedBox(height: 32),
        const Text(
          'Reset Email Sent!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions to reset your password.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        const Text(
          'Didn\'t receive the email?',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            context.read<PasswordResetCubit>().sendPasswordResetEmail(
              _emailController.text.trim(),
            );
          },
          child: const Text(
            'Resend Link',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed:
              () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushReplacementNamed(SignInView.routeName),
          text: 'Back to Login',
        ),
      ],
    );
  }
}
