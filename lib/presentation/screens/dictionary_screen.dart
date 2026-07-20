import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/settings_controller.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final List<DictionaryTerm> _terms;

  @override
  void initState() {
    super.initState();
    _terms = _buildTerms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DictionaryTerm> _buildTerms() {
    final terms = [
      const DictionaryTerm(
        termTr: 'Müddeabih',
        termEn: 'Müddeabih (Subject Matter)',
        definitionTr: 'Bir davada dava konusu edilen şey, uyuşmazlığın maddi değeri.',
        definitionEn: 'The subject matter of a lawsuit; the financial or material value of the dispute.',
      ),
      const DictionaryTerm(
        termTr: 'Tezyid-i Bedel',
        termEn: 'Tezyid-i Bedel (Value Increase)',
        definitionTr: 'Bedel artırımı; özellikle kamulaştırma davalarında bedelin düşük bulunması durumunda açılan artırım davası.',
        definitionEn: 'Increase of value; a lawsuit filed for increasing the compensation value, especially in expropriation cases when the initial valuation is low.',
      ),
      const DictionaryTerm(
        termTr: 'İhtiyati Tedbir',
        termEn: 'İhtiyati Tedbir (Preliminary Injunction)',
        definitionTr: 'Davanın devamı sırasında hakkın elde edilmesini güvence altına almak için verilen geçici hukuki koruma.',
        definitionEn: 'Preliminary injunction / interim measure; temporary legal protection granted during a lawsuit to secure the eventual realization of a right.',
      ),
      const DictionaryTerm(
        termTr: 'Fesih',
        termEn: 'Fesih (Termination)',
        definitionTr: 'Mevcut bir hukuki ilişkiyi veya sözleşmeyi tek taraflı bir irade beyanıyla sona erdirme.',
        definitionEn: 'Termination; ending an existing legal relationship or contract through a unilateral declaration of intent.',
      ),
      const DictionaryTerm(
        termTr: 'İstinaf',
        termEn: 'İstinaf (Appeal)',
        definitionTr: 'Yerel mahkeme kararının hem maddi vakıa hem de hukuki yönden üst mahkemece (BAM) incelenmesi yolu.',
        definitionEn: 'Appeal; the review of a local court\'s decision by a regional court of appeal (BAM) from both factual and legal perspectives.',
      ),
      const DictionaryTerm(
        termTr: 'İnfaz',
        termEn: 'İnfaz (Execution)',
        definitionTr: 'Mahkeme tarafından verilen ve kesinleşen kararın yerine getirilmesi süreci.',
        definitionEn: 'Execution / enforcement; the process of carrying out a final and binding court judgment.',
      ),
      const DictionaryTerm(
        termTr: 'Tebliğ',
        termEn: 'Tebliğ (Notification)',
        definitionTr: 'Hukuki bir işlemin yetkili makamca ilgili kişinin bilgisine resmi olarak sunulması.',
        definitionEn: 'Notification / service of process; the official formal delivery of a legal document or action to the relevant person by an authorized body.',
      ),
      const DictionaryTerm(
        termTr: 'Muvazaa',
        termEn: 'Muvazaa (Collusion)',
        definitionTr: 'Tarafların üçüncü kişileri aldatmak amacıyla, gerçek iradelerine uymayan bir sözleşme yapmaları.',
        definitionEn: 'Collusion / sham transaction; a transaction or agreement made by parties with the intent to deceive third parties, which does not reflect their true intentions.',
      ),
      const DictionaryTerm(
        termTr: 'Tereke',
        termEn: 'Tereke (Estate)',
        definitionTr: 'Ölen bir kimseden mirasçılarına geçen mal, hak ve borçların tamamı.',
        definitionEn: 'Estate / inheritance; the entirety of the assets, rights, and debts left by a deceased person to their heirs.',
      ),
      const DictionaryTerm(
        termTr: 'Beyyine',
        termEn: 'Beyyine (Evidence)',
        definitionTr: 'Bir iddiayı doğrulamaya yarayan her türlü hukuki delil ve kanıt.',
        definitionEn: 'Evidence / proof; any legal means or proof used to substantiate a claim or allegation.',
      ),
      const DictionaryTerm(
        termTr: 'Gıyap',
        termEn: 'Gıyap (Absence)',
        definitionTr: 'Bir tarafın mahkemede hazır bulunmaması durumu; yokluk.',
        definitionEn: 'Absence; the state of a party not being present in court; default.',
      ),
      const DictionaryTerm(
        termTr: 'Derdest',
        termEn: 'Derdest (Pending)',
        definitionTr: 'Bir davanın henüz sonuçlanmamış, mahkemede görülmekte olması hali.',
        definitionEn: 'Pending; the status of a lawsuit that has not yet been resolved and is currently being heard in court.',
      ),
      const DictionaryTerm(
        termTr: 'İbra',
        termEn: 'İbra (Release)',
        definitionTr: 'Alacaklının hakkından vazgeçerek borçluyu borçtan kurtarması işlemi.',
        definitionEn: 'Release / discharge; the legal act by which a creditor waives their right, thereby releasing the debtor from the obligation.',
      ),
      const DictionaryTerm(
        termTr: 'Mücbir Sebep',
        termEn: 'Mücbir Sebep (Force Majeure)',
        definitionTr: 'Kişinin kontrolü dışında gerçekleşen, öngörülemeyen ve borcun ifasını engelleyen olağanüstü durum (deprem, savaş vb.).',
        definitionEn: 'Force Majeure; an extraordinary, unforeseeable event beyond a person\'s control that prevents the performance of an obligation (e.g., earthquake, war).',
      ),
      const DictionaryTerm(
        termTr: 'Hususumet',
        termEn: 'Hususumet (Standing)',
        definitionTr: 'Davada taraf olma sıfatı; davanın doğru kişiye karşı açılıp açılmadığı durumu.',
        definitionEn: 'Adversity / standing / party status; the legal standing or status of being a party to a lawsuit; whether the lawsuit has been brought against the correct person.',
      ),
      const DictionaryTerm(
        termTr: 'İvazsız',
        termEn: 'İvazsız (Gratuitous)',
        definitionTr: 'Karşılıksız, bedelsiz yapılan hukuki işlem (Örn: Bağışlama).',
        definitionEn: 'Gratuitous / without consideration; a legal transaction performed without receiving anything in return (e.g., a donation).',
      ),
      const DictionaryTerm(
        termTr: 'Kusur',
        termEn: 'Kusur (Fault)',
        definitionTr: 'Hukuka aykırı bir sonucun doğmasına yol açan irade eksikliği (ihmal veya kast).',
        definitionEn: 'Fault; a deficiency of will or care (negligence or intent) that leads to an unlawful result.',
      ),
      const DictionaryTerm(
        termTr: 'Müruruzaman',
        termEn: 'Müruruzaman (Statute of Limitations)',
        definitionTr: 'Zamanaşımı; bir hakkın belirli bir sürede kullanılmaması sonucu dava edilebilme özelliğini yitirmesi.',
        definitionEn: 'Statute of Limitations / prescription; the expiration of a legal timeframe, after which a right can no longer be asserted or sued upon.',
      ),
      const DictionaryTerm(
        termTr: 'Nafaka',
        termEn: 'Nafaka (Alimony)',
        definitionTr: 'Geçimini sağlamakta zorlanan kişiye, yakınları tarafından ödenmesine hükmedilen maddi yardım.',
        definitionEn: 'Alimony / maintenance; financial support ordered by a court to be paid by a person to their relatives or ex-spouse who are in financial need.',
      ),
      const DictionaryTerm(
        termTr: 'Vesayet',
        termEn: 'Vesayet (Guardianship)',
        definitionTr: 'Reşit olmayan veya kısıtlanan kişilerin haklarını korumak amacıyla atanan hukuki temsil yetkisi.',
        definitionEn: 'Guardianship / tutelage; the legal authority and duty appointed to protect the rights and interests of minors or legally restricted persons.',
      ),
      const DictionaryTerm(
        termTr: 'İstirdat',
        termEn: 'İstirdat (Recovery)',
        definitionTr: 'Haksız yere ödenen bir şeyin geri alınması amacıyla açılan geri alım davası.',
        definitionEn: 'Replevin / action for recovery; a lawsuit filed to recover money or property that was paid or delivered without legal grounds.',
      ),
      const DictionaryTerm(
        termTr: 'Zilyetlik',
        termEn: 'Zilyetlik (Possession)',
        definitionTr: 'Bir eşya üzerinde fiilen hakimiyet kurma durumu.',
        definitionEn: 'Possession; the state of having actual physical control or custody over a tangible object.',
      ),
      const DictionaryTerm(
        termTr: 'Feragat',
        termEn: 'Feragat (Waiver)',
        definitionTr: 'Bir haktan veya açılmış olan davadan kendi isteğiyle vazgeçme.',
        definitionEn: 'Waiver / renunciation; voluntarily relinquishing or giving up a legal right or a pending lawsuit.',
      ),
      const DictionaryTerm(
        termTr: 'İkametgah',
        termEn: 'İkametgah (Domicile)',
        definitionTr: 'Bir kimsenin yerleşmek niyetiyle oturduğu hukuki adres.',
        definitionEn: 'Domicile / legal residence; the official legal address where a person resides with the intention of making it their permanent home.',
      ),
      const DictionaryTerm(
        termTr: 'Karine',
        termEn: 'Karine (Presumption)',
        definitionTr: 'Bilinen bir olaydan, bilinmeyen bir olay için çıkarılan hukuki sonuç.',
        definitionEn: 'Presumption; a legal inference or deduction drawn from a known fact to establish an unknown fact.',
      ),
      const DictionaryTerm(
        termTr: 'Mehil',
        termEn: 'Mehil (Grace Period)',
        definitionTr: 'Bir işlemin yapılması için tanınan ek süre.',
        definitionEn: 'Grace period / extension; an additional timeframe or deadline granted for performing a specific legal act.',
      ),
      const DictionaryTerm(
        termTr: 'Rücu',
        termEn: 'Rücu (Recourse)',
        definitionTr: 'Bir kişinin ödediği bedeli, asıl sorumlu olan kişiden geri istemesi hakkı.',
        definitionEn: 'Recourse / subrogation / right of return; the legal right of a person who has made a payment to seek reimbursement from the party primarily liable.',
      ),
      const DictionaryTerm(
        termTr: 'Şerh',
        termEn: 'Şerh (Annotation)',
        definitionTr: 'Bir taşınmazın durumunu belirtmek için tapu kütüğüne yazılan açıklayıcı not.',
        definitionEn: 'Annotation / encumbrance; an explanatory or restrictive note registered in the land registry to indicate the status of real property.',
      ),
      const DictionaryTerm(
        termTr: 'Vekalet',
        termEn: 'Vekalet (Power of Attorney)',
        definitionTr: 'Bir kimsenin başka bir kimseyi kendi adına işlem yapması için yetkilendirmesi.',
        definitionEn: 'Power of Attorney / proxy; the legal authorization given by one person to another to act or make decisions on their behalf.',
      ),
      const DictionaryTerm(
        termTr: 'Yürütmeyi Durdurma',
        termEn: 'Yürütmeyi Durdurma (Stay of Execution)',
        definitionTr: 'İdari işlemin uygulanmasının, davanın sonuna kadar geçici olarak askıya alınması.',
        definitionEn: 'Stay of execution / suspension of decision; the temporary suspension of the implementation of an administrative act until the end of the lawsuit.',
      ),
    ];
    // Sort by whichever language name we are showing (by default Turkish)
    terms.sort((a, b) => a.termTr.compareTo(b.termTr));
    return terms;
  }

  void _onSearchChanged(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final isTr = settings.language == AppLanguage.tr;

    final query = _searchController.text.trim().toLowerCase();
    final filteredTerms = _terms.where((term) {
      if (query.isEmpty) return true;
      final termText = isTr ? term.termTr : term.termEn;
      final defText = isTr ? term.definitionTr : term.definitionEn;
      return termText.toLowerCase().contains(query) || defText.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.translate('dictionary_title')),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: settings.translate('dictionary_search_hint'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.8),
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: filteredTerms.isEmpty
                  ? Center(
                      child: Text(
                        settings.translate('dictionary_no_match'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredTerms.length,
                      itemBuilder: (context, index) {
                        final term = filteredTerms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _DictionaryCard(term: term, isTr: isTr),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DictionaryCard extends StatelessWidget {
  final DictionaryTerm term;
  final bool isTr;
  const _DictionaryCard({required this.term, required this.isTr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr ? term.termTr : term.termEn,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            isTr ? term.definitionTr : term.definitionEn,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}

class DictionaryTerm {
  final String termTr;
  final String termEn;
  final String definitionTr;
  final String definitionEn;

  const DictionaryTerm({
    required this.termTr,
    required this.termEn,
    required this.definitionTr,
    required this.definitionEn,
  });
}
