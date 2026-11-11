import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/app_theme.dart';
import '../data/demo_store.dart';
import '../models/app_models.dart';
import '../widgets/common.dart';

class BookingDetailPage extends StatelessWidget {
  final DemoStore store;
  final String bookingId;
  final bool justCreated;

  const BookingDetailPage({
    super.key,
    required this.store,
    required this.bookingId,
    this.justCreated = false,
  });

  // =====================================================
  // MEMBATALKAN PENDAFTARAN
  // =====================================================

  Future<void> cancel(BuildContext context, Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan pendaftaran?'),
        content: const Text(
          'Reservasi ini akan dibatalkan dan kuota simulasi '
          'dikembalikan. Tindakan ini tidak dapat diurungkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Ya, Batalkan',
              style: TextStyle(color: C.red, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await store.cancel(booking.id);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  // =====================================================
  // HALAMAN DETAIL / TIKET RESERVASI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        final matches = store.ownBookings.where(
          (booking) => booking.id == bookingId,
        );

        if (matches.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Kunjungan')),
            body: const Center(child: Text('Booking tidak ditemukan')),
          );
        }

        final b = matches.first;

        final finished = b.status == 'completed';

        final cancelled = ['cancelled', 'no_show'].contains(b.status);

        return Scaffold(
          appBar: AppBar(
            title: Text(finished ? 'Detail Kunjungan' : 'Tiket Reservasi'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // =====================================
                // INFORMASI BERHASIL
                // =====================================

                if (justCreated && !cancelled && !finished) ...[
                  const SheetCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: C.green,
                          size: 46,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Pendaftaran Berhasil!',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Simpan kode booking atau tunjukkan '
                          'QR Code saat datang ke RSGM COMAL.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: C.muted,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // =====================================
                // KARTU TIKET RESERVASI
                // =====================================
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: C.line),
                  ),
                  child: Column(
                    children: [
                      // HEADER TIKET
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: C.mint,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: C.green,
                          size: 29,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'RSGM COMAL',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: C.green,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'BUKTI RESERVASI • SIMULASI',
                        style: TextStyle(
                          fontSize: 10,
                          color: C.muted,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // KODE BOOKING
                      const Text(
                        'Kode Booking',
                        style: TextStyle(color: C.muted, fontSize: 12),
                      ),

                      const SizedBox(height: 6),

                      SelectableText(
                        b.id,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: C.deep,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 12),

                      StatusPill(b.status),

                      const SizedBox(height: 22),

                      // =================================
                      // QR CODE BOOKING
                      // =================================
                      if (!cancelled && !finished) ...[
                        Container(
                          width: 218,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: C.line, width: 1.5),
                          ),
                          child: QrImageView(
                            data: b.id,
                            version: QrVersions.auto,
                            size: 188,
                            backgroundColor: Colors.white,
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
                            padding: EdgeInsets.zero,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner_rounded,
                              color: C.green,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Tunjukkan QR Code kepada petugas',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: C.green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'QR Code berisi kode booking Anda. '
                          'Petugas tetap perlu memverifikasi '
                          'pendaftaran dan identitas pasien.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: C.muted,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: C.canvas,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            cancelled
                                ? 'Reservasi telah dibatalkan '
                                      'atau dinyatakan tidak hadir. '
                                      'QR Code tidak berlaku.'
                                : 'Kunjungan telah selesai. '
                                      'Tiket ini menjadi catatan '
                                      'administratif simulasi.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: C.muted,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // PEMBATAS
                      const Divider(color: C.line, height: 1),

                      const SizedBox(height: 19),

                      // NOMOR ANTREAN DAN SESI
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'NOMOR ANTREAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: C.muted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  b.queue,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: C.green,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(width: 1, height: 58, color: C.line),

                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'SESI KEDATANGAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: C.muted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  b.session == 'pagi' ? 'Pagi' : 'Siang',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  sessionLabel(b.session),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: C.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const Divider(color: C.line, height: 1),

                      const SizedBox(height: 12),

                      // DETAIL DATA PASIEN
                      LabeledValue('Nama pasien', store.patient?.name ?? '-'),

                      const LabeledValue(
                        'Tujuan layanan',
                        'Pemeriksaan awal gigi',
                      ),

                      LabeledValue(
                        'Keluhan (opsional)',
                        b.complaint.isEmpty ? 'Tidak diisi' : b.complaint,
                      ),

                      LabeledValue('Tanggal', dateText(b.date)),

                      const LabeledValue('Pembiayaan', 'Umum / Mandiri'),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                // =====================================
                // PEMANTAUAN STATUS ANTREAN
                // =====================================
                if (!finished && !cancelled) ...[
                  SheetCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pantau status kunjungan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Status saat ini: ${statusLabel(b.status)}',
                          style: const TextStyle(color: C.muted, fontSize: 12),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: _QueueNumber('Antrean Anda', b.queue),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _QueueNumber(
                                'Sedang dilayani',
                                '${findPoli(b.poliId).prefix}-002',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Nomor yang sedang dilayani '
                          'merupakan data simulasi, '
                          'bukan informasi antrean realtime RSGM.',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: C.muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 17),
                ],

                // =====================================
                // INFORMASI KEDATANGAN
                // =====================================
                SheetCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            finished
                                ? Icons.check_circle_outline
                                : Icons.info_outline,
                            color: C.green,
                          ),

                          const SizedBox(width: 9),

                          Expanded(
                            child: Text(
                              finished
                                  ? 'Kunjungan telah selesai'
                                  : 'Informasi kedatangan',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      Text(
                        finished
                            ? 'Kunjungan ini telah tercatat '
                                  'dalam riwayat administratif simulasi.'
                            : 'Datang sesuai sesi kedatangan. '
                                  'Tunjukkan QR Code atau kode booking '
                                  'kepada petugas di loket. '
                                  'Petugas akan memverifikasi identitas '
                                  'dan melakukan check-in.',
                        style: const TextStyle(
                          color: C.muted,
                          fontSize: 11.5,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),

                // =====================================
                // TOMBOL PEMBATALAN
                // =====================================
                if (b.status == 'registered') ...[
                  const SizedBox(height: 17),

                  OutlinedButton.icon(
                    onPressed: () => cancel(context, b),
                    icon: const Icon(Icons.cancel_outlined, color: C.red),
                    label: const Text(
                      'Batalkan pendaftaran',
                      style: TextStyle(color: C.red),
                    ),
                  ),
                ],

                const SizedBox(height: 17),

                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =====================================================
// KOMPONEN NOMOR ANTREAN
// =====================================================

class _QueueNumber extends StatelessWidget {
  final String title;
  final String number;

  const _QueueNumber(this.title, this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.mint,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted, fontSize: 10),
          ),
          const SizedBox(height: 5),
          Text(
            number,
            style: const TextStyle(
              color: C.deep,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
