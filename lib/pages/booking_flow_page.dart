import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../core/app_theme.dart';
import '../data/demo_store.dart';
import '../models/app_models.dart';
import '../widgets/common.dart';
import 'booking_detail_page.dart';

class BookingFlowPage extends StatefulWidget {
  final DemoStore store;
  final String? initialPoli;

  const BookingFlowPage({super.key, required this.store, this.initialPoli});

  @override
  State<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowPage> {
  static const String _intakePoliId = 'umum';

  final _complaintController = TextEditingController();
  final _bpjsController = TextEditingController();
  final _referralController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _policyController = TextEditingController();

  final _paymentFormKey = GlobalKey<FormState>();

  int step = 0;
  DateTime? date;
  String? session;

  String paymentMethod = 'umum';
  bool saving = false;

  @override
  void dispose() {
    _complaintController.dispose();
    _bpjsController.dispose();
    _referralController.dispose();
    _insuranceController.dispose();
    _policyController.dispose();
    super.dispose();
  }

  String get paymentName {
    switch (paymentMethod) {
      case 'bpjs':
        return 'BPJS Kesehatan';
      case 'asuransi':
        return 'Asuransi Lain';
      default:
        return 'Umum / Mandiri';
    }
  }

  // =====================================================
  // NAVIGASI LANGKAH
  // =====================================================

  void forward() {
    if (step == 1 && (date == null || session == null)) {
      snack(context, 'Pilih tanggal dan sesi kedatangan.', error: true);
      return;
    }

    if (step == 2) {
      if (!_paymentFormKey.currentState!.validate()) {
        snack(context, 'Periksa kembali data pembayaran.', error: true);
        return;
      }
    }

    if (step < 3) {
      setState(() => step++);
    }
  }

  void goBack() {
    if (step > 0) {
      setState(() => step--);
    } else {
      Navigator.pop(context);
    }
  }

  // =====================================================
  // PILIH TANGGAL
  // =====================================================

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final firstDate = DateTime(now.year, now.month, now.day);

    final lastDate = firstDate.add(const Duration(days: 45));

    var initialDate = date ?? firstDate;

    while (initialDate.weekday == DateTime.saturday ||
        initialDate.weekday == DateTime.sunday) {
      initialDate = initialDate.add(const Duration(days: 1));
    }

    if (initialDate.isAfter(lastDate)) {
      initialDate = firstDate;

      while (initialDate.weekday == DateTime.saturday ||
          initialDate.weekday == DateTime.sunday) {
        initialDate = initialDate.add(const Duration(days: 1));
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (day) {
        return day.weekday != DateTime.saturday &&
            day.weekday != DateTime.sunday;
      },
    );

    if (picked != null && mounted) {
      setState(() {
        date = picked;
        session = null;
      });
    }
  }

  // =====================================================
  // SIMPAN PENDAFTARAN
  // =====================================================

  Future<void> submit() async {
    if (saving || date == null || session == null) return;

    setState(() => saving = true);

    try {
      final booking = await widget.store.createBooking(
        _intakePoliId,
        DemoStore.dateKey(date!),
        session!,
        complaint: _complaintController.text.trim(),
        paymentMethod: paymentMethod,
        bpjsNumber: paymentMethod == 'bpjs' ? _bpjsController.text.trim() : '',
        referralNumber: paymentMethod == 'bpjs'
            ? _referralController.text.trim()
            : '',
        insuranceName: paymentMethod == 'asuransi'
            ? _insuranceController.text.trim()
            : '',
        policyNumber: paymentMethod == 'asuransi'
            ? _policyController.text.trim()
            : '',
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailPage(
            store: widget.store,
            bookingId: booking.id,
            justCreated: true,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        snack(
          context,
          error.toString().replaceFirst('Bad state: ', ''),
          error: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  // =====================================================
  // HALAMAN UTAMA PENDAFTARAN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kunjungan'),
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: _FourStepBar(current: step),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                children: [
                  if (step == 0) ..._complaintStep(),
                  if (step == 1) ..._scheduleStep(),
                  if (step == 2) ..._paymentStep(),
                  if (step == 3) ..._confirmationStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: saving ? null : (step == 3 ? submit : forward),
                  child: Text(
                    saving
                        ? 'Menyimpan...'
                        : step == 3
                        ? 'Konfirmasi Pendaftaran'
                        : 'Lanjutkan',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // LANGKAH 1 - KELUHAN
  // =====================================================

  List<Widget> _complaintStep() {
    return [
      const HeaderText(
        'Ceritakan keluhan Anda',
        'Apa tujuan kedatangan Anda ke RSGM COMAL? '
            'Anda boleh melewati langkah ini.',
      ),
      const SizedBox(height: 20),
      SheetCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.edit_note_rounded, color: C.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Keluhan atau tujuan kedatangan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Opsional',
              style: TextStyle(color: C.muted, fontSize: 11),
            ),
            const SizedBox(height: 13),
            TextField(
              controller: _complaintController,
              maxLines: 5,
              minLines: 4,
              maxLength: 300,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText:
                    'Contoh: Gigi saya sakit sejak kemarin, '
                    'ingin periksa gigi berlubang, atau kontrol rutin.',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const Text(
              'Tulis dengan bahasa sehari-hari. '
              'Tidak harus mengetahui nama poli atau spesialis.',
              style: TextStyle(color: C.muted, fontSize: 11.5, height: 1.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const SheetCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: C.green, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Pendaftaran diarahkan ke pemeriksaan awal gigi. '
                'Keluhan hanya dicatat sebagai informasi awal, '
                'bukan diagnosis atau penentuan spesialis. '
                'Petugas dan dokter akan menilai layanan lanjutan.',
                style: TextStyle(color: C.muted, fontSize: 11.5, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // =====================================================
  // LANGKAH 2 - JADWAL
  // =====================================================

  List<Widget> _scheduleStep() {
    return [
      const HeaderText(
        'Pilih jadwal kunjungan',
        'Tentukan tanggal dan sesi untuk pemeriksaan awal gigi.',
      ),
      const SizedBox(height: 19),
      SheetCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal kunjungan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_month_outlined,
                    color: C.green,
                  ),
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                ),
                child: Text(
                  date == null
                      ? 'Pilih tanggal (Senin–Jumat)'
                      : DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date!),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: date == null ? C.muted : C.ink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 17),
      if (date != null) ...[
        const Text(
          'Sesi kedatangan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        for (final s in ['pagi', 'siang']) _sessionCard(s),
      ],
      const SizedBox(height: 12),
      const SheetCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: C.green),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sesi merupakan rentang kedatangan, bukan '
                'jaminan jam pemeriksaan. Jadwal dan kuota '
                'masih menggunakan data simulasi.',
                style: TextStyle(color: C.muted, fontSize: 11.5, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _sessionCard(String value) {
    final remaining = widget.store.available(
      _intakePoliId,
      DemoStore.dateKey(date!),
      value,
    );

    final full = remaining <= 0;
    final selected = session == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: full ? null : () => setState(() => session = value),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: full ? C.canvas : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? C.green : C.line,
              width: selected ? 1.7 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time_rounded, color: full ? C.muted : C.green),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value == 'pagi' ? 'Sesi Pagi' : 'Sesi Siang',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      sessionLabel(value),
                      style: const TextStyle(color: C.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    full ? 'Penuh' : 'Tersedia $remaining/10',
                    style: TextStyle(
                      color: full ? C.red : C.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: selected ? C.green : C.muted,
                    size: 19,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // LANGKAH 3 - JENIS PEMBAYARAN
  // =====================================================

  List<Widget> _paymentStep() {
    return [
      const HeaderText(
        'Jenis Pembayaran',
        'Pilih jenis pembiayaan yang akan digunakan '
            'untuk kunjungan Anda.',
      ),
      const SizedBox(height: 20),
      Form(
        key: _paymentFormKey,
        child: Column(
          children: [
            _PaymentOption(
              title: 'Pasien Umum (Mandiri)',
              description: 'Biaya pemeriksaan dan tindakan ditanggung sendiri.',
              icon: Icons.account_balance_wallet_outlined,
              selected: paymentMethod == 'umum',
              onTap: () {
                setState(() => paymentMethod = 'umum');
              },
            ),
            const SizedBox(height: 11),
            _PaymentOption(
              title: 'BPJS Kesehatan',
              description:
                  'Menggunakan jaminan JKN sesuai ketentuan '
                  'pelayanan, kepesertaan, dan rujukan.',
              icon: Icons.health_and_safety_outlined,
              selected: paymentMethod == 'bpjs',
              onTap: () {
                setState(() => paymentMethod = 'bpjs');
              },
            ),
            const SizedBox(height: 11),
            _PaymentOption(
              title: 'Asuransi Lain',
              description:
                  'Menggunakan asuransi yang bekerja sama '
                  'dengan fasilitas kesehatan.',
              icon: Icons.verified_user_outlined,
              selected: paymentMethod == 'asuransi',
              onTap: () {
                setState(() => paymentMethod = 'asuransi');
              },
            ),
            const SizedBox(height: 17),

            // FORM BPJS
            if (paymentMethod == 'bpjs')
              SheetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Kepesertaan BPJS',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Isi data dummy untuk simulasi pendaftaran.',
                      style: TextStyle(color: C.muted, fontSize: 11.5),
                    ),
                    const SizedBox(height: 16),
                    FieldLabel(
                      'Nomor peserta BPJS',
                      child: TextFormField(
                        controller: _bpjsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 13,
                        decoration: const InputDecoration(
                          hintText: '13 digit nomor peserta dummy',
                          prefixIcon: Icon(Icons.badge_outlined),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (paymentMethod != 'bpjs') return null;
                          if ((value ?? '').trim().length != 13) {
                            return 'Isi 13 digit nomor peserta dummy';
                          }
                          return null;
                        },
                      ),
                    ),
                    FieldLabel(
                      'Nomor rujukan / surat kontrol (jika ada)',
                      child: TextFormField(
                        controller: _referralController,
                        decoration: const InputDecoration(
                          hintText: 'Isi jika memiliki dokumen rujukan',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                      ),
                    ),
                    const Text(
                      'Bukti pendaftaran belum berarti jaminan '
                      'BPJS disetujui. Petugas perlu memeriksa '
                      'kepesertaan, rujukan atau surat kontrol, '
                      'dan ketentuan layanan.',
                      style: TextStyle(
                        color: C.muted,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

            // FORM ASURANSI
            if (paymentMethod == 'asuransi')
              SheetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Asuransi',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FieldLabel(
                      'Nama perusahaan asuransi',
                      child: TextFormField(
                        controller: _insuranceController,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Asuransi Sehat Demo',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        validator: (value) {
                          if (paymentMethod != 'asuransi') return null;
                          if ((value ?? '').trim().isEmpty) {
                            return 'Nama asuransi wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    FieldLabel(
                      'Nomor polis / peserta',
                      child: TextFormField(
                        controller: _policyController,
                        decoration: const InputDecoration(
                          hintText: 'Nomor peserta dummy',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (value) {
                          if (paymentMethod != 'asuransi') return null;
                          if ((value ?? '').trim().isEmpty) {
                            return 'Nomor polis atau peserta wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(
                      'Penggunaan asuransi memerlukan konfirmasi '
                      'kerja sama fasilitas, cakupan manfaat, '
                      'dan ketentuan polis oleh petugas.',
                      style: TextStyle(
                        color: C.muted,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      const SheetCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline_rounded, color: C.green, size: 21),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Informasi Pembayaran',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            SizedBox(height: 11),
            Text(
              'Aplikasi hanya mencatat pilihan pembiayaan. '
              'Pembayaran administrasi atau tagihan tindakan '
              'dilakukan di kasir sesuai prosedur RSGM.',
              style: TextStyle(fontSize: 11.5, color: C.muted, height: 1.6),
            ),
            SizedBox(height: 11),
            Text(
              'Biaya tindakan belum dapat dipastikan '
              'saat pendaftaran karena tergantung '
              'hasil pemeriksaan dan jenis perawatan.',
              style: TextStyle(fontSize: 11.5, color: C.muted, height: 1.6),
            ),
          ],
        ),
      ),
    ];
  }

  // =====================================================
  // LANGKAH 4 - KONFIRMASI
  // =====================================================

  List<Widget> _confirmationStep() {
    return [
      const HeaderText(
        'Periksa pendaftaran',
        'Pastikan semua data sudah benar '
            'sebelum mengonfirmasi reservasi.',
      ),
      const SizedBox(height: 20),
      SheetCard(
        child: Column(
          children: [
            LabeledValue('Nama pasien', widget.store.patient!.name),
            LabeledValue(
              'Jenis pasien',
              widget.store.patient!.rm == null ? 'Pasien baru' : 'Pasien lama',
            ),
            const LabeledValue('Tujuan layanan', 'Pemeriksaan awal gigi'),
            LabeledValue(
              'Keluhan (opsional)',
              _complaintController.text.trim().isEmpty
                  ? 'Tidak diisi'
                  : _complaintController.text.trim(),
            ),
            LabeledValue('Tanggal', dateText(DemoStore.dateKey(date!))),
            LabeledValue('Sesi kedatangan', sessionLabel(session!)),
            LabeledValue('Jenis pembayaran', paymentName),
            if (paymentMethod == 'bpjs') ...[
              LabeledValue('Nomor peserta BPJS', _bpjsController.text.trim()),
              LabeledValue(
                'Rujukan / surat kontrol',
                _referralController.text.trim().isEmpty
                    ? 'Belum dicantumkan'
                    : _referralController.text.trim(),
              ),
            ],
            if (paymentMethod == 'asuransi') ...[
              LabeledValue('Nama asuransi', _insuranceController.text.trim()),
              LabeledValue('Nomor polis', _policyController.text.trim()),
            ],
          ],
        ),
      ),
      const SizedBox(height: 14),
      SheetCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.verified_user_outlined, color: C.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                paymentMethod == 'umum'
                    ? 'Pembiayaan mandiri dipilih. '
                          'Pembayaran dilakukan di kasir '
                          'sesuai prosedur pelayanan.'
                    : 'Pendaftaran ini merupakan reservasi '
                          'sementara. Dokumen dan kelayakan '
                          'penjaminan akan diverifikasi petugas '
                          'ketika pasien datang.',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: C.muted,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      OutlinedButton(
        onPressed: () => setState(() => step = 0),
        child: const Text('Ubah keluhan'),
      ),
      const SizedBox(height: 7),
      OutlinedButton(
        onPressed: () => setState(() => step = 1),
        child: const Text('Ubah jadwal'),
      ),
      const SizedBox(height: 7),
      OutlinedButton(
        onPressed: () => setState(() => step = 2),
        child: const Text('Ubah pembayaran'),
      ),
    ];
  }
}

// =====================================================
// KOMPONEN PILIH PEMBAYARAN
// =====================================================

class _PaymentOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? C.mint : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? C.green : C.line,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? C.green : C.muted,
              size: 22,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: C.deep,
                          ),
                        ),
                      ),
                      Icon(icon, color: C.green, size: 21),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.55,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// INDIKATOR EMPAT LANGKAH
// Tidak perlu mengubah StepBar di common.dart.
// =====================================================

class _FourStepBar extends StatelessWidget {
  final int current;

  const _FourStepBar({required this.current});

  @override
  Widget build(BuildContext context) {
    const labels = ['Keluhan', 'Jadwal', 'Pembayaran', 'Konfirmasi'];

    return Row(
      children: List.generate(labels.length, (index) {
        final active = index <= current;
        final focused = index == current;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 6),
            child: Column(
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: active ? C.green : C.line,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${index + 1}. ${labels[index]}',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: focused ? FontWeight.w700 : FontWeight.w500,
                    color: active ? C.green : C.muted,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
