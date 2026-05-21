// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Eksiksiz Hukuk & Prosedür Bankası (V2.0)
// ═══════════════════════════════════════════════════════════════════════════

import '../models/procedure_model.dart';

class ServiceDefinitions {
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

  // --- VATANDAŞLIK DETAYLARI ---
  static ProcedureModel _kimlikIslemleri() => ProcedureModel(
        id: 'vatandaslik-kimlik',
        category: ProcedureCategory.vatandaslik,
        name: 'T.C. Kimlik Kartı İşlemleri',
        applicationVenue: 'Nüfus ve Vatandaşlık Müdürlüğü / e-Devlet',
        fee: 'Ücretsiz (İlk çıkarma) / Kayıp: 240 ₺',
        estimatedDuration: '3-7 İş Günü',
        criticalNote: 'İpucu: PTT kargo ile teslim seçeneğini kullanan vatandaşlar kimliklerini evde teslim alabilir.',
        steps: [
          'e-Devlet veya Nüfus Müdürlüğü üzerinden randevu alın.',
          'Biyometrik fotoğraf çektirin (son 6 ay içinde).',
          'Varsa eski kimlik kartını veya karakol kayıp tutanağını hazırlayın.',
          'Harç makbuzunu (kayıp durumunda) bankadan ya da e-Devlet üzerinden ödeyin.',
          'Randevu gününde müdürlüğe gidin ve parmak izini verin.',
          'Kimliğinizi müdürlükten veya PTT kargo ile teslim alın.',
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Biyometrik Fotoğraf', isCritical: true),
          RequiredDocument(name: 'Eski Kimlik / Nüfus Cüzdanı', isCritical: false),
          RequiredDocument(name: 'Karakol Tutanağı (Kayıp durumunda)', isCritical: false),
          RequiredDocument(name: 'Harç Makbuzu (Kayıp durumunda)', isCritical: false),
        ],
      );

  static ProcedureModel _yatirimVatandaslik() => ProcedureModel(
        id: 'vatandaslik-yatirim',
        category: ProcedureCategory.vatandaslik,
        name: 'Yatırım Yoluyla Vatandaşlık',
        applicationVenue: 'Çevre, Şehircilik ve İklim Değişikliği Bakanlığı',
        fee: 'Min. 400.000 USD Gayrimenkul Yatırımı',
        estimatedDuration: '6-12 Ay',
        criticalNote: 'Önemli: Satın alınan gayrimenkulün en az 3 yıl boyunca satılmaması zorunludur. Satılması halinde vatandaşlık iptal edilebilir.',
        steps: [
          'En az 400.000 USD değerinde gayrimenkul satın alın.',
          'Tapu devir işlemini gerçekleştirin ve tapuya "3 yıl satış yasağı" şerhi koydurduğunuzdan emin olun.',
          'Yeminli tercüman aracılığıyla tüm yabancı dildeki belgeleri Türkçeye tercüme ettirin.',
          'Sabıka kaydı (apostilli) ve pasaportu noter onaylı tercümesiyle hazırlayın.',
          'Uygunluk Belgesi için Çevre Bakanlığı\'na başvurun.',
          'İl Göç İdaresi Müdürlüğü üzerinden vatandaşlık başvurusu yapın.',
          'Mülakat davetini bekleyin ve başvuru sürecini takip edin.',
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Tapu Belgesi (+ 3 Yıl Şerh)', isCritical: true),
          RequiredDocument(name: 'Banka Transfer Dekontu (USD)', isCritical: true),
          RequiredDocument(name: 'Apostilli Sabıka Kaydı', isCritical: true),
          RequiredDocument(name: 'Pasaport (Noterce Onaylı Türkçe Çeviri)', isCritical: true),
          RequiredDocument(name: 'Biyometrik Fotoğraf (x4)', isCritical: true),
          RequiredDocument(name: 'Uygunluk Belgesi (Bakanlıktan)', isCritical: true),
          RequiredDocument(name: 'Kira Sözleşmesi / İkametgah Belgesi', isCritical: false),
        ],
      );

  static ProcedureModel _evlilikVatandaslik() => ProcedureModel(
        id: 'vatandaslik-evlilik',
        category: ProcedureCategory.vatandaslik,
        name: 'Evlilik Yoluyla Vatandaşlık',
        applicationVenue: 'İl Göç İdaresi Müdürlüğü',
        fee: '5.000 ₺ - 12.000 ₺ (Harç + Tercüme)',
        estimatedDuration: '12-24 Ay',
        criticalNote: 'Dikkat: Evliliğin gerçek olmadığı tespit edilirse vatandaşlık başvurusu kalıcı olarak reddedilir. Mülakat aşamasında eşlerin ayrı ayrı sorgulanması yapılır.',
        steps: [
          'Türk vatandaşı eşinizle yasal evliliği tamamlayın (en az 3 yıl şartı).',
          'Medeni hal belgesi, evlilik cüzdanı ve nüfus kaydı örneğini edinin.',
          'Apostilli sabıka kaydını yurt dışından temin edin ve Türkçeye tercüme ettirin.',
          'Aile birliği kriterlerini kanıtlayan belgeler toplayın (ortak banka hesabı, kira sözleşmesi, fatura).',
          'Biyometrik fotoğraf çektirin.',
          'İl Göç İdaresi Müdürlüğü\'ne başvuru dosyanızı teslim edin.',
          'Mülakat davetini bekleyin; eşinizle birlikte mülakata katılın.',
          'Cumhurbaşkanlığı onayını takip edin.',
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Evlilik Cüzdanı (Türkçe Tercümeli)', isCritical: true),
          RequiredDocument(name: 'Apostilli Sabıka Kaydı', isCritical: true),
          RequiredDocument(name: 'Biyometrik Fotoğraf (x4)', isCritical: true),
          RequiredDocument(name: 'Aile Birliği Kanıtı (Ortak hesap, fatura)', isCritical: true),
          RequiredDocument(name: 'Nüfus Kayıt Örneği (Türk Eş)', isCritical: true),
          RequiredDocument(name: 'Harç Makbuzu', isCritical: true),
          RequiredDocument(name: 'İkametgah / Kira Sözleşmesi', isCritical: false),
        ],
      );

  // --- KİRA DETAYLARI ---
  static ProcedureModel _kiraTahliye() => ProcedureModel(
        id: 'kira-tahliye',
        category: ProcedureCategory.kira,
        name: 'Tahliye Taahhütnamesi Süreci',
        applicationVenue: 'İcra Müdürlüğü',
        fee: '1.250 ₺ - 2.500 ₺',
        estimatedDuration: '3-6 Ay',
        steps: ['Tarih kontrolü yapın.', '1 ay içinde takip başlatın.', 'Tahliye emri gönderin.'],
        requiredDocuments: [RequiredDocument(name: 'Taahhütname Aslı'), RequiredDocument(name: 'Kira Sözleşmesi')],
        criticalNote: 'Ekstra Çözüm: Kiracı çıkmazsa İcra Ceza Mahkemesi\'nde "taahhüde uymama" davası açılabilir.',
      );

  static ProcedureModel _kiraTespit() => ProcedureModel(
        id: 'kira-tespit',
        category: ProcedureCategory.kira,
        name: 'Kira Tespit Davası (5. Yıl)',
        applicationVenue: 'Sulh Hukuk Mahkemesi',
        fee: 'Harca Esas Değerin %11.38\'i',
        estimatedDuration: '1-1.5 Yıl',
        steps: ['5 yılın dolmasını bekleyin.', 'Arabulucuya başvurun.', 'Emsal kira bedellerini toplayın.'],
        requiredDocuments: [RequiredDocument(name: 'Kira Sözleşmesi'), RequiredDocument(name: 'Emsal İlanlar')],
        criticalNote: 'Püf Noktası: Dava açılmadan 30 gün önce ihtar çekilirse, mahkemenin belirlediği kira yeni dönemin başından itibaren geçerli olur.',
      );

  static ProcedureModel _kiraIhtiyac() => ProcedureModel(
        id: 'kira-ihtiyac',
        category: ProcedureCategory.kira,
        name: 'İhtiyaç Sebebiyle Tahliye',
        applicationVenue: 'Sulh Hukuk Mahkemesi',
        fee: '2.000 ₺ - 4.000 ₺ (Dava Masrafı)',
        estimatedDuration: '8-14 Ay',
        steps: ['İhtiyacın gerçek olduğunu kanıtlayın.', 'Dönem sonundan en az 3 ay önce ihtar çekin.', 'Süresi içinde davayı açın.'],
        requiredDocuments: [RequiredDocument(name: 'İhtarname'), RequiredDocument(name: 'İhtiyacı kanıtlayan belgeler')],
        criticalNote: 'Dikkat: İhtiyaç sebebiyle çıkarılan kiracının yerine 3 yıl boyunca başkası alınamaz, aksi halde tazminat ödenir.',
      );

  static ProcedureModel _kiraArtis() => ProcedureModel(
        id: 'kira-artis',
        category: ProcedureCategory.kira,
        name: 'Fahiş Kira Artışına İtiraz',
        applicationVenue: 'Arabuluculuk Merkezi',
        fee: 'Ücretsiz',
        estimatedDuration: '1-3 Ay',
        steps: ['TÜFE oranını hesaplayın.', 'Yazılı itiraz yapın.', 'Banka kanalıyla yasal tutarı ödeyin.'],
        requiredDocuments: [RequiredDocument(name: 'Dekontlar')],
      );

  // --- TAPU DETAYLARI ---
  static ProcedureModel _tapuAileKonutu() => ProcedureModel(
        id: 'tapu-aile',
        category: ProcedureCategory.tapu,
        name: 'Aile Konutu Şerhi Koydurma',
        applicationVenue: 'Tapu Müdürlüğü',
        fee: 'Ücretsiz / Döner Sermaye',
        estimatedDuration: '1 Gün',
        steps: ['Nüfus kayıt örneği alın.', 'Muhtarlıktan yerleşim yeri belgesi alın.', 'Tapu dairesine şerh talebinde bulunun.'],
        requiredDocuments: [RequiredDocument(name: 'Evlilik Cüzdanı'), RequiredDocument(name: 'İkametgah')],
        criticalNote: 'Koruma: Bu şerh sayesinde eşiniz, sizin rızanız olmadan evi satamaz veya ipotek edemez.',
      );

  static ProcedureModel _tapuIntikal() => ProcedureModel(
        id: 'tapu-intikal',
        category: ProcedureCategory.tapu,
        name: 'Miras Kalan Tapu İntikali',
        applicationVenue: 'WebTapu',
        fee: '400 ₺ - 800 ₺',
        estimatedDuration: '2-5 İş Günü',
        steps: ['Veraset ilamı alın.', 'Belediye borcu yoktur yazısı alın.', 'WebTapu başvurusu yapın.'],
        requiredDocuments: [RequiredDocument(name: 'Veraset İlamı')],
      );

  static ProcedureModel _tapuIpotek() => ProcedureModel(
        id: 'tapu-ipotek',
        category: ProcedureCategory.tapu,
        name: 'İpotek Kaldırma (Fek)',
        applicationVenue: 'Banka / e-Devlet',
        fee: '450 ₺',
        estimatedDuration: '1-3 Gün',
        steps: ['Kredi borcunu kapatın.', 'Bankaya talimat verin.', 'WebTapu harcını ödeyin.'],
        requiredDocuments: [RequiredDocument(name: 'Banka Fek Yazısı')],
      );

  static ProcedureModel _tapuSatisVaadi() => ProcedureModel(
        id: 'tapu-vaat',
        category: ProcedureCategory.tapu,
        name: 'Satış Vaadi Şerhi İşletme',
        applicationVenue: 'Tapu Müdürlüğü',
        fee: 'Binde 6.83',
        estimatedDuration: '1 Gün',
        steps: ['Noterde satış vaadi sözleşmesi yapın.', 'Notere tapuya şerh yetkisi verin.', 'Tapu harçlarını ödeyin.'],
        requiredDocuments: [RequiredDocument(name: 'Noter Onaylı Sözleşme')],
        criticalNote: 'Avantaj: Bu şerh 5 yıl geçerlidir ve mülkün başkasına satılmasını fiilen engeller.',
      );

  // --- SGK DETAYLARI ---
  static ProcedureModel _sgkGssItiraz() => ProcedureModel(
        id: 'sgk-gss',
        category: ProcedureCategory.sgk,
        name: 'GSS Prim Borcu İtirazı',
        applicationVenue: 'Kaymakamlık / Sosyal Yardımlaşma',
        fee: 'Ücretsiz',
        estimatedDuration: '15-30 Gün',
        steps: ['Gelir testi yaptırın.', 'Geliriniz düşükse borç silinmesi talep edin.', 'İtiraz dilekçesi verin.'],
        requiredDocuments: [RequiredDocument(name: 'Gelir Testi Sonucu')],
        criticalNote: 'Alternatif: Gelir testi sonucunda hane halkı geliri asgari ücretin 1/3\'ünden azsa primler devlet tarafından ödenir.',
      );

  static ProcedureModel _sgkEmeklilik() => ProcedureModel(
        id: 'sgk-emeklilik',
        category: ProcedureCategory.sgk,
        name: 'EYT / Normal Emeklilik Başvurusu',
        applicationVenue: 'e-Devlet',
        fee: 'Ücretsiz',
        estimatedDuration: '1-2 Ay',
        steps: ['Primleri kontrol edin.', 'Aylık talebi oluşturun.', 'Banka seçin.'],
        requiredDocuments: [RequiredDocument(name: 'Hizmet Dökümü')],
      );

  static ProcedureModel _sgkOlumAyligi() => ProcedureModel(
        id: 'sgk-olum',
        category: ProcedureCategory.sgk,
        name: 'Ölüm Aylığı (Dul/Yetim) Başvurusu',
        applicationVenue: 'SGK İl Müdürlüğü',
        fee: 'Ücretsiz',
        estimatedDuration: '1 Ay',
        steps: ['Vefat eden yakının prim gününü kontrol edin (En az 900 gün).', 'Tahsis talep formu doldurun.', 'Nüfus kayıt örneği ekleyin.'],
        requiredDocuments: [RequiredDocument(name: 'Ölüm Belgesi'), RequiredDocument(name: 'Vukuatlı Nüfus Kaydı')],
      );

  // --- PASAPORT DETAYLARI ---
  static ProcedureModel _pasaportHususi() => ProcedureModel(
        id: 'pasaport-hususi',
        category: ProcedureCategory.pasaport,
        name: 'Yeşil Pasaport Başvurusu',
        applicationVenue: 'Nüfus Müdürlüğü',
        fee: '790 ₺',
        estimatedDuration: '3-7 Gün',
        steps: ['Talep formu alın.', 'Randevuya gidin.', 'Fotoğraf teslim edin.'],
        requiredDocuments: [RequiredDocument(name: 'Onaylı Form')],
      );

  static ProcedureModel _pasaportBordo() => ProcedureModel(
        id: 'pasaport-bordo',
        category: ProcedureCategory.pasaport,
        name: 'Normal (Bordo) Pasaport Çıkartma',
        applicationVenue: 'Nüfus Müdürlüğü',
        fee: 'Değişken (Süreye Göre)',
        estimatedDuration: '3-10 Gün',
        steps: ['Randevu alın.', 'Harç ve defter bedelini ödeyin.', 'Biyometrik fotoğraf çektirin.', 'Nüfus randevusuna gidin.'],
        requiredDocuments: [RequiredDocument(name: 'Kimlik Kartı'), RequiredDocument(name: 'Biyometrik Fotoğraf'), RequiredDocument(name: 'Eski Pasaport (Varsa)')],
      );

  static ProcedureModel _pasaportOgrenci() => ProcedureModel(
        id: 'pasaport-ogrenci',
        category: ProcedureCategory.pasaport,
        name: 'Öğrenci Pasaportu İşlemleri',
        applicationVenue: 'Nüfus Müdürlüğü',
        fee: 'Sadece Defter Bedeli',
        estimatedDuration: '3-10 Gün',
        steps: ['Öğrenci belgesi edinin.', 'Defter bedelini ödeyin (Harçtan muaf).', 'Biyometrik fotoğraf çektirin.', 'Nüfus randevusuna gidin.'],
        requiredDocuments: [RequiredDocument(name: 'Öğrenci Belgesi'), RequiredDocument(name: 'Kimlik Kartı'), RequiredDocument(name: 'Biyometrik Fotoğraf')],
        criticalNote: 'İpucu: 25 yaş altı öğrenciler harç ödemeden sadece defter bedeliyle pasaport alabilirler.',
      );

  static ProcedureModel _pasaportKayip() => ProcedureModel(
        id: 'pasaport-kayip',
        category: ProcedureCategory.pasaport,
        name: 'Kaybolan Pasaport İşlemleri',
        applicationVenue: 'Karakol / Nüfus Müdürlüğü',
        fee: 'Yeni Pasaport Ücreti',
        estimatedDuration: '5-10 Gün',
        steps: ['En yakın karakola kayıp bildirimi yapın.', 'Gazete ilanı (Opsiyonel ama önerilir).', 'Yeni pasaport başvurusu yapın.'],
        requiredDocuments: [RequiredDocument(name: 'Karakol Tutanağı'), RequiredDocument(name: 'Nüfus Cüzdanı')],
      );

  // --- TAŞIT DETAYLARI ---
  static ProcedureModel _tasitCezaItiraz() => ProcedureModel(
        id: 'tasit-ceza',
        category: ProcedureCategory.tasit,
        name: 'Trafik Cezasına İtiraz',
        applicationVenue: 'Sulh Ceza Hakimliği',
        fee: 'Ücretsiz (Haklı çıkılırsa)',
        estimatedDuration: '2-6 Ay',
        steps: ['Cezanın tebliğinden itibaren 15 gün içinde başvurun.', 'İtiraz dilekçesi yazın.', 'Varsa kamera görüntülerini ekleyin.'],
        requiredDocuments: [RequiredDocument(name: 'Ceza Tutanağı'), RequiredDocument(name: 'Ruhsat Fotokopisi')],
        criticalNote: 'Püf Noktası: Cezayı 15 gün içinde %25 indirimli ödeyip sonra itiraz edebilirsiniz. Kazanırsanız ödediğiniz para iade edilir.',
      );

  static ProcedureModel _tasitPlaka() => ProcedureModel(
        id: 'tasit-plaka',
        category: ProcedureCategory.tasit,
        name: 'Noter Satışı ve Plaka Değişimi',
        applicationVenue: 'Noter',
        fee: '950 ₺ - 1.200 ₺',
        estimatedDuration: '1 Saat',
        steps: ['Notere plaka değişikliği istediğinizi söyleyin.', 'Eski plakaları söküp teslim edin.', 'Şoförler Odası\'ndan yeni plakayı bastırın.'],
        requiredDocuments: [RequiredDocument(name: 'Noter Satış Sözleşmesi')],
      );

  static ProcedureModel _tasitMtv() => ProcedureModel(
        id: 'tasit-mtv',
        category: ProcedureCategory.tasit,
        name: 'MTV Ödeme ve Yapılandırma',
        applicationVenue: 'İnteraktif Vergi Dairesi',
        fee: 'Araç Tipine Göre Değişken',
        estimatedDuration: '10 Dakika',
        steps: ['e-Devlet ile vergi dairesine girin.', 'Borç sorgulayın.', 'Kredi kartı ile taksitli ödeyin.'],
        requiredDocuments: [RequiredDocument(name: 'T.C. Kimlik No'), RequiredDocument(name: 'Plaka No')],
        criticalNote: 'Ekstra: Aracınızın kasko değeri, ödediğiniz MTV\'den düşükse bir alt kademeden vergi ödeme hakkınız olabilir.',
      );

  // --- EĞİTİM İŞLEMLERİ ---
  static ProcedureModel _egitimKyk() => ProcedureModel(
        id: 'egitim-kyk',
        category: ProcedureCategory.egitim,
        name: 'KYK Yurt ve Burs/Kredi Başvurusu',
        applicationVenue: 'e-Devlet (GSB)',
        fee: 'Ücretsiz',
        estimatedDuration: 'Değerlendirme: 1-2 Ay',
        steps: [
          'e-Devlet üzerinden "Gençlik ve Spor Bakanlığı" hizmetlerine girin.',
          'Burs/Kredi veya Yurt başvuru ekranını açın.',
          'Aile ve gelir beyanınızı doldurun.',
          'Başvuruyu onaylayın ve sonuç ekranını periyodik olarak kontrol edin.',
          'Sonuç açıklandıktan sonra e-Devlet\'ten taahhütname onayı yapın.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Öğrenci Belgesi', isCritical: true),
          RequiredDocument(name: 'Gelir Beyanı (Gerekirse)'),
        ],
        criticalNote: 'Önemli: Taahhütname onayı yapılmayan burs ve krediler iptal olur.',
      );

  static ProcedureModel _egitimBelge() => ProcedureModel(
        id: 'egitim-belge',
        category: ProcedureCategory.egitim,
        name: 'Öğrenci Belgesi ve Diploma Denklik',
        applicationVenue: 'e-Devlet (YÖK/MEB)',
        fee: 'Ücretsiz',
        estimatedDuration: 'Anında / 1-3 Ay (Denklik)',
        steps: [
          'e-Devlet\'e giriş yapın.',
          '"YÖK Öğrenci Belgesi Sorgulama" hizmetini aratın.',
          'Karekodlu belgenizi indirin veya barkodunu paylaşın.',
          'Yurt dışı diploma denkliği için YÖK Denklik Başvuru sistemine girin.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'T.C. Kimlik No', isCritical: true),
          RequiredDocument(name: 'Yurt Dışı Diploma (Denklik için)'),
        ],
      );

  static ProcedureModel _egitimSinav() => ProcedureModel(
        id: 'egitim-sinav',
        category: ProcedureCategory.egitim,
        name: 'Sınav Başvuruları (ÖSYM/MEB)',
        applicationVenue: 'ÖSYM AİS / MEB',
        fee: 'Sınava Göre Değişken',
        estimatedDuration: '15 Dakika',
        steps: [
          'ÖSYM Aday İşlemleri Sistemine (AİS) e-Devlet ile girin.',
          'İlgili sınavı seçip başvuru adımlarını tamamlayın.',
          'Sınav merkezi tercihlerinizi yapın.',
          'Sınav ücretini ÖSYM ödeme sistemi veya bankalar aracılığıyla yatırın.',
          'Sınavdan bir hafta önce "Sınava Giriş Belgesi"ni döküm alın.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'HES Kodu (Gerekiyorsa)'),
          RequiredDocument(name: 'Güncel Biyometrik Fotoğraf (AİS Sisteminde)', isCritical: true),
        ],
      );

  // --- AİLE VE MEDENİ HAL ---
  static ProcedureModel _aileEvlilik() => ProcedureModel(
        id: 'aile-evlilik',
        category: ProcedureCategory.aile,
        name: 'Evlilik Hazırlık Süreci',
        applicationVenue: 'Evlendirme Dairesi',
        fee: 'Ortalama 500 ₺ - 2000 ₺ (Belediyeye göre)',
        estimatedDuration: 'Rapor: 1-3 Gün, Başvuru: 1 Gün',
        steps: [
          'e-Devlet\'ten Evlenme Ehliyet Belgesi kontrolü yapın.',
          'Aile hekiminden veya devlet hastanesinden Evlilik Sağlık Raporu alın.',
          'Biyometrik fotoğraf çektirin.',
          'İlgili belediyenin evlendirme dairesine çift olarak başvurun.',
          'Nikah tarihi alın ve harcı yatırın.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Evlilik Sağlık Raporu', isCritical: true),
          RequiredDocument(name: 'Nüfus Cüzdanı Aslı ve Fotokopisi', isCritical: true),
          RequiredDocument(name: 'Vesikalık/Biyometrik Fotoğraf (4-6 Adet)'),
        ],
      );

  static ProcedureModel _aileDogum() => ProcedureModel(
        id: 'aile-dogum',
        category: ProcedureCategory.aile,
        name: 'Yeni Doğan Kimlik Başvurusu',
        applicationVenue: 'Nüfus Müdürlüğü',
        fee: 'Ücretsiz (İlk Kayıt)',
        estimatedDuration: '1-3 İş Günü',
        steps: [
          'Hastaneden çocuğun Doğum Raporu\'nu teslim alın.',
          'Doğum tarihinden itibaren 30 gün içinde (yurt içi) veya 60 gün içinde (yurt dışı) Nüfus Müdürlüğüne başvurun.',
          'Yeni kimlik kartı basımı için başvuruyu tamamlayın.',
          'e-Devlet üzerinden Aile ve Sosyal Hizmetler Bakanlığı Çocuk Yardımına (Doğum Yardımı) başvurun.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Doğum Raporu (Hastaneden)', isCritical: true),
          RequiredDocument(name: 'Anne ve Babanın Kimlikleri', isCritical: true),
        ],
        criticalNote: 'Unutmayın: Çocuğunuz doğduktan sonra ilk 30 gün içinde SGK girişi (anne/baba üzerinden) otomatik yapılır, manuel aktivasyon gerektirebilir.',
      );

  static ProcedureModel _aileAdres() => ProcedureModel(
        id: 'aile-adres',
        category: ProcedureCategory.aile,
        name: 'Adres Değişikliği ve Nüfus Kaydı',
        applicationVenue: 'e-Devlet / Nüfus Müdürlüğü',
        fee: 'Ücretsiz',
        estimatedDuration: 'Anında',
        steps: [
          'e-Devlet üzerinden "Adres Değişikliği Bildirimi" araması yapın.',
          'Yeni adresinize kendinizi veya ailenizi taşıyın.',
          'Eğer adres boş değilse (başka biri kayıtlı görünüyorsa), elektrik/su faturası veya kira sözleşmesi ile Nüfus Müdürlüğüne bizzat gidin.',
          'İşlem sonrası e-Devlet üzerinden yeni İkametgah Belgesi (Yerleşim Yeri) dökümü alabilirsiniz.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Kira Sözleşmesi veya Fatura (Bizzat gidilecekse)', isCritical: true),
          RequiredDocument(name: 'İkametgah Belgesi', source: 'Arşiv'),
        ],
      );

  // --- DİJİTAL DEVLET VE ABONELİKLER ---
  static ProcedureModel _dijitalAbonelik() => ProcedureModel(
        id: 'dijital-abonelik',
        category: ProcedureCategory.dijitalDevlet,
        name: 'Abonelik Yönetimi (Elektrik/Su/Doğalgaz)',
        applicationVenue: 'e-Devlet',
        fee: 'Güvence Bedeli (Kuruma göre)',
        estimatedDuration: '1-2 İş Günü',
        steps: [
          'e-Devlet üzerinden ilgili kurumun hizmet sayfasına gidin (Örn: İSKİ, BEDAŞ).',
          '"Yeni Abonelik Başvurusu" veya "Abonelik Fesih" seçeneğine tıklayın.',
          'Tesisat numarası ve DASK poliçe bilgilerini girin.',
          'Çıkan güvence bedelini kredi kartı ile ödeyin veya faturaya yansıtılmasını onaylayın.',
          'Onay sonrası ekiplerin açma/kapama işlemi için gelmesini bekleyin.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'DASK Poliçesi', isCritical: true),
          RequiredDocument(name: 'Tesisat/Sayaç Numarası', isCritical: true),
        ],
      );

  static ProcedureModel _dijitalAdli() => ProcedureModel(
        id: 'dijital-adli',
        category: ProcedureCategory.dijitalDevlet,
        name: 'Adli Sicil ve Hukuk Takibi (UYAP)',
        applicationVenue: 'e-Devlet / UYAP Vatandaş',
        fee: 'Ücretsiz',
        estimatedDuration: 'Anında',
        steps: [
          'e-Devlet üzerinden "Adli Sicil Kaydı Sorgulama" araması yapın.',
          'Belgenin verileceği kurum türünü seçerek barkodlu Adli Sicil belgesini indirin.',
          'Davalarınızı takip etmek için "UYAP Vatandaş Portal"ına giriş yapın.',
          'Dosya sorgulama ekranından dava dosyalarının güncel durumunu, duruşma tarihlerini ve tebligatları inceleyin.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Adli Sicil Belgesi', source: 'Arşiv'),
        ],
      );

  static ProcedureModel _dijitalCimer() => ProcedureModel(
        id: 'dijital-cimer',
        category: ProcedureCategory.dijitalDevlet,
        name: 'İletişim Başkanlığı (CİMER)',
        applicationVenue: 'e-Devlet (CİMER)',
        fee: 'Ücretsiz',
        estimatedDuration: '15-30 Gün',
        steps: [
          'e-Devlet üzerinden "CİMER Başvurusu" sayfasına girin.',
          'Başvuru türünü (Şikayet, İstek, Bilgi Edinme, İhbar vb.) seçin.',
          'Konuyu açık ve net bir dille anlatan dilekçe metnini ilgili alana yazın.',
          'Varsa görsel veya belge (PDF, JPG) ekleyin.',
          'Başvuruyu onaylayın ve verilen Başvuru Numarası ile süreci takip edin.'
        ],
        requiredDocuments: [
          RequiredDocument(name: 'Kanıt Nitelikli Fotoğraf/Belge (Önerilir)'),
        ],
      );

  static List<ProcedureModel> getByCategory(ProcedureCategory category) {
    return getAll().where((p) => p.category == category).toList();
  }
}


