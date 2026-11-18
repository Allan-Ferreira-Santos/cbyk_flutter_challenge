import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minChildWidth = 148,
    this.horizontalSpacing = 12,
    this.verticalSpacing = 12,
    this.maxColumnCount = 4,
  });

  final List<Widget> children;
  final double minChildWidth;
  final double horizontalSpacing;
  final double verticalSpacing;
  final int maxColumnCount;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;
        final columnCount = _resolveColumnCount(parentWidth);
        final totalHorizontalGaps = horizontalSpacing * (columnCount - 1);
        final childWidth =
            ((parentWidth - totalHorizontalGaps) / columnCount)
                .clamp(0.0, parentWidth);

        return Wrap(
          spacing: horizontalSpacing,
          runSpacing: verticalSpacing,
          children: children
              .map(
                (child) => SizedBox(
                  width: childWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }

  int _resolveColumnCount(double parentWidth) {
    if (parentWidth <= 0 || minChildWidth <= 0) return 1;

    final fittedColumns =
        ((parentWidth + horizontalSpacing) / (minChildWidth + horizontalSpacing))
            .floor();

    return fittedColumns.clamp(1, maxColumnCount);
  }
}
