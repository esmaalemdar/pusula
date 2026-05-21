// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Yaklaşan Süreler Widget'ı
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/legal_event_model.dart';

class UpcomingDeadlines extends StatelessWidget {
  final List<LegalEventModel> deadlines;

  const UpcomingDeadlines({super.key, required this.deadlines});

  @override
  Widget build(BuildContext context) {
    if (deadlines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: deadlines.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final event = deadlines[index];
              return _DeadlineCard(event: event);
            },
          ),
        ),
      ],
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  final LegalEventModel event;

  const _DeadlineCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: event.priorityColor.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: event.priorityColor.withOpacity(0.3), width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.text900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? AppColors.text600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: event.priorityColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${event.daysLeft}",
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Gün",
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 8, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



