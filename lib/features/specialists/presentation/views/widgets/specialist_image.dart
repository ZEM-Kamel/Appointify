import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SpecialistImage extends StatelessWidget {
  final String imageUrl;
  final String gender; // "male" or "female"
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  const SpecialistImage({
    Key? key,
    required this.imageUrl,
    required this.gender,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        gender == "female"
            ? "assets/images/female_placeholder.png"
            : "assets/images/male_placeholder.png",
        width: width,
        height: height,
        fit: fit,
      ),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }
} 