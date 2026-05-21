// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Hukuk Terimleri Sözlüğü (Akıllı Tooltip Sistemi)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

class LegalDictionary {
  static const Map<String, String> terms = {
    "Netice-i Talep": "Davanın sonunda mahkemeden tam olarak ne istediğinizin özeti.",
    "Daval mürun-bih": "Davanın konusu olan, üzerinde ihtilaf bulunan mal veya değer.",
    "İhtarname": "Bir kimseye, bir borcu ödemesi veya bir durumu düzeltmesi için noter kanalıyla yapılan bildirim.",
    "Vekaletname": "Bir kimsenin, kendi adına işlem yapması için bir başkasına (genelde avukat) verdiği yazılı yetki belgesi.",
    "İcra-i Takip": "Alacağın devlet gücüyle tahsil edilmesi süreci.",
    "Mücbir Sebep": "Deprem, sel, savaş gibi kişinin kontrolü dışında gerçekleşen ve yükümlülüklerini engelleyen olaylar.",
  };

  // Metin içinde terimleri bulup Tooltip ile sarmalayan widget
  static List<InlineSpan> wrapTerms(String text, BuildContext context) {
    final List<InlineSpan> spans = [];
    final List<String> words = text.split(" ");

    for (var word in words) {
      String cleanWord = word.replaceAll(RegExp(r'[.,!?;:]'), "");
      if (terms.containsKey(cleanWord)) {
        spans.add(
          WidgetSpan(
            child: Tooltip(
              message: terms[cleanWord],
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              showDuration: const Duration(seconds: 3),
              decoration: BoxDecoration(
                color: AppColors.text900,
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(color: Colors.white, fontSize: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.accent, width: 1.5, style: BorderStyle.solid)),
                ),
                child: Text(word, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
              ),
            ),
          ),
        );
        spans.add(const TextSpan(text: " "));
      } else {
        spans.add(TextSpan(text: "$word "));
      }
    }
    return spans;
  }
}


