import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/active_case_model.dart';
import '../../../../data/services/settings_controller.dart';
import 'package:provider/provider.dart';

class ActiveCaseCard extends StatelessWidget {
  final ActiveCaseModel model;
  const ActiveCaseCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final progressPercent = (model.progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst: Kategori chip + detay oku
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  settings.translate(model.categoryLabel),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  debugPrint('More options tapped');
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? AppColors.text600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Başlık
          Text(
            model.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.text900,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model.subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? AppColors.text600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // İlerleme çubuğu
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          settings.translate('completion'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? AppColors.text600,
                          ),
                        ),
                        Text(
                          '%$progressPercent',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: model.progress,
                        minHeight: 8,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Alt: Son güncelleme bilgisi
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4) ?? AppColors.text400,
              ),
              const SizedBox(width: 5),
              Text(
                '${settings.translate('last_updated')}: ${_timeAgo(model.lastUpdated, settings.language == AppLanguage.tr)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4) ?? AppColors.text400,
                ),
              ),
              const Spacer(),
              // Devam Et butonu
              GestureDetector(
                onTap: () {
                  debugPrint('View case details tapped');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    settings.translate('continue_btn'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt, bool isTr) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return isTr ? '${diff.inMinutes} dk önce' : '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return isTr ? '${diff.inHours} saat önce' : '${diff.inHours} hours ago';
    return isTr ? '${diff.inDays} gün önce' : '${diff.inDays} days ago';
  }
}



