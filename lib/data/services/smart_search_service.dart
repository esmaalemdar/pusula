// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Akıllı Arama Mantığı (Smart Search Service)
// ═══════════════════════════════════════════════════════════════════════════

import '../models/procedure_model.dart';
import '../services/service_definitions.dart';

class SmartSearchService {
  SmartSearchService._();

  // Anahtar Kelime Haritası (Anlamsal / Semantic Search)
  static final Map<ProcedureCategory, List<String>> _keywordMap = {
    ProcedureCategory.kira: ['ev sahibi', 'kiracı', 'tahliye', 'kontrat', 'kira', 'evden çıkar'],
    ProcedureCategory.pasaport: ['pasaport', 'vize', 'yurt dışı', 'harç', 'nüfus'],
    ProcedureCategory.vatandaslik: ['vatandaşlık', 'kimlik', 'nüfus', 'ikamet', 'oturum'],
    ProcedureCategory.tasit: ['araç', 'araba', 'satış', 'noter', 'trafik', 'plaka', 'mtv', 'ceza'],
    ProcedureCategory.tapu: ['ev alım', 'satım', 'tapu', 'gayrimenkul', 'arsa', 'emlak'],
    ProcedureCategory.sgk: ['emeklilik', 'eyt', 'prim', 'sigorta', 'hastane', 'maaş'],
    ProcedureCategory.egitim: ['eğitim', 'öğrenci', 'kyk', 'burs', 'yurt', 'okul', 'sınav', 'yök', 'diploma', 'denklik', 'ösym'],
    ProcedureCategory.aile: ['aile', 'evlilik', 'nikah', 'bebek', 'doğum', 'ikametgah', 'adres', 'nüfus', 'medeni', 'çocuk'],
    ProcedureCategory.dijitalDevlet: ['dijital', 'devlet', 'abonelik', 'elektrik', 'su', 'fatura', 'adli sicil', 'sabıka', 'uyap', 'cimer', 'şikayet', 'dava'],
  };

  /// Kullanıcı cümlesini analiz eder ve ilgili Prosedürü veya Kategoriyi döndürür.
  static dynamic analyzeQuery(String query) {
    final lowerQuery = query.toLowerCase().trim();
    if (lowerQuery.isEmpty) return null;

    final allProcedures = ServiceDefinitions.getAll();

    // 1. Doğrudan Prosedür İsminde veya İçeriğinde Arama (Tam eşleşme)
    for (var procedure in allProcedures) {
      if (procedure.name.toLowerCase().contains(lowerQuery)) {
        return procedure;
      }
    }

    // 2. Kategori İsmiyle Eşleşme (Örn: 'Aile' yazınca 'Aile & Medeni Hal' kategorisi gelsin)
    final categoryNames = {
      ProcedureCategory.kira: 'kira',
      ProcedureCategory.pasaport: 'pasaport',
      ProcedureCategory.vatandaslik: 'vatandaşlık',
      ProcedureCategory.tasit: 'taşıt',
      ProcedureCategory.tapu: 'tapu',
      ProcedureCategory.sgk: 'sgk',
      ProcedureCategory.egitim: 'eğitim',
      ProcedureCategory.aile: 'aile',
      ProcedureCategory.dijitalDevlet: 'dijital',
    };

    for (var entry in categoryNames.entries) {
      if (lowerQuery.contains(entry.value)) {
        return entry.key;
      }
    }

    // 3. Anlamsal (Semantic) Anahtar Kelime Arama
    ProcedureCategory? matchedCategory;
    for (var entry in _keywordMap.entries) {
      if (entry.value.any((keyword) => lowerQuery.contains(keyword))) {
        matchedCategory = entry.key;
        break;
      }
    }

    if (matchedCategory == null) return null;

    // 4. Kategori bulundu, şimdi bu kategori içindeki en uygun prosedürü bulmaya çalış
    final procedures = ServiceDefinitions.getByCategory(matchedCategory);
    
    // Özel kelime kontrolleriyle daha nokta atışı prosedür önerisi:
    if (lowerQuery.contains('tahliye')) return _findProc(procedures, 'kira-tahliye');
    if (lowerQuery.contains('emekli') || lowerQuery.contains('eyt')) return _findProc(procedures, 'sgk-emeklilik');
    if (lowerQuery.contains('kyk') || lowerQuery.contains('burs') || lowerQuery.contains('yurt')) return _findProc(procedures, 'egitim-kyk');
    if (lowerQuery.contains('sınav') || lowerQuery.contains('ösym')) return _findProc(procedures, 'egitim-sinav');
    if (lowerQuery.contains('evlilik') || lowerQuery.contains('nikah')) return _findProc(procedures, 'aile-evlilik');
    if (lowerQuery.contains('doğum') || lowerQuery.contains('bebek')) return _findProc(procedures, 'aile-dogum');
    if (lowerQuery.contains('adres') || lowerQuery.contains('ikametgah')) return _findProc(procedures, 'aile-adres');
    if (lowerQuery.contains('abonelik') || lowerQuery.contains('fatura') || lowerQuery.contains('elektrik') || lowerQuery.contains('su')) return _findProc(procedures, 'dijital-abonelik');
    if (lowerQuery.contains('adli') || lowerQuery.contains('uyap') || lowerQuery.contains('sabıka')) return _findProc(procedures, 'dijital-adli');
    if (lowerQuery.contains('cimer') || lowerQuery.contains('şikayet')) return _findProc(procedures, 'dijital-cimer');

    // Eğer nokta atışı prosedür bulamadıysa doğrudan kategoriyi döndür
    return matchedCategory;
  }

  static ProcedureModel? _findProc(List<ProcedureModel> procs, String id) {
    try {
      return procs.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}


