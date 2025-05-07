import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_images.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchSubmitted;
  final VoidCallback? onFilterPressed;

  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSearchSubmitted,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 9,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          // Trim whitespace and convert to lowercase for case-insensitive search
          final trimmedValue = value.trim().toLowerCase();
          onChanged?.call(trimmedValue);
        },
        onSubmitted: (_) {
          // Only trigger search if there's actual text
          if (controller?.text.trim().isNotEmpty == true) {
            onSearchSubmitted?.call();
          }
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(
            onTap: () {
              // Only trigger search if there's actual text
              if (controller?.text.trim().isNotEmpty == true) {
                onSearchSubmitted?.call();
              }
            },
            child: SizedBox(
              width: 20,
              child: Center(
                child: SvgPicture.asset(
                  Assets.imagesSearchIcon,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface.withOpacity(0.7),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller?.text.trim().isNotEmpty == true)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  onPressed: () {
                    controller?.clear();
                    onChanged?.call('');
                  },
                ),
              IconButton(
                icon: SvgPicture.asset(
                  Assets.imagesFilter,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface.withOpacity(0.7),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: onFilterPressed,
              ),
            ],
          ),
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          hintText: 'Search For Specialists...',
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: _buildBorder(theme),
          enabledBorder: _buildBorder(theme),
          focusedBorder: _buildBorder(theme),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(ThemeConstants.inputBorderRadius),
      borderSide: BorderSide(
        width: 1,
        color: theme.colorScheme.surface,
      ),
    );
  }
}
