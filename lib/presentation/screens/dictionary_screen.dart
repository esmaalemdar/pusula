import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final List<DictionaryTerm> _terms;
  List<DictionaryTerm> _filteredTerms = [];

  @override
  void initState() {
    super.initState();
    _terms = _buildTerms();
    _filteredTerms = List.from(_terms);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DictionaryTerm> _buildTerms() {
    final terms = [
      const DictionaryTerm(
        term: 'Müddeabih',
        definition: 'Bir davada dava konusu edilen şey, uyuşmazlığın maddi değeri.',
      ),
      const DictionaryTerm(
        term: 'Tezyid-i Bedel',
        definition: 'Bedel artırımı; özellikle kamulaştırma davalarında bedelin düşük bulunması durumunda açılan artırım davası.',
      ),
      const DictionaryTerm(
        term: 'İhtiyati Tedbir',
        definition: 'Davanın devamı sırasında hakkın elde edilmesini güvence altına almak için verilen geçici hukuki koruma.',
      ),
      const DictionaryTerm(
        term: 'Fesih',
        definition: 'Mevcut bir hukuki ilişkiyi veya sözleşmeyi tek taraflı bir irade beyanıyla sona erdirme.',
      ),
      const DictionaryTerm(
        term: 'İstinaf',
        definition: 'Yerel mahkeme kararının hem maddi vakıa hem de hukuki yönden üst mahkemece (BAM) incelenmesi yolu.',
      ),
      const DictionaryTerm(
        term: 'İnfaz',
        definition: 'Mahkeme tarafından verilen ve kesinleşen kararın yerine getirilmesi süreci.',
      ),
      const DictionaryTerm(
        term: 'Tebliğ',
        definition: 'Hukuki bir işlemin yetkili makamca ilgili kişinin bilgisine resmi olarak sunulması.',
      ),
      const DictionaryTerm(
        term: 'Muvazaa',
        definition: 'Tarafların üçüncü kişileri aldatmak amacıyla, gerçek iradelerine uymayan bir sözleşme yapmaları.',
      ),
      const DictionaryTerm(
        term: 'Tereke',
        definition: 'Ölen bir kimseden mirasçılarına geçen mal, hak ve borçların tamamı.',
      ),
      const DictionaryTerm(
        term: 'Beyyine',
        definition: 'Bir iddiayı doğrulamaya yarayan her türlü hukuki delil ve kanıt.',
      ),
      const DictionaryTerm(
        term: 'Gıyap',
        definition: 'Bir tarafın mahkemede hazır bulunmaması durumu; yokluk.',
      ),
      const DictionaryTerm(
        term: 'Derdest',
        definition: 'Bir davanın henüz sonuçlanmamış, mahkemede görülmekte olması hali.',
      ),
      const DictionaryTerm(
        term: 'İbra',
        definition: 'Alacaklının hakkından vazgeçerek borçluyu borçtan kurtarması işlemi.',
      ),
      const DictionaryTerm(
        term: 'Mücbir Sebep',
        definition: 'Kişinin kontrolü dışında gerçekleşen, öngörülemeyen ve borcun ifasını engelleyen olağanüstü durum (deprem, savaş vb.).',
      ),
      const DictionaryTerm(
        term: 'Hususumet',
        definition: 'Davada taraf olma sıfatı; davanın doğru kişiye karşı açılıp açılmadığı durumu.',
      ),
      const DictionaryTerm(
        term: 'İvazsız',
        definition: 'Karşılıksız, bedelsiz yapılan hukuki işlem (Örn: Bağışlama).',
      ),
      const DictionaryTerm(
        term: 'Kusur',
        definition: 'Hukuka aykırı bir sonucun doğmasına yol açan irade eksikliği (ihmal veya kast).',
      ),
      const DictionaryTerm(
        term: 'Müruruzaman',
        definition: 'Zamanaşımı; bir hakkın belirli bir sürede kullanılmaması sonucu dava edilebilme özelliğini yitirmesi.',
      ),
      const DictionaryTerm(
        term: 'Nafaka',
        definition: 'Geçimini sağlamakta zorlanan kişiye, yakınları tarafından ödenmesine hükmedilen maddi yardım.',
      ),
      const DictionaryTerm(
        term: 'Vesayet',
        definition: 'Reşit olmayan veya kısıtlanan kişilerin haklarını korumak amacıyla atanan hukuki temsil yetkisi.',
      ),
      const DictionaryTerm(
        term: 'İstirdat',
        definition: 'Haksız yere ödenen bir şeyin geri alınması amacıyla açılan geri alım davası.',
      ),
      const DictionaryTerm(
        term: 'Zilyetlik',
        definition: 'Bir eşya üzerinde fiilen hakimiyet kurma durumu.',
      ),
      const DictionaryTerm(
        term: 'Feragat',
        definition: 'Bir haktan veya açılmış olan davadan kendi isteğiyle vazgeçme.',
      ),
      const DictionaryTerm(
        term: 'İkametgah',
        definition: 'Bir kimsenin yerleşmek niyetiyle oturduğu hukuki adres.',
      ),
      const DictionaryTerm(
        term: 'Karine',
        definition: 'Bilinen bir olaydan, bilinmeyen bir olay için çıkarılan hukuki sonuç.',
      ),
      const DictionaryTerm(
        term: 'Mehil',
        definition: 'Bir işlemin yapılması için tanınan ek süre.',
      ),
      const DictionaryTerm(
        term: 'Rücu',
        definition: 'Bir kişinin ödediği bedeli, asıl sorumlu olan kişiden geri istemesi hakkı.',
      ),
      const DictionaryTerm(
        term: 'Şerh',
        definition: 'Bir taşınmazın durumunu belirtmek için tapu kütüğüne yazılan açıklayıcı not.',
      ),
      const DictionaryTerm(
        term: 'Vekalet',
        definition: 'Bir kimsenin başka bir kimseyi kendi adına işlem yapması için yetkilendirmesi.',
      ),
      const DictionaryTerm(
        term: 'Yürütmeyi Durdurma',
        definition: 'İdari işlemin uygulanmasının, davanın sonuna kadar geçici olarak askıya alınması.',
      ),
    ];
    terms.sort((a, b) => a.term.compareTo(b.term));
    return terms;
  }

  void _onSearchChanged(String query) {
    final normalized = query.trim().toLowerCase();
    setState(() {
      if (normalized.isEmpty) {
        _filteredTerms = List.from(_terms);
      } else {
        _filteredTerms = _terms.where((term) {
          return term.term.toLowerCase().contains(normalized) || term.definition.toLowerCase().contains(normalized);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hukuki Terimler Sözlüğü'),
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
                hintText: 'Terim ara...',
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
              child: _filteredTerms.isEmpty
                  ? Center(
                      child: Text(
                        'Eşleşen terim bulunamadı.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredTerms.length,
                      itemBuilder: (context, index) {
                        final term = _filteredTerms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _DictionaryCard(term: term),
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
  const _DictionaryCard({required this.term});

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
            term.term,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            term.definition,
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
  final String term;
  final String definition;

  const DictionaryTerm({required this.term, required this.definition});
}



