import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final double elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    this.onTap,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(padding: padding, child: child);

    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.secondaryBeige, width: 1),
      ),
      child: onTap != null
          ? InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: cardContent,
            )
          : cardContent,
    );
  }
}
