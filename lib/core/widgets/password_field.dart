import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class PasswordField extends StatefulWidget {

  const PasswordField({
    super.key,
    this.onSaved,
    this.prefixIcon,
    this.validate,
    this.controller,
  });

  final String? Function(String?)? validate;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final Widget? prefixIcon;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      maxLines: 1,
      controller: widget.controller,
      onSaved: widget.onSaved,
      validator: widget.validate,
      obscureText: obscureText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        child: Icon(
          obscureText ? Icons.remove_red_eye : Icons.visibility_off,
          color: const Color(0xffC9CECF),
        ),
      ),
      hintText:'Password',
      textInputType: TextInputType.visiblePassword,
    );
  }
}
