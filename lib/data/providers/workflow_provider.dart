// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Workflow Provider (State Management & Business Logic) V2
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/procedure_model.dart';
import '../models/legal_event_model.dart';
import '../models/notification_model.dart';
import '../services/database_service.dart';

class WorkflowProvider extends ChangeNotifier {
  ProcedureCategory? _selectedCategory;
  ProcedureModel? _currentProcedure;
  int _currentStep = 0;
  final Map<String, String> _formData = {};

  // Checklist state: procedureId -> List<bool>
  final Map<String, List<bool>> _checkedSteps = {};

  // Archive document names (simulated — in real app from ArchiveScreen)
  final Set<String> _archivedDocumentNames = {
    'Kira Sözleşmesi',
    'Pasaport',
    'Nüfus Cüzdanı',
    'Tapu Belgesi',
    'Biyometrik Fotoğraf',
  };

  // Procedure-triggered deadlines for home screen
  List<LegalEventModel> _procedureDeadlines = [];

  WorkflowProvider() {
    _procedureDeadlines = DatabaseService().getAllLegalEvents();
  }

  // Getters
  ProcedureCategory? get selectedCategory => _selectedCategory;
  ProcedureModel? get currentProcedure => _currentProcedure;
  int get currentStep => _currentStep;
  Map<String, String> get formData => _formData;
  Map<String, List<bool>> get checkedSteps => _checkedSteps;
  List<LegalEventModel> get procedureDeadlines => List.unmodifiable(_procedureDeadlines);

  // Arşivde var mı kontrolü (akıllı eşleşme)
  bool isDocumentArchived(String docName) {
    return _archivedDocumentNames.any(
      (archived) => docName.toLowerCase().contains(archived.toLowerCase()) ||
          archived.toLowerCase().contains(docName.toLowerCase()),
    );
  }

  // Kategoriye göre checkedSteps başlat
  void selectCategory(ProcedureCategory category) {
    _selectedCategory = category;
    _currentStep = 0;
    _formData.clear();
    notifyListeners();
  }

  // Prosedürü Başlat
  void startProcedure(ProcedureModel procedure) {
    _currentProcedure = procedure;
    _currentStep = 0;
    _formData.clear();
    notifyListeners();
  }

  // Checklist başlat — arşiv eşleşmesi ile otomatik tamamlama
  void initChecklist(String procedureId, ProcedureModel procedure) {
    if (!_checkedSteps.containsKey(procedureId)) {
      final steps = List.filled(procedure.steps.length, false);
      _checkedSteps[procedureId] = steps;
    }
    // Akıllı Eşleşme: Arşivdeki belgelerle adımları otomatik işaretle
    _autoMatchArchiveDocuments(procedureId, procedure);
    notifyListeners();
  }

  void _autoMatchArchiveDocuments(String procedureId, ProcedureModel procedure) {
    for (var i = 0; i < procedure.requiredDocuments.length; i++) {
      final docName = procedure.requiredDocuments[i].name;
      if (isDocumentArchived(docName) && i < (_checkedSteps[procedureId]?.length ?? 0)) {
        // Belge arşivde varsa, bu adımı tamamlandı işaretle
        _checkedSteps[procedureId]![i] = true;
      }
    }
  }

  // Checklist adımını toggle et
  void toggleStep(String procedureId, int stepIndex, ProcedureModel procedure) {
    if (!_checkedSteps.containsKey(procedureId)) {
      initChecklist(procedureId, procedure);
    }
    final steps = _checkedSteps[procedureId]!;
    if (stepIndex < steps.length) {
      steps[stepIndex] = !steps[stepIndex];
    }
    notifyListeners();
  }

  // Prosedür başlatıldığında kritik tarihleri Ana Sayfa'ya gönder
  void addProcedureDeadline({
    required String procedureId,
    required String title,
    required String note,
    required int daysFromNow,
  }) {
    // Aynı prosedürden birden fazla deadline eklenmesini engelle
    final oldEvents = _procedureDeadlines.where((d) => d.relatedProcedureId == procedureId).toList();
    for (var e in oldEvents) {
      DatabaseService().deleteLegalEvent(e.id);
    }
    _procedureDeadlines.removeWhere((d) => d.relatedProcedureId == procedureId);
    
    final newEvent = LegalEventModel(
      id: 'proc-$procedureId-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: note,
      startDate: DateTime.now(),
      deadlineDate: DateTime.now().add(Duration(days: daysFromNow)),
      relatedProcedureId: procedureId,
    );
    
    _procedureDeadlines.add(newEvent);
    DatabaseService().saveLegalEvent(newEvent);

    // Aynı zamanda Bildirimler listesine "gerçek" bir bildirim düşür
    DatabaseService().saveNotification(
      NotificationModel(
        id: 'notif-$procedureId-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Yeni Süre Eklendi: $title',
        content: 'Takviminizde yeni bir hukuki süre başlatıldı: $note. Kalan süre: $daysFromNow gün.',
        time: DateTime.now(),
        iconCodePoint: 0xe44f, // Icons.notification_important_rounded
        iconColorValue: 0xFFF59E0B, // Turuncu/Amber rengi
        isUnread: true,
      ),
    );

    notifyListeners();
  }

  // Kritik nota göre hatırlatıcı çıkar (artık her prosedür için çalışacak)
  void scheduleReminderFromProcedure(ProcedureModel procedure) {
    int daysFromNow = 30; // varsayılan
    String noteText = 'Yasal işlem süreci takip ediliyor.';

    if (procedure.criticalNote != null) {
      noteText = procedure.criticalNote!;
      final lowerNote = noteText.toLowerCase();
      if (lowerNote.contains('15 gün')) daysFromNow = 15;
      if (lowerNote.contains('3 ay')) daysFromNow = 90;
      if (lowerNote.contains('6 ay')) daysFromNow = 180;
    }

    addProcedureDeadline(
      procedureId: procedure.id,
      title: '⚡ ${procedure.name}',
      note: noteText,
      daysFromNow: daysFromNow,
    );
  }

  // Form Verisi Güncelle
  void updateField(String key, String value) {
    _formData[key] = value;
    notifyListeners();
  }

  String? getMissingFieldWarning() {
    if (_formData['fullName']?.isEmpty ?? true) return "Lütfen Ad Soyad giriniz.";
    if (_formData['idNumber']?.isEmpty ?? true) return "T.C. Kimlik No zorunludur.";
    if (_formData['incidentSummary']?.isEmpty ?? true) return "Olay özetini yazmalısınız.";
    return null;
  }

  // İş Mantığı: Dilekçe Oluşturulabilir mi?
  // Form bilgileri artık sonraki ekranda (PetitionGeneratorScreen) alındığı için
  // bu kontrolü her zaman 'true' döndürecek şekilde güncelliyoruz.
  bool get canCreatePetition => true;

  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  void reset() {
    _selectedCategory = null;
    _currentProcedure = null;
    _currentStep = 0;
    _formData.clear();
    notifyListeners();
  }
}


