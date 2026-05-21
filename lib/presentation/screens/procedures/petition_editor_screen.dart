// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Dilekçe Editörü (Kılavuzlu ve Profesyonel)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/procedure_model.dart';
import 'package:pusula/data/providers/app_provider.dart';
import '../../common_widgets/legal_layout_guide.dart';
import 'package:pusula/data/services/pdf_service.dart';

class PetitionEditorScreen extends StatefulWidget {
  final ProcedureModel procedure;

  const PetitionEditorScreen({super.key, required this.procedure});

  @override
  State<PetitionEditorScreen> createState() => _PetitionEditorScreenState();
}

class _PetitionEditorScreenState extends State<PetitionEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: "${widget.procedure.name} Dilekçesi");
    _contentController = TextEditingController(
      text: "\n\n${widget.procedure.applicationVenue.toUpperCase()} HAKİMLİĞİ'NE\n\n\n\n\n\nNETİCE-İ TALEP: Yukarda arz ve izah edilen nedenlerle davanın kabulüne karar verilmesini bilvekale saygılarımla talep ederim."
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dilekçe Hazırla"),
      ),
      body: Column(
        children: [
          Expanded(
            child: LegalLayoutGuide(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "Dilekçe Başlığı"),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Dilekçe içeriğini buraya yazın...",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // BÜYÜK PDF BUTONU
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final appProvider = Provider.of<AppProvider>(context, listen: false);
                  await appProvider.createAndSaveDilekce(_titleController.text, _contentController.text);
                  final dilekce = appProvider.dilekceler.last;
                  
                  // Gerçek PDF'i yarat ve Ekrana Bas
                  final file = await PdfService.generateDilekcePdf(dilekce);
                  await PdfService.printPdf(file);
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                label: const Text(
                  "Dilekçeyi PDF Olarak İndir / Yazdır",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




