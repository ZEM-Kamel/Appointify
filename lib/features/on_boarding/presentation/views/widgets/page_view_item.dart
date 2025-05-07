import 'package:appointify_app/constants.dart';
import 'package:appointify_app/core/services/shared_preferences_singleton.dart';
import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/features/auth/presentation/views/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem(
      {super.key,
        required this.image,
        required this.backgroundImage,
        required this.subtitle,
        required this.title,
        this.isVisible
      });

  final String image, backgroundImage, subtitle;
  final Widget title;
  final bool? isVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  backgroundImage,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  image,
                ),
              ),
              Visibility(
                visible: isVisible!,
                child: GestureDetector(
                  onTap: ()
                  {
                    Prefs.setBool(kIsOnBoardingViewSeen, true);
                    Navigator.of(context).pushReplacementNamed(SignInView.routeName,);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Skip',
                      style: TextStyles.bold16.copyWith(
                        color: const Color(0xFF949D9E),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 64,
        ),
        title,
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 37,
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyles.semiBold13.copyWith(
              color: const Color(0xFF4E5456),
            ),
          ),
        )
      ],
    );
  }
}