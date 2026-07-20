import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart' as p;
import '../models/legal_document_model.dart';

class SavedLocation {
  final int? id;
  final String title;
  final double latitude;
  final double longitude;
  final double heading;
  final DateTime savedAt;

  const SavedLocation({
    this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedLocation.fromMap(Map<String, dynamic> map) {
    return SavedLocation(
      id: map['id'] as int?,
      title: map['title'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      heading: (map['heading'] as num).toDouble(),
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }
}

class LocationDatabaseService {
  static final LocationDatabaseService _instance = LocationDatabaseService._internal();
  factory LocationDatabaseService() => _instance;
  LocationDatabaseService._internal();

  static Database? _database;
  static const String _dbName    = 'pusula_locations.db';
  static const int    _dbVersion  = 2;
  static const String _tableName  = 'saved_locations';
  static const String _legalTable = 'legal_documents';
  static const String _legalDocumentBoxName = 'legal_documents_box';

  DatabaseFactory get _databaseFactory {
    if (kIsWeb) {
      return databaseFactoryFfiWebNoWebWorker;
    }
    return databaseFactory;
  }

  Future<void> init() async {
    if (kIsWeb) {
      if (!Hive.isBoxOpen(_legalDocumentBoxName)) {
        await Hive.openBox(_legalDocumentBoxName);
      }
      return;
    }

    if (_database != null) return;
    _database = await _openDatabase();
    await _ensureTables();
  }

  Future<Database> _openDatabase() async {
    final String dbPath = kIsWeb
        ? _dbName
        : p.join(await getDatabasesPath(), _dbName);

    return await _databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createSavedLocationsTable(db);
    await _createLegalDocumentsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createLegalDocumentsTable(db);
    }
  }

  Future<void> _createSavedLocationsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        title     TEXT    NOT NULL,
        latitude  REAL    NOT NULL,
        longitude REAL    NOT NULL,
        heading   REAL    NOT NULL DEFAULT 0.0,
        savedAt   TEXT    NOT NULL
      )
    ''');
  }

  Future<void> _createLegalDocumentsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_legalTable (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        title             TEXT    NOT NULL,
        category          TEXT    NOT NULL,
        date              TEXT    NOT NULL,
        fileSizeOrSubtitle TEXT   NOT NULL DEFAULT '',
        isTimelineOnly    INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _ensureTables() async {
    if (_database == null) return;
    await _createSavedLocationsTable(_database!);
    await _createLegalDocumentsTable(_database!);
  }

  Database get _db {
    if (_database == null) throw Exception("Database not initialized");
    return _database!;
  }

  Box get _legalDocumentBox {
    if (!Hive.isBoxOpen(_legalDocumentBoxName)) {
      throw Exception('Legal document box not initialized');
    }
    return Hive.box(_legalDocumentBoxName);
  }

  Future<void> saveLegalDocument(LegalDocument doc) async {
    if (kIsWeb) {
      final box = _legalDocumentBox;
      final nextId = DateTime.now().microsecondsSinceEpoch;
      await box.put(
        nextId.toString(),
        {
          'id': nextId,
          'title': doc.title,
          'category': doc.category,
          'date': doc.date,
          'fileSizeOrSubtitle': doc.fileSizeOrSubtitle,
          'isTimelineOnly': doc.isTimelineOnly,
        },
      );
      return;
    }

    await _db.execute(
      '''
      INSERT INTO $_legalTable (
        title,
        category,
        date,
        fileSizeOrSubtitle,
        isTimelineOnly
      ) VALUES (?, ?, ?, ?, ?)
      ''',
      [
        doc.title,
        doc.category,
        doc.date,
        doc.fileSizeOrSubtitle,
        doc.isTimelineOnly,
      ],
    );
  }

  Future<List<LegalDocument>> fetchLegalDocuments() async {
    if (kIsWeb) {
      final documents = _legalDocumentBox.values
          .whereType<Map>()
          .map((item) => LegalDocument.fromMap(Map<String, dynamic>.from(item)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return documents;
    }

    final maps = await _db.query(_legalTable, orderBy: 'date DESC');
    return maps.map(LegalDocument.fromMap).toList();
  }

  Future<int> deleteLegalDocument(int id) async {
    if (kIsWeb) {
      await _legalDocumentBox.delete(id.toString());
      return 1;
    }

    return await _db.delete(_legalTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> seedLegalDocumentsIfEmpty() async {
    if (kIsWeb) {
      if (_legalDocumentBox.isNotEmpty) return;

      final seeds = [
        LegalDocument(title: 'Kira_Sözleşmesi_Mayıs.pdf', category: 'Kira', date: '2024-05-12', fileSizeOrSubtitle: '1.2 MB'),
        LegalDocument(title: 'UYAP Durum Kontrolü', category: 'Diğer', date: '2024-05-05', fileSizeOrSubtitle: 'Portal', isTimelineOnly: 1),
      ];
      for (final doc in seeds) {
        await saveLegalDocument(doc);
      }
      return;
    }

    try {
      final count = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $_legalTable')) ?? 0;
      if (count > 0) return;
    } catch (_) {
      await _createLegalDocumentsTable(_db);
    }

    final seeds = [
      LegalDocument(title: 'Kira_Sözleşmesi_Mayıs.pdf', category: 'Kira', date: '2024-05-12', fileSizeOrSubtitle: '1.2 MB'),
      LegalDocument(title: 'UYAP Durum Kontrolü', category: 'Diğer', date: '2024-05-05', fileSizeOrSubtitle: 'Portal', isTimelineOnly: 1),
    ];
    for (final doc in seeds) { await saveLegalDocument(doc); }
  }
}


