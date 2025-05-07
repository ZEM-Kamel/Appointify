import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.inputFormatters,
    this.validator,
    this.controller,
    this.maxLines,
    this.readOnly,
    this.enabled,
  });

  final String hintText;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;
  final bool? readOnly;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      onSaved: onSaved,
      readOnly: readOnly ?? false,
      enabled: enabled ?? true,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'fieldRequired';
        }
        return null;
      },
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: TextStyles.bold13.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        hintText: hintText,
        filled: true,
        fillColor: isDarkMode 
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.surface,
        border: buildBorder(theme),
        enabledBorder: buildBorder(theme),
        focusedBorder: buildBorder(theme, isFocused: true),
        errorBorder: buildBorder(theme, isError: true),
        focusedErrorBorder: buildBorder(theme, isError: true, isFocused: true),
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeData theme, {bool isFocused = false, bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 1,
        color: isError 
            ? theme.colorScheme.error
            : isFocused
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
      ),
    );
  }
}
