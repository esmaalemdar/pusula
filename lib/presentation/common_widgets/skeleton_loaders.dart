// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Skeleton Loaders (Shimmer Efekti)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final Widget child;
  const SkeletonLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
      child: child,
    );
  }
}

/// A skeleton box that wraps itself in [SkeletonLoader].
/// Must be used inside a widget that has a [BuildContext] via build().
class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Skeleton
          const _SkeletonBox(width: 150, height: 24),
          const SizedBox(height: 12),
          const _SkeletonBox(width: double.infinity, height: 56, radius: 18),

          const SizedBox(height: 32),
          // Active Case Skeleton
          const _SkeletonBox(width: 120, height: 18),
          const SizedBox(height: 16),
          const _SkeletonBox(width: double.infinity, height: 160, radius: 24),

          const SizedBox(height: 32),
          // Categories Grid Skeleton
          const _SkeletonBox(width: 120, height: 18),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, __) =>
                const _SkeletonBox(width: double.infinity, height: 120, radius: 22),
          ),
        ],
      ),
    );
  }
}



