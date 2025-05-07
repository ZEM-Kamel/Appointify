import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFDCDEDE),
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        Text(
          'OR',
          textAlign: TextAlign.center,
          style: TextStyles.semiBold16,
        ),
        const SizedBox(
          width: 18,
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFDCDEDE),
          ),
        ),
      ],
    );
  }
}