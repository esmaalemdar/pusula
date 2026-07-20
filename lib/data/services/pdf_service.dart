// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — PDF Motoru (Resmi Dilekçe Formatı)
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../models/dilekce_model.dart';

class PdfService {
  static Future<File> generateDilekcePdf(DilekceModel dilekce) async {
    final pdf = pw.Document();

    // Resmi Format Ayarları (A4, Marjinler: Üst: 3cm, Sol: 3.5cm, Sağ: 2cm)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(
          3.5 * PdfPageFormat.cm, 
          3.0 * PdfPageFormat.cm, 
          2.0 * PdfPageFormat.cm, 
          2.0 * PdfPageFormat.cm
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Başlık (Ortalı ve Kalın)
              pw.Center(
                child: pw.Text(
                  dilekce.title.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 40),
              
              // Tarih (Sağ Üst)
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Tarih: ${dilekce.createDate.day}.${dilekce.createDate.month}.${dilekce.createDate.year}",
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 20),

              // İçerik (İki Yana Yaslı)
              pw.Paragraph(
                text: dilekce.content,
                style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
                textAlign: pw.TextAlign.justify,
              ),
              
              pw.Spacer(),

              // İmza Alanı
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  children: [
                    pw.Text("İmza", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 40),
                    pw.Text("Ad Soyad"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Dosyayı Kaydet
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/dilekce_${dilekce.id}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Önizleme ve Yazdır
  static Future<void> printPdf(File file) async {
    await Printing.layoutPdf(onLayout: (_) => file.readAsBytes());
  }
}


