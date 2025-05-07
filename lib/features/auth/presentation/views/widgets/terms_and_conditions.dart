import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/features/auth/presentation/views/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  const TermsAndConditionsWidget({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;
  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  bool isTermsAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(
          onChecked: (value) {
            isTermsAccepted = value;
            widget.onChanged(value);
            setState(() {});
          },
          isChecked: isTermsAccepted,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'By Creating An Account, You Agree To',
                  style: TextStyles.semiBold13.copyWith(
                    color: const Color(0xFF949D9E),
                  ),
                ),
                const TextSpan(
                  text: ' ',
                  style: TextStyles.semiBold13,
                ),
                TextSpan(
                  text: 'Our Terms & Conditions',
                  style: TextStyles.semiBold13.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}