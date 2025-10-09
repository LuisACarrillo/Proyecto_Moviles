import 'package:flutter/material.dart';

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
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.onTap,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = Theme.of(context).dividerColor.withValues(alpha: 0.18);

    final content = Padding(padding: padding, child: child);

    return Card(
      color: cs.surface,
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: onTap != null
          ? InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: content,
            )
          : content,
    );
  }
}
