import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text});

  final VoidCallback? onPressed; // <-- make this nullable
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: onPressed == null
              ? Colors.grey
              : AppColors.primaryColor,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyles.bold16.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
