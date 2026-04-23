import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsConsentRow extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;
  final String text;

  const TermsConsentRow({
    super.key,
    required this.accepted,
    required this.onChanged,
    this.text = 'Devam ederek kullanım koşullarını kabul etmiş olursun.',
  });

  Future<void> _openTermsSheet(BuildContext context) async {
    final bool? approved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F1117),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.86,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              children: [
                const Text(
                  'Kullanım Koşulları',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SfPdfViewer.network(
                      'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white30),
                        ),
                        child: const Text('Reddet'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D88E),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Onayla'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (approved != null) {
      onChanged(approved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Checkbox(
            value: accepted,
            onChanged: (_) => _openTermsSheet(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _openTermsSheet(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
