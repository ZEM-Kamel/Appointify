// import 'package:appointify_app/core/theme/theme_constants.dart';
// import 'package:flutter/material.dart';
//
// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//   final List<BottomNavItem> items;
//
//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     required this.items,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       selectedIndex: currentIndex,
//       onDestinationSelected: onTap,
//       height: ThemeConstants.navBarHeight,
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//       destinations: items.map((item) {
//         return NavigationDestination(
//           icon: Icon(item.icon),
//           selectedIcon: Icon(item.selectedIcon),
//           label: item.label,
//         );
//       }).toList(),
//     );
//   }
// }
//
// class BottomNavItem {
//   final IconData icon;
//   final IconData selectedIcon;
//   final String label;
//
//   const BottomNavItem({
//     required this.icon,
//     required this.selectedIcon,
//     required this.label,
//   });
// }