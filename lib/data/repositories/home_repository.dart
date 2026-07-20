// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Home Repository (Modellerle Tam Uyumlu)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/active_case_model.dart';
import '../models/legal_category_model.dart';
import '../models/recent_activity_model.dart';
import '../models/legal_event_model.dart';
import '../services/settings_controller.dart';

class HomeRepository {
  
  /// Ana Sayfa Kategorileri
  List<LegalCategoryModel> getCategories(AppLanguage language) {
    final isTr = language == AppLanguage.tr;
    return [
      LegalCategoryModel(
        id: 'cat-1', 
        name: isTr ? 'Vatandaşlık' : 'Citizenship', 
        icon: Icons.badge_outlined, 
        iconColor: const Color(0xFF4A90E2),
        backgroundColor: const Color(0xFFEBF3FE),
        imagePath: 'assets/images/categories/vatandaslik.png',
      ),
      LegalCategoryModel(
        id: 'cat-2', 
        name: isTr ? 'Tapu / Emlak' : 'Real Estate', 
        icon: Icons.home_work_outlined, 
        iconColor: const Color(0xFF50E3C2),
        backgroundColor: const Color(0xFFEDFBF7),
        imagePath: 'assets/images/categories/tapu.png',
      ),
      LegalCategoryModel(
        id: 'cat-3', 
        name: isTr ? 'Taşıt' : 'Vehicle', 
        icon: Icons.directions_car_filled_outlined, 
        iconColor: const Color(0xFFF5A623),
        backgroundColor: const Color(0xFFFEF7EA),
        imagePath: 'assets/images/categories/tasit.png',
      ),
      LegalCategoryModel(
        id: 'cat-4', 
        name: isTr ? 'Kira' : 'Rent', 
        icon: Icons.key_outlined, 
        iconColor: const Color(0xFFD0021B),
        backgroundColor: const Color(0xFFFDECEC),
        imagePath: 'assets/images/categories/kira.png',
      ),
      LegalCategoryModel(
        id: 'cat-5', 
        name: isTr ? 'Pasaport' : 'Passport', 
        icon: Icons.auto_stories_outlined, 
        iconColor: const Color(0xFF9013FE),
        backgroundColor: const Color(0xFFF4EBFD),
        imagePath: 'assets/images/categories/pasaport.png',
      ),
      LegalCategoryModel(
        id: 'cat-6', 
        name: isTr ? 'SGK / Emeklilik' : 'SSI / Retirement', 
        icon: Icons.security_outlined, 
        iconColor: const Color(0xFF7ED321),
        backgroundColor: const Color(0xFFF2FBE9),
        imagePath: 'assets/images/categories/sgk.png',
      ),
      LegalCategoryModel(
        id: 'cat-7', 
        name: isTr ? 'Eğitim İşlemleri' : 'Education', 
        icon: Icons.school_outlined, 
        iconColor: const Color(0xFFF87171),
        backgroundColor: const Color(0xFFFEF2F2),
        imagePath: 'assets/images/categories/egitim.png',
      ),
      LegalCategoryModel(
        id: 'cat-8', 
        name: isTr ? 'Aile & Medeni Hal' : 'Family & Civil Status', 
        icon: Icons.family_restroom_outlined, 
        iconColor: const Color(0xFFEC4899),
        backgroundColor: const Color(0xFFFDF2F8),
        imagePath: 'assets/images/categories/aile.png',
      ),
      LegalCategoryModel(
        id: 'cat-9', 
        name: isTr ? 'Dijital Devlet' : 'Digital Government', 
        icon: Icons.electrical_services_outlined, 
        iconColor: const Color(0xFF0EA5E9),
        backgroundColor: const Color(0xFFF0F9FF),
        imagePath: 'assets/images/categories/dijitalDevlet.png',
      ),
      LegalCategoryModel(
        id: 'cat-10',
        name: isTr ? 'Hukuk Sözlüğü' : 'Legal Dictionary',
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF2F80ED),
        backgroundColor: const Color(0xFFEAF4FF),
        imagePath: 'assets/images/hukuk_sozlugu.png',
      ),
    ];
  }

  /// Son İşlemler
  List<RecentActivityModel> getRecentActivities(AppLanguage language) {
    final isTr = language == AppLanguage.tr;
    return [
      RecentActivityModel(
        id: 'act-1',
        title: isTr ? 'Kira Tahliye İhtarnamesi' : 'Lease Eviction Notice',
        description: isTr ? 'Taslak Hazırlandı' : 'Draft Prepared',
        type: ActivityType.petitionCreated,
        date: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      RecentActivityModel(
        id: 'act-2',
        title: isTr ? 'Pasaport Randevusu' : 'Passport Appointment',
        description: isTr ? 'Ankara Nüfus Md.' : 'Ankara Registry Office',
        type: ActivityType.statusUpdated,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RecentActivityModel(
        id: 'act-3',
        title: isTr ? 'Tapu Devir İşlemi' : 'Title Deed Transfer',
        description: isTr ? 'WebTapu Başvurusu' : 'WebTapu Application',
        type: ActivityType.documentUploaded,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Yaklaşan Hukuki Süreler
  List<LegalEventModel> getUpcomingDeadlines(AppLanguage language) {
    final isTr = language == AppLanguage.tr;
    return [
      LegalEventModel(
        id: 'ev-1',
        title: isTr ? 'Tüketici Hakem Heyeti (Örnek)' : 'Consumer Arbitration Committee (Sample)',
        description: isTr ? 'Yasal Karar Süreci' : 'Legal Decision Process',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        deadlineDate: DateTime.now().add(const Duration(days: 170)),
        relatedProcedureId: 'prop-1',
      ),
      LegalEventModel(
        id: 'ev-2',
        title: isTr ? 'Kira İtiraz Süresi (Örnek)' : 'Rental Objection Period (Sample)',
        description: isTr ? 'İhtarnameye Cevap' : 'Response to Notice',
        startDate: DateTime.now().subtract(const Duration(days: 12)),
        deadlineDate: DateTime.now().add(const Duration(days: 3)),
        relatedProcedureId: 'prop-2',
      ),
    ];
  }

  /// Aktif dava simülasyonu
  Future<ActiveCaseModel> fetchActiveCase(AppLanguage language) async {
    await Future.delayed(Duration.zero);
    final isTr = language == AppLanguage.tr;
    return ActiveCaseModel(
      id: 'case-101',
      title: isTr ? 'İşçi Alacağı Davası' : 'Labor Receivable Lawsuit',
      subtitle: isTr ? 'Ankara 4. İş Mahkemesi' : 'Ankara 4th Labor Court',
      progress: 0.65,
      categoryLabel: isTr ? 'İş Hukuku' : 'Labor Law',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
    );
  }
}
