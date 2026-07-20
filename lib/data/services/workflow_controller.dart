// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Prosedür Motoru: WorkflowController
// ═══════════════════════════════════════════════════════════════════════════

import '../models/procedure_model.dart';

class WorkflowResult {
  final ProcedureModel procedure;
  final List<String> reminders;
  final String? calculatedFee;
  final String? ageBasedNote;
  final String officialDisclaimer; // Yasal Uyarı Metni

  const WorkflowResult({
    required this.procedure,
    this.reminders = const [],
    this.calculatedFee,
    this.ageBasedNote,
    this.officialDisclaimer = "Bu bilgiler bilgilendirme amaçlıdır. Güncel harç ve mevzuat için ilgili resmi kurumu (NVI, Tapu Kadastro vb.) ziyaret ediniz.",
  });
}

class WorkflowController {
  WorkflowController._();

  static WorkflowResult evaluate(
    ProcedureModel procedure, {
    bool isStudent = false,
    bool isDisabled = false,
    bool isPensioner = false,
    int? userAge,
  }) {
    final reminders = <String>[];
    String? calculatedFee;
    String? ageBasedNote;

    // 1. Kişiselleştirme Mantığı
    if (isStudent && procedure.category == ProcedureCategory.pasaport) {
      calculatedFee = "Harçtan MUAF (Öğrenci) - Sadece Defter Bedeli: ~790 ₺";
      reminders.add("🎓 e-Devlet üzerinden aktif öğrenci belgesi almanız gerekmektedir.");
    }

    if (isDisabled && procedure.category == ProcedureCategory.tasit) {
      reminders.add("♿ Engelli bireyler için ÖTV muafiyeti ve MTV istisnası uygulanabilir.");
      calculatedFee = "ÖTV'siz Satış / Tescil İşlemi";
    }

    if (isPensioner && procedure.category == ProcedureCategory.tapu) {
      reminders.add("🏡 Tek meskeni olan emekliler için emlak vergisi muafiyeti hakkı bulunabilir.");
    }

    // 2. Yaş Mantığı (Resmiyet)
    if (userAge != null && userAge < 18) {
      ageBasedNote = "⚠️ 18 yaş altı olduğunuz için veli/vasi muvafakatnamesi gereklidir.";
      reminders.add("👨‍👩‍👦 Başvuru anında anne ve babanın (veya yasal vasinin) hazır bulunması zorunludur.");
    }

    // 3. Genel Uyarılar
    if (procedure.criticalNote != null) {
      reminders.add("🚩 ${procedure.criticalNote}");
    }

    // 4. Kategoriye Özel Resmi Disclaimer
    String disclaimer = "Bu içerik 2024-2025 güncel mevzuatına göre hazırlanmıştır. Resmi başvurudan önce randevu.nvi.gov.tr veya ilgili resmi portaldan verileri teyit ediniz.";

    return WorkflowResult(
      procedure: procedure,
      reminders: reminders,
      calculatedFee: calculatedFee ?? procedure.fee,
      ageBasedNote: ageBasedNote,
      officialDisclaimer: disclaimer,
    );
  }
}


