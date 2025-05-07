
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/utils/app_images.dart';
import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/features/on_boarding/presentation/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key,
    required this.pageController
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          isVisible: true,
          image: Assets.imagesPageViewItem1Image,
          backgroundImage: Assets.imagesPageViewItem1BackgroundImage,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome To',
                style: TextStyles.bold23,
              ),
              Text(
                ' Appoint',
                style: TextStyles.bold23.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                'ify',
                style: TextStyles.bold23.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          subtitle: 'Discover Specialists Effortlessly And Book Appointments In Just A Few Taps.',
        ),
        PageViewItem(
          isVisible: false,
          image: Assets.imagesPageViewItem2Image,
          backgroundImage: Assets.imagesPageViewItem2BackgroundImage,
          title:Text(
            'Booking & Management',
            textAlign: TextAlign.center,
            style: TextStyles.bold23.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          subtitle: 'Manage Your Bookings, View Upcoming Appointments, And Reschedule With Ease.',
        ),
      ],
    );
  }
}
