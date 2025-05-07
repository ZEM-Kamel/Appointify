import 'package:appointify_app/constants.dart';
import 'package:appointify_app/core/helper_functions/build_error_bar.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/core/widgets/custom_text_field.dart';
import 'package:appointify_app/core/widgets/password_field.dart';
import 'package:appointify_app/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/have_an_account_widget.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  late String email, userName, password;
  late bool isTermsAccepted = false;
  
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
                onSaved: (value) {
                  userName = value!;
                },
                hintText: 'Full Name',
                textInputType: TextInputType.name,
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: Color(0xffC9CECF),
                ),
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
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
                delay: const Duration(milliseconds: 400),
              ),
              const SizedBox(
                height: 16,
              ),
               PasswordField(
                onSaved: (value) {
                  password = value!;
                },
                prefixIcon: const Icon(
                  Icons.lock_outlined,
                  color: Color(0xffC9CECF),
                ),
              ).animate().fadeIn(
                 duration: const Duration(milliseconds: 600),
                 delay: const Duration(milliseconds: 600),
               ),
              const SizedBox(
                height: 16,
              ),
              TermsAndConditionsWidget(
                onChanged: (value) {
                  isTermsAccepted = value;
                },
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 800),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (isTermsAccepted) {
                      context
                          .read<SignupCubit>()
                          .createUserWithEmailAndPassword(
                        email,
                        password,
                        userName,
                      );
                    } else {
                      showBar(context, 'You Must Accept The Terms & Conditions');
                    }
                  } else {
                    setState(() {
                      autoValidateMode = AutovalidateMode.always;
                    });
                  }
                },
                text: 'Create A New Account',
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 1000),
              ),
              const SizedBox(
                height: 26,
              ),
              const HaveAnAccountWidget().animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 1200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
