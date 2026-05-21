// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Ayarlar ve Tema Yönetimi (Settings Controller)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

enum AppLanguage { tr, en }

class SettingsController extends ChangeNotifier {
  // Singleton Yapısı
  static final SettingsController _instance = SettingsController._internal();
  factory SettingsController() => _instance;
  SettingsController._internal();

  // Varsayılan Ayarlar
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _language = AppLanguage.tr;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Tema Değiştir
  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Dil Değiştir
  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  // Çoklu Dil Metinleri (Basit Sözlük)
  String translate(String key) {
    final tr = {
      'profile': 'Profilim',
      'settings': 'Ayarlar',
      'dark_mode': 'Karanlık Mod',
      'language': 'Dil Seçeneği',
      'edevlet': 'e-Devlet Entegrasyonu',
      'logout': 'Çıkış Yap',
      'verified': 'Doğrulanmış Hesap',
      'unverified': 'Henüz Doğrulanmadı',
      'search_hint': 'Sorununuzu yazın',
      'categories': 'Kategoriler',
      'recent_activities': 'Son İşlemler',
      'upcoming_deadlines': 'Yaklaşan Süreler',
      'home': 'Ana Sayfa',
      'procedures': 'İşlemler',
      'archive': 'Arşiv',
      'all': 'Tümü',
      'agenda': 'Ajanda',
      'Vatandaşlık': 'Vatandaşlık',
      'Tapu / Emlak': 'Tapu / Emlak',
      'Taşıt': 'Taşıt',
      'Kira': 'Kira',
      'Pasaport': 'Pasaport',
      'SGK / Emeklilik': 'SGK / Emeklilik',
      'personal_info': 'Kişisel Bilgiler',
      'full_name': 'Ad Soyad',
      'email': 'E-posta',
      'id_number': 'T.C. Kimlik No',
      'membership_type': 'Üyelik Tipi',
      'premium_plan': 'Premium Plan',
      'official_integrations': 'Resmi Entegrasyonlar',
      'edevlet_gateway': 'e-Devlet Kapısı',
      'verified_state': 'Doğrulandı',
      'verify': 'Doğrula',
      'Tapu & Emlak': 'Tapu & Emlak',
      'Taşıt İşlemleri': 'Taşıt İşlemleri',
      'SGK & Emeklilik': 'SGK & Emeklilik',
      'Kira Hukuku': 'Kira Hukuku',
      'Prosedür Motoru': 'Prosedür Motoru',
      'Resmi işlemler için adım adım rehber': 'Resmi işlemler için adım adım rehber',
      'Henüz prosedür yok': 'Henüz prosedür yok',
      'offline_mode': 'Çevrimdışı Moddasınız, Yerel Veriler Gösteriliyor',
      'delete_doc': 'Belgeyi Sil',
      'delete_confirm': 'Bu döküman kalıcı olarak silinecektir. Emin misiniz?',
      'cancel': 'Vazgeç',
      'delete': 'Sil',
      'doc_deleted': 'Belge silindi',
      'legal_archive': 'Hukuki Arşiv',
      'my_petitions': 'Dilekçelerim',
      'my_scans': 'Taramalarım',
      'search_file': 'Dosya adı ara...',
      'no_docs': 'Arşivde belge bulunamadı',
      'preview': 'Önizle',
      'share': 'Paylaş',
      'sharing': 'paylaşılıyor...',
      'pdf_preview': 'PDF ÖNİZLEME MODU\n(A4 GÖRÜNÜMÜ)',
      'hello': 'Merhaba',
      'how_can_i_help_today': 'Bugün nasıl yardımcı olabilirim?',
      'completion': 'Tamamlanma',
      'last_updated': 'Son güncelleme',
      'continue_btn': 'Devam Et',
      // Prosedür Motoru — Kart içi statik metinler
      'required_documents': 'Gerekli Belgeler',
      'checklist': 'Kontrol Listesi',
      'procedure_detail_btn': 'İşlem Detayları & Dilekçe',
      'mandatory_label': 'Zorunlu',
      'roadmap': 'Yol Haritası',
      'personalization': 'Kişiselleştirme',
      'student': 'Öğrenci',
      'pensioner': 'Emekli',
      'petition_ready': 'Dilekçe Hazır!',
      'create_petition': 'Dilekçe Oluştur',
      'fill_missing_fields': 'Eksik bilgileri tamamlayın.',
      'search_no_match': 'Üzgünüm, bu konuda tam bir eşleşme bulamadım. Lütfen kategorilere göz atın.',
      'application_venue': 'Başvuru Yeri',
      'view_on_map': 'Haritada Gör',
      'procedure_fee': 'İşlem Ücreti',
      'estimated_duration': 'Tahmini Süre',
      'start_procedure': 'İşlem seçerek rehberinizi başlatın',
      'pick_category_hint': 'Yukarıdaki kategorilerden birini seçerek size özel adım adım prosedür rehberine ulaşın.',
      'Eğitim İşlemleri': 'Eğitim İşlemleri',
      'Aile & Medeni Hal': 'Aile & Medeni Hal',
      'Dijital Devlet': 'Dijital Devlet & Abonelikler',
      'in_archive': 'Arşivde Mevcut',
    };

    final en = {
      'profile': 'My Profile',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'edevlet': 'e-Gov Integration',
      'logout': 'Logout',
      'verified': 'Verified Account',
      'unverified': 'Not Verified',
      'search_hint': 'Type your problem',
      'categories': 'Categories',
      'recent_activities': 'Recent Activities',
      'upcoming_deadlines': 'Upcoming Deadlines',
      'home': 'Home',
      'procedures': 'Procedures',
      'archive': 'Archive',
      'all': 'All',
      'agenda': 'Agenda',
      'Vatandaşlık': 'Citizenship',
      'Tapu / Emlak': 'Real Estate',
      'Taşıt': 'Vehicle',
      'Kira': 'Rent',
      'Pasaport': 'Passport',
      'SGK / Emeklilik': 'SSI / Retirement',
      'personal_info': 'Personal Information',
      'full_name': 'Full Name',
      'email': 'Email',
      'id_number': 'ID Number',
      'membership_type': 'Membership Type',
      'premium_plan': 'Premium Plan',
      'official_integrations': 'Official Integrations',
      'edevlet_gateway': 'e-Gov Gateway',
      'verified_state': 'Verified',
      'verify': 'Verify',
      'Tapu & Emlak': 'Real Estate',
      'Taşıt İşlemleri': 'Vehicle Procedures',
      'SGK & Emeklilik': 'SSI & Retirement',
      'Kira Hukuku': 'Rental Law',
      'Prosedür Motoru': 'Procedure Engine',
      'Resmi işlemler için adım adım rehber': 'Step-by-step guide for official procedures',
      'Henüz prosedür yok': 'No procedures yet',
      'offline_mode': 'You are in Offline Mode, showing local data',
      'delete_doc': 'Delete Document',
      'delete_confirm': 'This document will be permanently deleted. Are you sure?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'doc_deleted': 'Document deleted',
      'Eğitim İşlemleri': 'Education',
      'Aile & Medeni Hal': 'Family & Civil Status',
      'Dijital Devlet': 'Digital Government',
      'in_archive': 'Available in Archive',
      'legal_archive': 'Legal Archive',
      'my_petitions': 'My Petitions',
      'my_scans': 'My Scans',
      'search_file': 'Search filename...',
      'no_docs': 'No documents found in archive',
      'preview': 'Preview',
      'share': 'Share',
      'sharing': 'sharing...',
      'pdf_preview': 'PDF PREVIEW MODE\n(A4 VIEW)',
      'hello': 'Hello',
      'how_can_i_help_today': 'How can I help you today?',
      'completion': 'Completion',
      'last_updated': 'Last updated',
      'continue_btn': 'Continue',
      // Procedure Engine — in-card static strings
      'required_documents': 'Required Documents',
      'checklist': 'Checklist',
      'procedure_detail_btn': 'Procedure Details & Petition',
      'mandatory_label': 'Required',
      'roadmap': 'Roadmap',
      'personalization': 'Personalization',
      'student': 'Student',
      'pensioner': 'Pensioner',
      'petition_ready': 'Petition Ready!',
      'create_petition': 'Create Petition',
      'fill_missing_fields': 'Please fill in the missing fields.',
      'search_no_match': 'Sorry, no exact match found. Please browse categories.',
      'application_venue': 'Application Venue',
      'view_on_map': 'View on Map',
      'procedure_fee': 'Processing Fee',
      'estimated_duration': 'Estimated Duration',
      'start_procedure': 'Select a procedure to start your guide',
      'pick_category_hint': 'Choose a category above to access your step-by-step procedure guide.',
    };

    return (_language == AppLanguage.tr) ? (tr[key] ?? key) : (en[key] ?? key);
  }
}


