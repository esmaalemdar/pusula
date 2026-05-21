import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/recent_activity_model.dart';
import '../../petition/petition_generator_screen.dart';

class RecentActivitiesList extends StatelessWidget {
  final List<RecentActivityModel> activities;
  const RecentActivitiesList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          indent: 56,
        ),
        itemBuilder: (_, i) => _ActivityTile(model: activities[i]),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final RecentActivityModel model;
  const _ActivityTile({required this.model});

  @override
  Widget build(BuildContext context) {
    final config = _activityConfig(model.type);

    return InkWell(
      onTap: () {
        if (model.type == ActivityType.petitionCreated) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PetitionGeneratorScreen(
                categoryName: model.title.contains('Kira') ? 'Kira Hukuku' : 'Genel',
                userName: 'Kullanıcı',
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(config.icon, size: 17, color: config.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.text900,
                      height: 1.3,
                    ),
                  ),
                  if (model.description != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      model.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? AppColors.text600,
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _timeAgo(model.date),
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4) ?? AppColors.text400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({IconData icon, Color color}) _activityConfig(ActivityType t) {
    switch (t) {
      case ActivityType.petitionCreated:
        return (icon: Icons.description_outlined, color: AppColors.primary);
      case ActivityType.documentUploaded:
        return (icon: Icons.upload_file_rounded, color: AppColors.accent);
      case ActivityType.statusUpdated:
        return (icon: Icons.check_circle_outline_rounded, color: const Color(0xFF3A9E7A));
      case ActivityType.reminder:
        return (icon: Icons.alarm_rounded, color: const Color(0xFFF5A623));
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}dk';
    if (diff.inHours < 24) return '${diff.inHours}sa';
    return '${diff.inDays}g';
  }
}



