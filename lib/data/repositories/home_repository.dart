// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Home Repository (Modellerle Tam Uyumlu)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/active_case_model.dart';
import '../models/legal_category_model.dart';
import '../models/recent_activity_model.dart';
import '../models/legal_event_model.dart';

class HomeRepository {
  
  /// Ana Sayfa Kategorileri
  List<LegalCategoryModel> getCategories() {
    return [
      LegalCategoryModel(
        id: 'cat-1', 
        name: 'Vatandaşlık', 
        icon: Icons.badge_outlined, 
        iconColor: const Color(0xFF4A90E2),
        backgroundColor: const Color(0xFFEBF3FE),
        imagePath: 'assets/images/categories/vatandaslik.png',
      ),
      LegalCategoryModel(
        id: 'cat-2', 
        name: 'Tapu / Emlak', 
        icon: Icons.home_work_outlined, 
        iconColor: const Color(0xFF50E3C2),
        backgroundColor: const Color(0xFFEDFBF7),
        imagePath: 'assets/images/categories/tapu.png',
      ),
      LegalCategoryModel(
        id: 'cat-3', 
        name: 'Taşıt', 
        icon: Icons.directions_car_filled_outlined, 
        iconColor: const Color(0xFFF5A623),
        backgroundColor: const Color(0xFFFEF7EA),
        imagePath: 'assets/images/categories/tasit.png',
      ),
      LegalCategoryModel(
        id: 'cat-4', 
        name: 'Kira', 
        icon: Icons.key_outlined, 
        iconColor: const Color(0xFFD0021B),
        backgroundColor: const Color(0xFFFDECEC),
        imagePath: 'assets/images/categories/kira.png',
      ),
      LegalCategoryModel(
        id: 'cat-5', 
        name: 'Pasaport', 
        icon: Icons.auto_stories_outlined, 
        iconColor: const Color(0xFF9013FE),
        backgroundColor: const Color(0xFFF4EBFD),
        imagePath: 'assets/images/categories/pasaport.png',
      ),
      LegalCategoryModel(
        id: 'cat-6', 
        name: 'SGK / Emeklilik', 
        icon: Icons.security_outlined, 
        iconColor: const Color(0xFF7ED321),
        backgroundColor: const Color(0xFFF2FBE9),
        imagePath: 'assets/images/categories/sgk.png',
      ),
      LegalCategoryModel(
        id: 'cat-7', 
        name: 'Eğitim İşlemleri', 
        icon: Icons.school_outlined, 
        iconColor: const Color(0xFFF87171),
        backgroundColor: const Color(0xFFFEF2F2),
        imagePath: 'assets/images/categories/egitim.png', // Fallback for image 
      ),
      LegalCategoryModel(
        id: 'cat-8', 
        name: 'Aile & Medeni Hal', 
        icon: Icons.family_restroom_outlined, 
        iconColor: const Color(0xFFEC4899),
        backgroundColor: const Color(0xFFFDF2F8),
        imagePath: 'assets/images/categories/aile.png', // Fallback for image
      ),
      LegalCategoryModel(
        id: 'cat-9', 
        name: 'Dijital Devlet', 
        icon: Icons.electrical_services_outlined, 
        iconColor: const Color(0xFF0EA5E9),
        backgroundColor: const Color(0xFFF0F9FF),
        imagePath: 'assets/images/categories/dijitalDevlet.png', // Fallback for image
      ),
      LegalCategoryModel(
        id: 'cat-10',
        name: 'Hukuk Sözlüğü',
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF2F80ED),
        backgroundColor: const Color(0xFFEAF4FF),
        // Yeni görsel: pastel adaçayı yeşili arka plan önünde ahşap hakim tokmağı ve
        // altın yaldızlı, deri ciltli klasik hukuk kitabı illüstrasyonu.
        imagePath: 'assets/images/hukuk_sozlugu.png',
      ),
    ];
  }

  /// Son İşlemler
  List<RecentActivityModel> getRecentActivities() {
    return [
      RecentActivityModel(
        id: 'act-1',
        title: 'Kira Tahliye İhtarnamesi',
        description: 'Taslak Hazırlandı',
        type: ActivityType.petitionCreated,
        date: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      RecentActivityModel(
        id: 'act-2',
        title: 'Pasaport Randevusu',
        description: 'Ankara Nüfus Md.',
        type: ActivityType.statusUpdated,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RecentActivityModel(
        id: 'act-3',
        title: 'Tapu Devir İşlemi',
        description: 'WebTapu Başvurusu',
        type: ActivityType.documentUploaded,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Yaklaşan Hukuki Süreler
  List<LegalEventModel> getUpcomingDeadlines() {
    return [
      LegalEventModel(
        id: 'ev-1',
        title: 'Tüketici Hakem Heyeti (Örnek)',
        description: 'Yasal Karar Süreci',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        deadlineDate: DateTime.now().add(const Duration(days: 170)),
        relatedProcedureId: 'prop-1',
      ),
      LegalEventModel(
        id: 'ev-2',
        title: 'Kira İtiraz Süresi (Örnek)',
        description: 'İhtarnameye Cevap',
        startDate: DateTime.now().subtract(const Duration(days: 12)),
        deadlineDate: DateTime.now().add(const Duration(days: 3)),
        relatedProcedureId: 'prop-2',
      ),
    ];
  }

  /// Aktif dava simülasyonu
  Future<ActiveCaseModel> fetchActiveCase() async {
    await Future.delayed(Duration.zero);
    return ActiveCaseModel(
      id: 'case-101',
      title: 'İşçi Alacağı Davası',
      subtitle: 'Ankara 4. İş Mahkemesi',
      progress: 0.65,
      categoryLabel: 'İş Hukuku',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
    );
  }
}


