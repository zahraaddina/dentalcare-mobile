import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';
import '../widgets/common.dart';

class PoliListPage extends StatelessWidget {
  final Future<void> Function({String? poliId}) onBook;
  const PoliListPage({super.key, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layanan Poli')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const HeaderText('Informasi layanan gigi', 'Kenali layanan yang tersedia. Penentuan poli lanjutan dilakukan setelah pemeriksaan awal.'),
          const SizedBox(height: 20),
          for (final p in polies)
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: SheetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      PoliIcon(p),
                      const SizedBox(width: 12),
                      Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                    ]),
                    const SizedBox(height: 10),
                    Text(p.description, style: const TextStyle(fontSize: 12, color: C.muted)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => PoliDetailPage(
                          poli: p,
                          onBook: () => onBook(),
                        ),
                      )),
                      child: const Text('Lihat detail layanan'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PoliDetailPage extends StatelessWidget {
  final Poli poli;
  final Future<void> Function() onBook;
  const PoliDetailPage({super.key, required this.poli, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Poli')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    height: 172,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [C.mint, Color(0xFFF5FBF8)]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Icon(
                        [Icons.medical_services_outlined, Icons.health_and_safety_outlined, Icons.child_care_rounded][poli.iconId],
                        size: 88,
                        color: C.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(poli.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(poli.description, style: const TextStyle(fontSize: 13, color: C.muted)),
                  const SizedBox(height: 22),
                  SheetCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tentang layanan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 9),
                        Text(poli.details, style: const TextStyle(color: C.muted, fontSize: 12.5, height: 1.65)),
                        const SizedBox(height: 18),
                        const Divider(color: C.line),
                        const SizedBox(height: 12),
                        const Row(children: [Icon(Icons.schedule, color: C.green, size: 20), SizedBox(width: 8), Text('Senin–Jumat • Jadwal simulasi', style: TextStyle(fontSize: 11.5))]),
                        const SizedBox(height: 12),
                        const Row(children: [
                          Icon(Icons.info_outline, color: C.green, size: 20),
                          SizedBox(width: 8),
                          Expanded(child: Text('Keluhan dicatat saat pendaftaran. Penentuan layanan lanjutan dilakukan setelah pemeriksaan awal oleh tenaga kesehatan.', style: TextStyle(fontSize: 11.5))),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SheetCard(child: Row(children: [
                    Icon(Icons.fact_check_outlined, color: C.green),
                    SizedBox(width: 12),
                    Expanded(child: Text('Siapkan identitas sesuai data pendaftaran dan tunjukkan kode booking saat datang.', style: TextStyle(fontSize: 11.5, height: 1.6, color: C.muted))),
                  ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await onBook();
                },
                child: const Text('Daftar pemeriksaan awal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
