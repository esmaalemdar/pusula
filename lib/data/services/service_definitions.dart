// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Hukuk ve Prosedür Bankası (Localization Merged)
// ═══════════════════════════════════════════════════════════════════════════

import '../models/procedure_model.dart';
import 'settings_controller.dart';

class ServiceDefinitions {
  static String _t(String tr, String en) {
    return SettingsController().language == AppLanguage.tr ? tr : en;
  }

  static List<String> _steps(List<String> tr, List<String> en) {
    return SettingsController().language == AppLanguage.tr ? tr : en;
  }

  static RequiredDocument _doc(String trName, String enName, {bool isCritical = true, String? source}) {
    return RequiredDocument(
      name: _t(trName, enName),
      isCritical: isCritical,
      source: source,
    );
  }

  static List<ProcedureModel> getAll() => [
        // ── VATANDAŞLIK ──
        _kimlikIslemleri(),
        _yatirimVatandaslik(),
        _evlilikVatandaslik(),

        // ── KİRA HUKUKU ──
        _kiraTahliye(),
        _kiraArtis(),
        _kiraTespit(),
        _kiraIhtiyac(),

        // ── TAPU VE EMLAK ──
        _tapuIntikal(),
        _tapuIpotek(),
        _tapuAileKonutu(),
        _tapuSatisVaadi(),

        // ── SGK VE EMEKLİLİK ──
        _sgkEmeklilik(),
        _sgkGssItiraz(),
        _sgkOlumAyligi(),

        // ── PASAPORT VE NÜFUS ──
        _pasaportHususi(),
        _pasaportBordo(),
        _pasaportOgrenci(),
        _pasaportKayip(),

        // ── TAŞIT İŞLEMLERİ ──
        _tasitPlaka(),
        _tasitCezaItiraz(),
        _tasitMtv(),

        // ── EĞİTİM İŞLEMLERİ ──
        _egitimKyk(),
        _egitimBelge(),
        _egitimSinav(),

        // ── AİLE VE MEDENİ HAL ──
        _aileEvlilik(),
        _aileDogum(),
        _aileAdres(),

        // ── DİJİTAL DEVLET ──
        _dijitalAbonelik(),
        _dijitalAdli(),
        _dijitalCimer(),
      ];

  static ProcedureModel _kimlikIslemleri() => ProcedureModel(
        id: 'vatandaslik-kimlik',
        category: ProcedureCategory.vatandaslik,
        name: _t('T.C. Kimlik Kartı İşlemleri', 'National ID Card Procedures'),
        applicationVenue: _t('Nüfus ve Vatandaşlık Müdürlüğü / e-Devlet', 'Civil Registry Office / e-Government'),
        fee: _t('Ücretsiz (İlk çıkarma) / Kayıp: 240 ₺', 'Free (First issue) / Lost: 240 ₺'),
        estimatedDuration: _t('3-7 İş Günü', '3–7 Business Days'),
        criticalNote: _t('İpucu: PTT kargo ile teslim seçeneğini kullanan vatandaşlar kimliklerini evde teslim alabilir.', 'Tip: Citizens who choose PTT cargo delivery can receive their ID at home.'),
        steps: _steps([
          'e-Devlet veya Nüfus Müdürlüğü üzerinden randevu alın.',
          'Biyometrik fotoğraf çektirin (son 6 ay içinde).',
          'Varsa eski kimlik kartını veya karakol kayıp tutanağını hazırlayın.',
          'Harç makbuzunu (kayıp durumunda) bankadan ya da e-Devlet üzerinden ödeyin.',
          'Randevu gününde müdürlüğe gidin ve parmak izini verin.',
          'Kimliğinizi müdürlükten veya PTT kargo ile teslim alın.',
        ], [
          'Schedule an appointment via e-Government or the Civil Registry Office.',
          'Have a biometric photo taken (within the last 6 months).',
          'Bring your old ID card or police lost-item report if applicable.',
          'Pay the fee (if lost) via bank or e-Government.',
          'Visit the office on your appointment day and provide fingerprints.',
          'Collect your ID from the office or receive it via PTT cargo.',
        ]),
        requiredDocuments: [
          _doc('Biyometrik Fotoğraf', 'Biometric Photo'),
          _doc('Eski Kimlik / Nüfus Cüzdanı', 'Old ID Card / Civil Registry Card', isCritical: false),
          _doc('Karakol Tutanağı (Kayıp durumunda)', 'Police Lost-Item Report (if lost)', isCritical: false),
          _doc('Harç Makbuzu (Kayıp durumunda)', 'Fee Receipt (if lost)', isCritical: false),
        ],
      );

  static ProcedureModel _yatirimVatandaslik() => ProcedureModel(
        id: 'vatandaslik-yatirim',
        category: ProcedureCategory.vatandaslik,
        name: _t('Yatırım Yoluyla Vatandaşlık', 'Citizenship by Investment'),
        applicationVenue: _t('Çevre, Şehircilik ve İklim Değişikliği Bakanlığı', 'Ministry of Environment, Urbanization and Climate Change'),
        fee: _t('Min. 400.000 USD Gayrimenkul Yatırımı', 'Min. USD 400,000 Real Estate Investment'),
        estimatedDuration: _t('6-12 Ay', '6–12 Months'),
        criticalNote: _t('Önemli: Satın alınan gayrimenkulün en az 3 yıl boyunca satılmaması zorunludur. Satılması halinde vatandaşlık iptal edilebilir.', 'Important: The purchased real estate must not be sold for at least 3 years. Violation may result in citizenship cancellation.'),
        steps: _steps([
          'En az 400.000 USD değerinde gayrimenkul satın alın.',
          'Tapu devir işlemini gerçekleştirin ve tapuya "3 yıl satış yasağı" şerhi koydurduğunuzdan emin olun.',
          'Yeminli tercüman aracılığıyla tüm yabancı dildeki belgeleri Türkçeye tercüme ettirin.',
          'Sabıka kaydı (apostilli) ve pasaportu noter onaylı tercümesiyle hazırlayın.',
          'Uygunluk Belgesi için Çevre Bakanlığı\'na başvurun.',
          'İl Göç İdaresi Müdürlüğü üzerinden vatandaşlık başvurusu yapın.',
          'Mülakat davetini bekleyin ve başvuru sürecini takip edin.',
        ], [
          'Purchase real estate worth at least USD 400,000.',
          'Complete the title deed transfer and ensure a "3-year sales prohibition" annotation is registered.',
          'Have all foreign-language documents translated into Turkish by a sworn translator.',
          'Prepare an apostilled criminal record and a notarized passport translation.',
          'Apply for a Conformity Certificate from the Ministry of Environment.',
          'Submit your citizenship application via the Provincial Directorate of Migration Management.',
          'Await the interview invitation and follow up on the process.',
        ]),
        requiredDocuments: [
          _doc('Tapu Belgesi (+ 3 Yıl Şerh)', 'Title Deed (+ 3-Year Annotation)'),
          _doc('Banka Transfer Dekontu (USD)', 'Bank Transfer Receipt (USD)'),
          _doc('Apostilli Sabıka Kaydı', 'Apostilled Criminal Record'),
          _doc('Pasaport (Noterce Onaylı Türkçe Çeviri)', 'Passport (Notarized Turkish Translation)'),
          _doc('Biyometrik Fotoğraf (x4)', 'Biometric Photo (x4)'),
          _doc('Uygunluk Belgesi (Bakanlıktan)', 'Conformity Certificate (from Ministry)'),
          _doc('Kira Sözleşmesi / İkametgah Belgesi', 'Rental Agreement / Proof of Residence', isCritical: false),
        ],
      );

  static ProcedureModel _evlilikVatandaslik() => ProcedureModel(
        id: 'vatandaslik-evlilik',
        category: ProcedureCategory.vatandaslik,
        name: _t('Evlilik Yoluyla Vatandaşlık', 'Citizenship Through Marriage'),
        applicationVenue: _t('İl Göç İdaresi Müdürlüğü', 'Provincial Directorate of Migration Management'),
        fee: _t('5.000 ₺ - 12.000 ₺ (Harç + Tercüme)', '5,000 ₺ – 12,000 ₺ (Fee + Translation)'),
        estimatedDuration: _t('12-24 Ay', '12–24 Months'),
        criticalNote: _t('Dikkat: Evliliğin gerçek olmadığı tespit edilirse vatandaşlık başvurusu kalıcı olarak reddedilir. Mülakat aşamasında eşlerin ayrı ayrı sorgulanması yapılır.', 'Caution: If the marriage is found to be fraudulent, the citizenship application will be permanently rejected. Spouses are interviewed separately.'),
        steps: _steps([
          'Türk vatandaşı eşinizle yasal evliliği tamamlayın (en az 3 yıl şartı).',
          'Medeni hal belgesi, evlilik cüzdanı ve nüfus kaydı örneğini edinin.',
          'Apostilli sabıka kaydını yurt dışından temin edin ve Türkçeye tercüme ettirin.',
          'Aile birliği kriterlerini kanıtlayan belgeler toplayın (ortak banka hesabı, kira sözleşmesi, fatura).',
          'Biyometrik fotoğraf çektirin.',
          'İl Göç İdaresi Müdürlüğü\'ne başvuru dosyanızı teslim edin.',
          'Mülakat davetini bekleyin; eşinizle birlikte mülakata katılın.',
          'Cumhurbaşkanlığı onayını takip edin.',
        ], [
          'Complete a lawful marriage with a Turkish citizen (minimum 3-year requirement).',
          'Obtain a marital status certificate, marriage booklet, and civil registry record.',
          'Obtain an apostilled criminal record from abroad and have it translated into Turkish.',
          'Collect documents proving family unity (joint bank account, rental agreement, utility bills).',
          'Have biometric photos taken.',
          'Submit your application file to the Provincial Directorate of Migration Management.',
          'Await the interview invitation; attend the interview together with your spouse.',
          'Track the Presidential approval.',
        ]),
        requiredDocuments: [
          _doc('Evlilik Cüzdanı (Türkçe Tercümeli)', 'Marriage Booklet (Turkish Translation)'),
          _doc('Apostilli Sabıka Kaydı', 'Apostilled Criminal Record'),
          _doc('Biyometrik Fotoğraf (x4)', 'Biometric Photo (x4)'),
          _doc('Aile Birliği Kanıtı (Ortak hesap, fatura)', 'Proof of Family Unity (Joint account, bills)'),
          _doc('Nüfus Kayıt Örneği (Türk Eş)', 'Civil Registry Record (Turkish Spouse)'),
          _doc('Harç Makbuzu', 'Fee Receipt'),
          _doc('İkametgah / Kira Sözleşmesi', 'Residence / Rental Agreement', isCritical: false),
        ],
      );

  static ProcedureModel _kiraTahliye() => ProcedureModel(
        id: 'kira-tahliye',
        category: ProcedureCategory.kira,
        name: _t('Tahliye Taahhütnamesi Süreci', 'Eviction Undertaking Process'),
        applicationVenue: _t('İcra Müdürlüğü', 'Enforcement Office (İcra Müdürlüğü)'),
        fee: _t('1.250 ₺ - 2.500 ₺', '1,250 ₺ – 2,500 ₺'),
        estimatedDuration: _t('3-6 Ay', '3–6 Months'),
        criticalNote: _t('Ekstra Çözüm: Kiracı çıkmazsa İcra Ceza Mahkemesi\'nde "taahhüde uymama" davası açılabilir.', 'Extra Option: If the tenant refuses to leave, a "non-compliance with undertaking" lawsuit can be filed at the Enforcement Criminal Court.'),
        steps: _steps([
          'Tarih kontrolü yapın.',
          '1 ay içinde takip başlatın.',
          'Tahliye emri gönderin.',
        ], [
          'Verify the date on the undertaking document.',
          'Initiate enforcement proceedings within 1 month.',
          'Serve the eviction order.',
        ]),
        requiredDocuments: [
          _doc('Taahhütname Aslı', 'Original Undertaking Document'),
          _doc('Kira Sözleşmesi', 'Rental Agreement'),
        ],
      );

  static ProcedureModel _kiraTespit() => ProcedureModel(
        id: 'kira-tespit',
        category: ProcedureCategory.kira,
        name: _t('Kira Tespit Davası (5. Yıl)', 'Rental Price Determination Lawsuit (5th Year)'),
        applicationVenue: _t('Sulh Hukuk Mahkemesi', 'Civil Court of Peace'),
        fee: _t('Harca Esas Değerin %11.38\'i', '11.38% of the Base Value'),
        estimatedDuration: _t('1-1.5 Yıl', '1–1.5 Years'),
        criticalNote: _t('Püf Noktası: Dava açılmadan 30 gün önce ihtar çekilirse, mahkemenin belirlediği kira yeni dönemin başından itibaren geçerli olur.', 'Key Point: If a notary notice is served 30 days before filing the lawsuit, the court-determined rent applies from the start of the new period.'),
        steps: _steps([
          '5 yılın dolmasını bekleyin.',
          'Arabulucuya başvurun.',
          'Emsal kira bedellerini toplayın.',
        ], [
          'Wait for the 5-year period to expire.',
          'Apply to a mediator.',
          'Collect comparable rental price evidence.',
        ]),
        requiredDocuments: [
          _doc('Kira Sözleşmesi', 'Rental Agreement'),
          _doc('Emsal İlanlar', 'Comparable Listings'),
        ],
      );

  static ProcedureModel _kiraIhtiyac() => ProcedureModel(
        id: 'kira-ihtiyac',
        category: ProcedureCategory.kira,
        name: _t('İhtiyaç Sebebiyle Tahliye', 'Eviction Due to Owner\'s Genuine Need'),
        applicationVenue: _t('Sulh Hukuk Mahkemesi', 'Civil Court of Peace'),
        fee: _t('2.000 ₺ - 4.000 ₺ (Dava Masrafı)', '2,000 ₺ – 4,000 ₺ (Court Costs)'),
        estimatedDuration: _t('8-14 Ay', '8–14 Months'),
        criticalNote: _t('Dikkat: İhtiyaç sebebiyle çıkarılan kiracının yerine 3 yıl boyunca başkası alınamaz, aksi halde tazminat ödenir.', 'Caution: A tenant evicted due to genuine need cannot be replaced by another tenant for 3 years; otherwise, compensation is payable.'),
        steps: _steps([
          'İhtiyacın gerçek olduğunu kanıtlayın.',
          'Dönem sonundan en az 3 ay önce ihtar çekin.',
          'Süresi içinde davayı açın.',
        ], [
          'Prove that the need is genuine.',
          'Serve a notary notice at least 3 months before the end of the lease period.',
          'File the lawsuit within the legal deadline.',
        ]),
        requiredDocuments: [
          _doc('İhtarname', 'Notary Notice'),
          _doc('İhtiyacı kanıtlayan belgeler', 'Documents proving the genuine need'),
        ],
      );

  static ProcedureModel _kiraArtis() => ProcedureModel(
        id: 'kira-artis',
        category: ProcedureCategory.kira,
        name: _t('Fahiş Kira Artışına İtiraz', 'Objection to Excessive Rent Increase'),
        applicationVenue: _t('Arabuluculuk Merkezi', 'Mediation Center'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('1-3 Ay', '1–3 Months'),
        steps: _steps([
          'TÜFE oranını hesaplayın.',
          'Yazılı itiraz yapın.',
          'Banka kanalıyla yasal tutarı ödeyin.',
        ], [
          'Calculate the CPI (TÜFE) rate.',
          'Submit a written objection.',
          'Pay the legal amount via bank transfer.',
        ]),
        requiredDocuments: [
          _doc('Dekontlar', 'Bank Transfer Receipts'),
        ],
      );

  static ProcedureModel _tapuAileKonutu() => ProcedureModel(
        id: 'tapu-aile',
        category: ProcedureCategory.tapu,
        name: _t('Aile Konutu Şerhi Koydurma', 'Family Residence Annotation (Title Deed)'),
        applicationVenue: _t('Tapu Müdürlüğü', 'Land Registry Office'),
        fee: _t('Ücretsiz / Döner Sermaye', 'Free / Revolving Fund Fee'),
        estimatedDuration: _t('1 Gün', '1 Day'),
        criticalNote: _t('Koruma: Bu şerh sayesinde eşiniz, sizin rızanız olmadan evi satamaz veya ipotek edemez.', 'Protection: With this annotation, your spouse cannot sell or mortgage the home without your consent.'),
        steps: _steps([
          'Nüfus kayıt örneği alın.',
          'Muhtarlıktan yerleşim yeri belgesi alın.',
          'Tapu dairesine şerh talebinde bulunun.',
        ], [
          'Obtain a civil registry record.',
          'Get a Residence Certificate from the local Muhtar\'s office.',
          'Apply for the annotation at the Land Registry Office.',
        ]),
        requiredDocuments: [
          _doc('Evlilik Cüzdanı', 'Marriage Booklet'),
          _doc('İkametgah', 'Proof of Residence'),
        ],
      );

  static ProcedureModel _tapuIntikal() => ProcedureModel(
        id: 'tapu-intikal',
        category: ProcedureCategory.tapu,
        name: _t('Miras Kalan Tapu İntikali', 'Inherited Title Deed Transfer'),
        applicationVenue: _t('WebTapu', 'WebTapu'),
        fee: _t('400 ₺ - 800 ₺', '400 ₺ – 800 ₺'),
        estimatedDuration: _t('2-5 İş Günü', '2–5 Business Days'),
        steps: _steps([
          'Veraset ilamı alın.',
          'Belediye borcu yoktur yazısı alın.',
          'WebTapu başvurusu yapın.',
        ], [
          'Obtain a certificate of inheritance.',
          'Get a "no municipal debt" letter.',
          'Submit application via WebTapu.',
        ]),
        requiredDocuments: [
          _doc('Veraset İlamı', 'Certificate of Inheritance'),
        ],
      );

  static ProcedureModel _tapuIpotek() => ProcedureModel(
        id: 'tapu-ipotek',
        category: ProcedureCategory.tapu,
        name: _t('İpotek Kaldırma (Fek)', 'Mortgage Release'),
        applicationVenue: _t('Banka / e-Devlet', 'Bank / e-Government'),
        fee: _t('450 ₺', '450 ₺'),
        estimatedDuration: _t('1-3 Gün', '1–3 Days'),
        steps: _steps([
          'Kredi borcunu kapatın.',
          'Bankaya talimat verin.',
          'WebTapu harcını ödeyin.',
        ], [
          'Close the loan balance.',
          'Instruct the bank to issue a release letter.',
          'Pay the WebTapu fee.',
        ]),
        requiredDocuments: [
          _doc('Banka Fek Yazısı', 'Bank Mortgage Release Letter'),
        ],
      );

  static ProcedureModel _tapuSatisVaadi() => ProcedureModel(
        id: 'tapu-vaat',
        category: ProcedureCategory.tapu,
        name: _t('Satış Vaadi Şerhi İşletme', 'Promise of Sale Annotation'),
        applicationVenue: _t('Tapu Müdürlüğü', 'Land Registry Office'),
        fee: _t('Binde 6.83', '0.683% of Property Value'),
        estimatedDuration: _t('1 Gün', '1 Day'),
        criticalNote: _t('Avantaj: Bu şerh 5 yıl geçerlidir ve mülkün başkasına satılmasını fiilen engeller.', 'Advantage: This annotation is valid for 5 years and effectively prevents the property from being sold to a third party.'),
        steps: _steps([
          'Noterde satış vaadi sözleşmesi yapın.',
          'Notere tapuya şerh yetkisi verin.',
          'Tapu harçlarını ödeyin.',
        ], [
          'Execute a promise-of-sale agreement at a notary.',
          'Authorize the notary to register the annotation.',
          'Pay the title deed fees.',
        ]),
        requiredDocuments: [
          _doc('Noter Onaylı Sözleşme', 'Notarized Agreement'),
        ],
      );

  static ProcedureModel _sgkGssItiraz() => ProcedureModel(
        id: 'sgk-gss',
        category: ProcedureCategory.sgk,
        name: _t('GSS Prim Borcu İtirazı', 'General Health Insurance Premium Debt Objection'),
        applicationVenue: _t('Kaymakamlık / Sosyal Yardımlaşma', 'District Governorship / Social Assistance Office'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('15-30 Gün', '15–30 Days'),
        criticalNote: _t('Alternatif: Gelir testi sonucunda hane halkı geliri asgari ücretin 1/3\'ünden azsa primler devlet tarafından ödenir.', 'Alternative: If household income is below 1/3 of the minimum wage per the income test, premiums are paid by the state.'),
        steps: _steps([
          'Gelir testi yaptırın.',
          'Geliriniz düşükse borç silinmesi talep edin.',
          'İtiraz dilekçesi verin.',
        ], [
          'Have an income assessment conducted.',
          'If your income is low, request debt cancellation.',
          'Submit an objection petition.',
        ]),
        requiredDocuments: [
          _doc('Gelir Testi Sonucu', 'Income Assessment Result'),
        ],
      );

  static ProcedureModel _sgkEmeklilik() => ProcedureModel(
        id: 'sgk-emeklilik',
        category: ProcedureCategory.sgk,
        name: _t('EYT / Normal Emeklilik Başvurusu', 'Retirement Application (EYT / Standard)'),
        applicationVenue: _t('e-Devlet', 'e-Government'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('1-2 Ay', '1–2 Months'),
        steps: _steps([
          'Primleri kontrol edin.',
          'Aylık talebi oluşturun.',
          'Banka seçin.',
        ], [
          'Check your premium days.',
          'Create a monthly pension request.',
          'Select your bank.',
        ]),
        requiredDocuments: [
          _doc('Hizmet Dökümü', 'Service Record Statement'),
        ],
      );

  static ProcedureModel _sgkOlumAyligi() => ProcedureModel(
        id: 'sgk-olum',
        category: ProcedureCategory.sgk,
        name: _t('Ölüm Aylığı (Dul/Yetim) Başvurusu', 'Survivor\'s Pension (Widow / Orphan) Application'),
        applicationVenue: _t('SGK İl Müdürlüğü', 'SSI Provincial Directorate'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('1 Ay', '1 Month'),
        steps: _steps([
          'Vefat eden yakının prim gününü kontrol edin (En az 900 gün).',
          'Tahsis talep formu doldurun.',
          'Nüfus kayıt örneği ekleyin.',
        ], [
          'Check the deceased relative\'s premium days (minimum 900 days required).',
          'Fill in the allocation request form.',
          'Attach the civil registry record.',
        ]),
        requiredDocuments: [
          _doc('Ölüm Belgesi', 'Death Certificate'),
          _doc('Vukuatlı Nüfus Kaydı', 'Comprehensive Civil Registry Record'),
        ],
      );

  static ProcedureModel _pasaportHususi() => ProcedureModel(
        id: 'pasaport-hususi',
        category: ProcedureCategory.pasaport,
        name: _t('Yeşil Pasaport Başvurusu', 'Green Passport Application'),
        applicationVenue: _t('Nüfus Müdürlüğü', 'Civil Registry Office'),
        fee: _t('790 ₺', '790 ₺'),
        estimatedDuration: _t('3-7 Gün', '3–7 Days'),
        steps: _steps([
          'Talep formu alın.',
          'Randevuya gidin.',
          'Fotoğraf teslim edin.',
        ], [
          'Obtain the application form.',
          'Attend your appointment.',
          'Submit your biometric photo.',
        ]),
        requiredDocuments: [
          _doc('Onaylı Form', 'Approved Application Form'),
        ],
      );

  static ProcedureModel _pasaportBordo() => ProcedureModel(
        id: 'pasaport-bordo',
        category: ProcedureCategory.pasaport,
        name: _t('Normal (Bordo) Pasaport Çıkartma', 'Standard (Burgundy) Passport Application'),
        applicationVenue: _t('Nüfus Müdürlüğü', 'Civil Registry Office'),
        fee: _t('Değişken (Süreye Göre)', 'Variable (by validity period)'),
        estimatedDuration: _t('3-10 Gün', '3–10 Days'),
        steps: _steps([
          'Randevu alın.',
          'Harç ve defter bedelini ödeyin.',
          'Biyometrik fotoğraf çektirin.',
          'Nüfus randevusuna gidin.',
        ], [
          'Schedule an appointment.',
          'Pay the fee and booklet cost.',
          'Have a biometric photo taken.',
          'Attend your civil registry appointment.',
        ]),
        requiredDocuments: [
          _doc('Kimlik Kartı', 'National ID Card'),
          _doc('Biyometrik Fotoğraf', 'Biometric Photo'),
          _doc('Eski Pasaport (Varsa)', 'Old Passport (if applicable)'),
        ],
      );

  static ProcedureModel _pasaportOgrenci() => ProcedureModel(
        id: 'pasaport-ogrenci',
        category: ProcedureCategory.pasaport,
        name: _t('Öğrenci Pasaportu İşlemleri', 'Student Passport Procedures'),
        applicationVenue: _t('Nüfus Müdürlüğü', 'Civil Registry Office'),
        fee: _t('Sadece Defter Bedeli', 'Booklet Cost Only'),
        estimatedDuration: _t('3-10 Gün', '3–10 Days'),
        criticalNote: _t('İpucu: 25 yaş altı öğrenciler harç ödemeden sadece defter bedeliyle pasaport alabilirler.', 'Tip: Students under 25 can obtain a passport by paying only the booklet cost, with no fee charge.'),
        steps: _steps([
          'Öğrenci belgesi edinin.',
          'Defter bedelini ödeyin (Harçtan muaf).',
          'Biyometrik fotoğraf çektirin.',
          'Nüfus randevusuna gidin.',
        ], [
          'Obtain a student enrollment certificate.',
          'Pay only the booklet cost (exempt from fees).',
          'Have a biometric photo taken.',
          'Attend your civil registry appointment.',
        ]),
        requiredDocuments: [
          _doc('Öğrenci Belgesi', 'Student Enrollment Certificate'),
          _doc('Kimlik Kartı', 'National ID Card'),
          _doc('Biyometrik Fotoğraf', 'Biometric Photo'),
        ],
      );

  static ProcedureModel _pasaportKayip() => ProcedureModel(
        id: 'pasaport-kayip',
        category: ProcedureCategory.pasaport,
        name: _t('Kaybolan Pasaport İşlemleri', 'Lost Passport Procedures'),
        applicationVenue: _t('Karakol / Nüfus Müdürlüğü', 'Police Station / Civil Registry Office'),
        fee: _t('Yeni Pasaport Ücreti', 'New Passport Fee'),
        estimatedDuration: _t('5-10 Gün', '5–10 Days'),
        steps: _steps([
          'En yakın karakola kayıp bildirimi yapın.',
          'Gazete ilanı (Opsiyonel ama önerilir).',
          'Yeni pasaport başvurusu yapın.',
        ], [
          'Report the loss at the nearest police station.',
          'Publish a newspaper announcement (optional but recommended).',
          'Apply for a new passport.',
        ]),
        requiredDocuments: [
          _doc('Karakol Tutanağı', 'Police Lost-Item Report'),
          _doc('Nüfus Cüzdanı', 'National ID Card'),
        ],
      );

  static ProcedureModel _tasitCezaItiraz() => ProcedureModel(
        id: 'tasit-ceza',
        category: ProcedureCategory.tasit,
        name: _t('Trafik Cezasına İtiraz', 'Traffic Fine Appeal'),
        applicationVenue: _t('Sulh Ceza Hakimliği', 'Magistrate\'s Court (Sulh Ceza Hakimliği)'),
        fee: _t('Ücretsiz (Haklı çıkılırsa)', 'Free (if successful)'),
        estimatedDuration: _t('2-6 Ay', '2–6 Months'),
        criticalNote: _t('Püf Noktası: Cezayı 15 gün içinde %25 indirimli ödeyip sonra itiraz edebilirsiniz. Kazanırsanız ödediğiniz para iade edilir.', 'Key Point: You can pay the fine at a 25% discount within 15 days and still appeal. If successful, you will be refunded.'),
        steps: _steps([
          'Cezanın tebliğinden itibaren 15 gün içinde başvurun.',
          'İtiraz dilekçesi yazın.',
          'Varsa kamera görüntülerini ekleyin.',
        ], [
          'Apply within 15 days of receiving the penalty notice.',
          'Write an appeal petition.',
          'Attach any camera footage if available.',
        ]),
        requiredDocuments: [
          _doc('Ceza Tutanağı', 'Penalty Notice'),
          _doc('Ruhsat Fotokopisi', 'Vehicle Registration Copy'),
        ],
      );

  static ProcedureModel _tasitPlaka() => ProcedureModel(
        id: 'tasit-plaka',
        category: ProcedureCategory.tasit,
        name: _t('Noter Satışı ve Plaka Değişimi', 'Notarized Vehicle Sale & License Plate Change'),
        applicationVenue: _t('Noter', 'Notary'),
        fee: _t('950 ₺ - 1.200 ₺', '950 ₺ – 1,200 ₺'),
        estimatedDuration: _t('1 Saat', '1 Hour'),
        steps: _steps([
          'Notere plaka değişikliği istediğinizi söyleyin.',
          'Eski plakaları söküp teslim edin.',
          'Şoförler Odası\'ndan yeni plakayı bastırın.',
        ], [
          'Inform the notary of the license plate change.',
          'Remove and hand over the old plates.',
          'Have new plates issued from the Drivers\' Association.',
        ]),
        requiredDocuments: [
          _doc('Noter Satış Sözleşmesi', 'Notarized Sale Agreement'),
        ],
      );

  static ProcedureModel _tasitMtv() => ProcedureModel(
        id: 'tasit-mtv',
        category: ProcedureCategory.tasit,
        name: _t('MTV Ödeme ve Yapılandırma', 'Motor Vehicle Tax (MTV) Payment & Restructuring'),
        applicationVenue: _t('İnteraktif Vergi Dairesi', 'Interactive Tax Office'),
        fee: _t('Araç Tipine Göre Değişken', 'Variable by Vehicle Type'),
        estimatedDuration: _t('10 Dakika', '10 Minutes'),
        criticalNote: _t('Ekstra: Aracınızın kasko değeri, ödediğiniz MTV\'den düşükse bir alt kademeden vergi ödeme hakkınız olabilir.', 'Extra: If your vehicle\'s insurance value is lower than your MTV, you may be eligible to pay tax at a lower bracket.'),
        steps: _steps([
          'e-Devlet ile vergi dairesine girin.',
          'Borç sorgulayın.',
          'Kredi kartı ile taksitli ödeyin.',
        ], [
          'Log into the Tax Office via e-Government.',
          'Query your debt.',
          'Pay in installments by credit card.',
        ]),
        requiredDocuments: [
          _doc('T.C. Kimlik No', 'TR Identity Number'),
          _doc('Plaka No', 'License Plate Number'),
        ],
      );

  static ProcedureModel _egitimKyk() => ProcedureModel(
        id: 'egitim-kyk',
        category: ProcedureCategory.egitim,
        name: _t('KYK Yurt ve Burs/Kredi Başvurusu', 'KYK Dormitory & Scholarship / Loan Application'),
        applicationVenue: _t('e-Devlet (GSB)', 'e-Government (Ministry of Youth & Sports)'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('Değerlendirme: 1-2 Ay', 'Review: 1–2 Months'),
        criticalNote: _t('Önemli: Taahhütname onayı yapılmayan burs ve krediler iptal olur.', 'Important: Scholarships and loans for which the undertaking form is not approved will be cancelled.'),
        steps: _steps([
          'e-Devlet üzerinden "Gençlik ve Spor Bakanlığı" hizmetlerine girin.',
          'Burs/Kredi veya Yurt başvuru ekranını açın.',
          'Aile ve gelir beyanınızı doldurun.',
          'Başvuruyu onaylayın ve sonuç ekranını periyodik olarak kontrol edin.',
          'Sonuç açıklandıktan sonra e-Devlet\'ten taahhütname onayı yapın.',
        ], [
          'Log into e-Government and navigate to Ministry of Youth and Sports services.',
          'Open the Scholarship/Loan or Dormitory application screen.',
          'Fill in your family and income declaration.',
          'Confirm the application and periodically check the results screen.',
          'After results are announced, approve the undertaking form via e-Government.',
        ]),
        requiredDocuments: [
          _doc('Öğrenci Belgesi', 'Student Enrollment Certificate'),
          _doc('Gelir Beyanı (Gerekirse)', 'Income Declaration (if required)'),
        ],
      );

  static ProcedureModel _egitimBelge() => ProcedureModel(
        id: 'egitim-belge',
        category: ProcedureCategory.egitim,
        name: _t('Öğrenci Belgesi ve Diploma Denklik', 'Student Certificate & Diploma Equivalency'),
        applicationVenue: _t('e-Devlet (YÖK/MEB)', 'e-Government (YÖK / MEB)'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('Anında / 1-3 Ay (Denklik)', 'Instant / 1–3 Months (Equivalency)'),
        steps: _steps([
          'e-Devlet\'e giriş yapın.',
          '"YÖK Öğrenci Belgesi Sorgulama" hizmetini aratın.',
          'Karekodlu belgenizi indirin veya barkodunu paylaşın.',
          'Yurt dışı diploma denkliği için YÖK Denklik Başvuru sistemine girin.',
        ], [
          'Log into e-Government.',
          'Search for the "YÖK Student Certificate Query" service.',
          'Download or share your QR-coded certificate.',
          'For foreign diploma equivalency, log into the YÖK Equivalency Application system.',
        ]),
        requiredDocuments: [
          _doc('T.C. Kimlik No', 'TR Identity Number'),
          _doc('Yurt Dışı Diploma (Denklik için)', 'Foreign Diploma (for equivalency)'),
        ],
      );

  static ProcedureModel _egitimSinav() => ProcedureModel(
        id: 'egitim-sinav',
        category: ProcedureCategory.egitim,
        name: _t('Sınav Başvuruları (ÖSYM/MEB)', 'Exam Applications (ÖSYM / MEB)'),
        applicationVenue: _t('ÖSYM AİS / MEB', 'ÖSYM AIS / MEB Portal'),
        fee: _t('Sınava Göre Değişken', 'Variable by Exam'),
        estimatedDuration: _t('15 Dakika', '15 Minutes'),
        steps: _steps([
          'ÖSYM Aday İşlemleri Sistemine (AİS) e-Devlet ile girin.',
          'İlgili sınavı seçip başvuru adımlarını tamamlayın.',
          'Sınav merkezi tercihlerinizi yapın.',
          'Sınav ücretini ÖSYM ödeme sistemi veya bankalar aracılığıyla yatırın.',
          'Sınavdan bir hafta önce "Sınava Giriş Belgesi"ni döküm alın.',
        ], [
          'Log into the ÖSYM Candidate Registration System (AIS) via e-Government.',
          'Select the relevant exam and complete the application steps.',
          'Choose your exam center preferences.',
          'Pay the exam fee via the ÖSYM payment system or banks.',
          'Print your "Exam Entry Document" one week before the exam.',
        ]),
        requiredDocuments: [
          _doc('HES Kodu (Gerekiyorsa)', 'HES Code (if required)'),
          _doc('Güncel Biyometrik Fotoğraf (AİS Sisteminde)', 'Current Biometric Photo (in AIS System)'),
        ],
      );

  static ProcedureModel _aileEvlilik() => ProcedureModel(
        id: 'aile-evlilik',
        category: ProcedureCategory.aile,
        name: _t('Evlilik Hazırlık Süreci', 'Marriage Application Process'),
        applicationVenue: _t('Evlendirme Dairesi', 'Marriage Registry Office'),
        fee: _t('Ortalama 500 ₺ - 2000 ₺ (Belediyeye göre)', 'Approx. 500 ₺ – 2,000 ₺ (varies by municipality)'),
        estimatedDuration: _t('Rapor: 1-3 Gün, Başvuru: 1 Gün', 'Health Report: 1–3 Days, Application: 1 Day'),
        steps: _steps([
          'e-Devlet\'ten Evlenme Ehliyet Belgesi kontrolü yapın.',
          'Aile hekiminden veya devlet hastanesinden Evlilik Sağlık Raporu alın.',
          'Biyometrik fotoğraf çektirin.',
          'İlgili belediyenin evlendirme dairesine çift olarak başvurun.',
          'Nikah tarihi alın ve harcı yatırın.',
        ], [
          'Check your Marriage Eligibility Certificate via e-Government.',
          'Obtain a Pre-Marital Health Report from your family doctor or a public hospital.',
          'Have biometric photos taken.',
          'Apply as a couple at the relevant municipality\'s marriage registry office.',
          'Receive a wedding date and pay the fee.',
        ]),
        requiredDocuments: [
          _doc('Evlilik Sağlık Raporu', 'Pre-Marital Health Report'),
          _doc('Nüfus Cüzdanı Aslı ve Fotokopisi', 'National ID Card (Original & Copy)'),
          _doc('Vesikalık/Biyometrik Fotoğraf (4-6 Adet)', 'Passport-size / Biometric Photos (4–6 pcs)'),
        ],
      );

  static ProcedureModel _aileDogum() => ProcedureModel(
        id: 'aile-dogum',
        category: ProcedureCategory.aile,
        name: _t('Yeni Doğan Kimlik Başvurusu', 'Newborn ID Registration'),
        applicationVenue: _t('Nüfus Müdürlüğü', 'Civil Registry Office'),
        fee: _t('Ücretsiz (İlk Kayıt)', 'Free (First Registration)'),
        estimatedDuration: _t('1-3 İş Günü', '1–3 Business Days'),
        criticalNote: _t('Unutmayın: Çocuğunuz doğduktan sonra ilk 30 gün içinde SGK girişi (anne/baba üzerinden) otomatik yapılır, manuel aktivasyon gerektirebilir.', 'Reminder: SSI enrollment for your newborn (under parent\'s coverage) is automatic within the first 30 days but may require manual activation.'),
        steps: _steps([
          'Hastaneden çocuğun Doğum Raporu\'nu teslim alın.',
          'Doğum tarihinden itibaren 30 gün içinde (yurt içi) veya 60 gün içinde (yurt dışı) Nüfus Müdürlüğüne başvurun.',
          'Yeni kimlik kartı basımı için başvuruyu tamamlayın.',
          'e-Devlet üzerinden Aile ve Sosyal Hizmetler Bakanlığı Çocuk Yardımına (Doğum Yardımı) başvurun.',
        ], [
          'Receive the Birth Report from the hospital.',
          'Apply to the Civil Registry Office within 30 days of birth (domestic) or 60 days (abroad).',
          'Complete the new ID card application.',
          'Apply for the Child Birth Grant via the Ministry of Family and Social Services on e-Government.',
        ]),
        requiredDocuments: [
          _doc('Doğum Raporu (Hastaneden)', 'Birth Report (from Hospital)'),
          _doc('Anne ve Babanın Kimlikleri', 'Parents\' ID Cards'),
        ],
      );

  static ProcedureModel _aileAdres() => ProcedureModel(
        id: 'aile-adres',
        category: ProcedureCategory.aile,
        name: _t('Adres Değişikliği ve Nüfus Kaydı', 'Address Change & Civil Registry Update'),
        applicationVenue: _t('e-Devlet / Nüfus Müdürlüğü', 'e-Government / Civil Registry Office'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('Anında', 'Instant'),
        steps: _steps([
          'e-Devlet üzerinden "Adres Değişikliği Bildirimi" araması yapın.',
          'Yeni adresinize kendinizi veya ailenizi taşıyın.',
          'Eğer adres boş değilse (başka biri kayıtlı görünüyorsa), elektrik/su faturası veya kira sözleşmesi ile Nüfus Müdürlüğüne bizzat gidin.',
          'İşlem sonrası e-Devlet üzerinden yeni İkametgah Belgesi (Yerleşim Yeri) dökümü alabilirsiniz.',
        ], [
          'Search for "Address Change Notification" on e-Government.',
          'Register yourself or your family at your new address.',
          'If the address is occupied (another person is registered), visit the Civil Registry Office in person with a utility bill or rental agreement.',
          'After the update, you can download a new Residence Certificate (Yerleşim Yeri) via e-Government.',
        ]),
        requiredDocuments: [
          _doc('Kira Sözleşmesi veya Fatura (Bizzat gidilecekse)', 'Rental Agreement or Utility Bill (if visiting in person)'),
          _doc('İkametgah Belgesi', 'Residence Certificate', source: _t('Arşiv', 'Archive')),
        ],
      );

  static ProcedureModel _dijitalAbonelik() => ProcedureModel(
        id: 'dijital-abonelik',
        category: ProcedureCategory.dijitalDevlet,
        name: _t('Abonelik Yönetimi (Elektrik/Su/Doğalgaz)', 'Utility Subscription Management (Electricity / Water / Gas)'),
        applicationVenue: _t('e-Devlet', 'e-Government'),
        fee: _t('Güvence Bedeli (Kuruma göre)', 'Security Deposit (varies by provider)'),
        estimatedDuration: _t('1-2 İş Günü', '1–2 Business Days'),
        steps: _steps([
          'e-Devlet üzerinden ilgili kurumun hizmet sayfasına gidin (Örn: İSKİ, BEDAŞ).',
          '"Yeni Abonelik Başvurusu" veya "Abonelik Fesih" seçeneğine tıklayın.',
          'Tesisat numarası ve DASK poliçe bilgilerini girin.',
          'Çıkan güvence bedelini kredi kartı ile ödeyin veya faturaya yansıtılmasını onaylayın.',
          'Onay sonrası ekiplerin açma/kapama işlemi için gelmesini bekleyin.',
        ], [
          'Go to the relevant provider\'s service page on e-Government (e.g., ISKI, BEDAS).',
          'Click "New Subscription Application" or "Cancel Subscription".',
          'Enter the installation number and DASK policy information.',
          'Pay the security deposit by credit card or confirm it will be added to the bill.',
          'After approval, wait for the technician team to connect or disconnect the service.',
        ]),
        requiredDocuments: [
          _doc('DASK Poliçesi', 'DASK Policy'),
          _doc('Tesisat/Sayaç Numarası', 'Installation / Meter Number'),
        ],
      );

  static ProcedureModel _dijitalAdli() => ProcedureModel(
        id: 'dijital-adli',
        category: ProcedureCategory.dijitalDevlet,
        name: _t('Adli Sicil ve Hukuk Takibi (UYAP)', 'Criminal Record & Court Tracking (UYAP)'),
        applicationVenue: _t('e-Devlet / UYAP Vatandaş', 'e-Government / UYAP Citizen Portal'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('Anında', 'Instant'),
        steps: _steps([
          'e-Devlet üzerinden "Adli Sicil Kaydı Sorgulama" araması yapın.',
          'Belgenin verileceği kurum türünü seçerek barkodlu Adli Sicil belgesini indirin.',
          'Davalarınızı takip etmek için "UYAP Vatandaş Portal"ına giriş yapın.',
          'Dosya sorgulama ekranından dava dosyalarının güncel durumunu, duruşma tarihlerini ve tebligatları inceleyin.',
        ], [
          'Search for "Criminal Record Query" on e-Government.',
          'Select the institution type and download the QR-coded Criminal Record document.',
          'Log into the "UYAP Citizen Portal" to track your court cases.',
          'From the case query screen, review the current status, hearing dates, and notifications of your case files.',
        ]),
        requiredDocuments: [
          _doc('Adli Sicil Belgesi', 'Criminal Record Document', source: _t('Arşiv', 'Archive')),
        ],
      );

  static ProcedureModel _dijitalCimer() => ProcedureModel(
        id: 'dijital-cimer',
        category: ProcedureCategory.dijitalDevlet,
        name: _t('İletişim Başkanlığı (CİMER)', 'Presidency of Communication (CIMER)'),
        applicationVenue: _t('e-Devlet (CİMER)', 'e-Government (CİMER)'),
        fee: _t('Ücretsiz', 'Free'),
        estimatedDuration: _t('15-30 Gün', '15–30 Days'),
        steps: _steps([
          'e-Devlet üzerinden "CİMER Başvurusu" sayfasına girin.',
          'Başvuru türünü (Şikayet, İstek, Bilgi Edinme, İhbar vb.) seçin.',
          'Konuyu açık ve net bir dille anlatan dilekçe metnini ilgili alana yazın.',
          'Varsa görsel veya belge (PDF, JPG) ekleyin.',
          'Başvuruyu onaylayın ve verilen Başvuru Numarası ile süreci takip edin.',
        ], [
          'Go to the "CİMER Application" page on e-Government.',
          'Select the application type (Complaint, Request, Information, Tip, etc.).',
          'Write your petition in a clear and concise manner in the relevant field.',
          'Attach any supporting images or documents (PDF, JPG) if available.',
          'Confirm the application and track the process using the provided Application Number.',
        ]),
        requiredDocuments: [
          _doc('Kanıt Nitelikli Fotoğraf/Belge (Önerilir)', 'Supporting Photo / Document (Recommended)'),
        ],
      );

  static List<ProcedureModel> getByCategory(ProcedureCategory category) {
    return getAll().where((p) => p.category == category).toList();
  }
}
