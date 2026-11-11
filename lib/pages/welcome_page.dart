import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../core/app_theme.dart';
import '../data/demo_store.dart';
import '../widgets/common.dart';

// =====================================================
// HALAMAN SELAMAT DATANG - RSGM COMAL
// =====================================================

class WelcomePage extends StatelessWidget {
  final DemoStore store;

  const WelcomePage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            // BRANDING ATAS
            const Row(
              children: [
                RsgmToothLogo(size: 42),
                SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RSGM COMAL',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: C.deep,
                      ),
                    ),
                    Text(
                      'Dental Health Center',
                      style: TextStyle(fontSize: 10, color: C.muted),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // HERO UTAMA
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF17765D), C.deep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    Positioned(
                      top: -58,
                      right: -60,
                      child: Container(
                        width: 205,
                        height: 205,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .10),
                            width: 28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -90,
                      left: -75,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .05),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 23,
                        vertical: 29,
                      ),
                      child: Column(
                        children: [
                          const ToothBadge(),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .14),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  size: 13,
                                  color: Color(0xFF9DE8C9),
                                ),
                                SizedBox(width: 7),
                                Text(
                                  'YOUR SMILE, OUR PRIORITY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: .6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Senyum Sehat\nDimulai dari Sini',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              height: 1.23,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Pendaftaran kunjungan gigi kini '
                            'lebih mudah, praktis, dan nyaman '
                            'melalui RSGM COMAL.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.65,
                              color: Color(0xFFE0F3E9),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _HeroBenefit(
                                icon: Icons.calendar_month_rounded,
                                label: 'Daftar Online',
                              ),
                              _HeroBenefit(
                                icon: Icons.confirmation_number_outlined,
                                label: 'Tiket Digital',
                              ),
                              _HeroBenefit(
                                icon: Icons.schedule_rounded,
                                label: 'Pantau Antrean',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 27),

            // PILIHAN JENIS PASIEN
            const Text(
              'Mulai perjalanan senyum sehatmu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: C.deep,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Pilih kategori pasien untuk melanjutkan pendaftaran.',
              style: TextStyle(color: C.muted, fontSize: 11.5, height: 1.5),
            ),
            const SizedBox(height: 17),

            _PatientChoiceCard(
              title: 'Saya Pasien Baru',
              subtitle:
                  'Belum pernah terdaftar? Buat profil pasien terlebih dahulu.',
              icon: Icons.person_add_alt_1_rounded,
              primary: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewPatientPage(store: store),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _PatientChoiceCard(
              title: 'Saya Pasien Lama',
              subtitle: 'Sudah memiliki nomor rekam medis? Masuk menggunakan data pasien.',
              icon: Icons.badge_outlined,
              primary: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OldPatientPage(store: store),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // FOOTER
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 15, color: C.muted),
                SizedBox(width: 7),
                Flexible(
                  child: Text(
                    'Prototipe UTS • Gunakan data identitas simulasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: C.muted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// KOMPONEN BENEFIT HERO
// =====================================================

class _HeroBenefit extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroBenefit({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// =====================================================
// KARTU PILIHAN PASIEN
// =====================================================

class _PatientChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _PatientChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: primary ? C.green : C.line,
              width: primary ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: C.mint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: C.green, size: 26),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: C.deep,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: C.muted,
                        fontSize: 10.5,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: primary ? C.green : C.mint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: primary ? Colors.white : C.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// LOGO GIGI RSGM COMAL
// =====================================================

class RsgmToothLogo extends StatelessWidget {
  final double size;

  const RsgmToothLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ToothLogoPainter()),
    );
  }
}

class _ToothLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Lingkaran logo.
    canvas.drawCircle(
      Offset(w * .5, h * .5),
      w * .48,
      Paint()..color = const Color(0xFFE7F7EF),
    );

    canvas.drawCircle(
      Offset(w * .5, h * .5),
      w * .43,
      Paint()
        ..color = C.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .025,
    );

    // Bentuk gigi.
    final tooth = Path()
      ..moveTo(w * .50, h * .25)
      ..cubicTo(w * .34, h * .15, w * .19, h * .24, w * .25, h * .47)
      ..cubicTo(w * .28, h * .62, w * .31, h * .78, w * .39, h * .78)
      ..cubicTo(w * .47, h * .78, w * .44, h * .57, w * .50, h * .57)
      ..cubicTo(w * .56, h * .57, w * .53, h * .78, w * .61, h * .78)
      ..cubicTo(w * .69, h * .78, w * .72, h * .62, w * .75, h * .47)
      ..cubicTo(w * .81, h * .24, w * .66, h * .15, w * .50, h * .25)
      ..close();

    canvas.drawPath(tooth, Paint()..color = Colors.white);

    canvas.drawPath(
      tooth,
      Paint()
        ..color = C.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .035
        ..strokeJoin = StrokeJoin.round,
    );

    // Mata.
    canvas.drawCircle(
      Offset(w * .40, h * .40),
      w * .016,
      Paint()..color = C.deep,
    );

    canvas.drawCircle(
      Offset(w * .60, h * .40),
      w * .016,
      Paint()..color = C.deep,
    );

    // Senyum.
    final smile = Path()
      ..moveTo(w * .42, h * .47)
      ..quadraticBezierTo(w * .50, h * .55, w * .58, h * .47);

    canvas.drawPath(
      smile,
      Paint()
        ..color = C.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .025
        ..strokeCap = StrokeCap.round,
    );

    // Kilauan.
    final sparkle = Path()
      ..moveTo(w * .78, h * .13)
      ..lineTo(w * .81, h * .20)
      ..lineTo(w * .88, h * .23)
      ..lineTo(w * .81, h * .26)
      ..lineTo(w * .78, h * .33)
      ..lineTo(w * .75, h * .26)
      ..lineTo(w * .68, h * .23)
      ..lineTo(w * .75, h * .20)
      ..close();

    canvas.drawPath(sparkle, Paint()..color = const Color(0xFF66CDA4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// =====================================================
// LOGO BESAR PADA HERO
// =====================================================

class ToothBadge extends StatelessWidget {
  const ToothBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      height: 158,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(color: Colors.white.withValues(alpha: .23)),
      ),
      child: const Center(child: RsgmToothLogo(size: 125)),
    );
  }
}

// =====================================================
// FORM PASIEN BARU
// =====================================================

class NewPatientPage extends StatefulWidget {
  final DemoStore store;

  const NewPatientPage({super.key, required this.store});

  @override
  State<NewPatientPage> createState() => _NewPatientPageState();
}

class _NewPatientPageState extends State<NewPatientPage> {
  final form = GlobalKey<FormState>();

  final nik = TextEditingController();
  final name = TextEditingController();
  final birthPlace = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final province = TextEditingController();
  final city = TextEditingController();
  final district = TextEditingController();
  final village = TextEditingController();

  DateTime? birth;
  String gender = 'Perempuan';
  bool agree = false;
  bool saving = false;

  @override
  void dispose() {
    nik.dispose();
    name.dispose();
    birthPlace.dispose();
    phone.dispose();
    address.dispose();
    province.dispose();
    city.dispose();
    district.dispose();
    village.dispose();
    super.dispose();
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    return null;
  }

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birth ?? DateTime(2002, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => birth = picked);
    }
  }

  Future<void> submit() async {
    if (saving) return;

    if (!form.currentState!.validate()) {
      snack(context, 'Lengkapi semua data yang wajib diisi.', error: true);
      return;
    }

    if (birth == null) {
      snack(context, 'Pilih tanggal lahir.', error: true);
      return;
    }

    if (!agree) {
      snack(context, 'Setujui penggunaan data simulasi.', error: true);
      return;
    }

    setState(() => saving = true);

    try {
      await widget.store.register(
        name: name.text.trim(),
        birth: DemoStore.dateKey(birth!),
        gender: gender,
        phone: phone.text.trim(),
        address: address.text.trim(),
        nik: nik.text.trim(),
        birthPlace: birthPlace.text.trim(),
        province: province.text.trim(),
        city: city.text.trim(),
        district: district.text.trim(),
        village: village.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      if (mounted) {
        snack(context, 'Tidak dapat menyimpan profil: $error', error: true);
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pasien Baru')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // HEADER FORM
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.green, C.deep]),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  RsgmToothLogo(size: 63),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pendaftaran Pasien Baru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Lengkapi identitas untuk membuat '
                          'profil pasien.',
                          style: TextStyle(
                            color: Color(0xFFE3F4EA),
                            fontSize: 10.5,
                            height: 1.5,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: C.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Gunakan data fiktif untuk mencoba '
                      'aplikasi ini. Jangan memasukkan '
                      'NIK atau identitas asli.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.6,
                        color: C.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SheetCard(
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FormSection(
                      icon: Icons.person_outline_rounded,
                      title: 'Data Identitas',
                      subtitle: 'Informasi dasar pasien',
                    ),
                    const SizedBox(height: 18),

                    FieldLabel(
                      'NIK (16 digit)',
                      child: TextFormField(
                        controller: nik,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        maxLength: 16,
                        decoration: const InputDecoration(
                          hintText: '16 digit NIK dummy',
                          prefixIcon: Icon(Icons.badge_outlined),
                          counterText: '',
                        ),
                        validator: (value) => (value ?? '').length != 16
                            ? 'NIK harus terdiri dari 16 digit'
                            : null,
                      ),
                    ),

                    FieldLabel(
                      'Nama lengkap sesuai KTP/KK',
                      child: TextFormField(
                        controller: name,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Nadia Putri',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) => (value ?? '').trim().length < 3
                            ? 'Nama minimal 3 karakter'
                            : null,
                      ),
                    ),

                    FieldLabel(
                      'Tempat lahir',
                      child: TextFormField(
                        controller: birthPlace,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Pemalang',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        validator: validateRequired,
                      ),
                    ),

                    FieldLabel(
                      'Tanggal lahir',
                      child: FormField<DateTime>(
                        validator: (_) => birth == null
                            ? 'Tanggal lahir wajib dipilih'
                            : null,
                        builder: (field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: pickBirthDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                ),
                                child: Text(
                                  birth == null
                                      ? 'Pilih tanggal lahir'
                                      : DateFormat(
                                          'd MMMM yyyy',
                                          'id_ID',
                                        ).format(birth!),
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: birth == null ? C.muted : C.ink,
                                  ),
                                ),
                              ),
                            ),
                            if (field.hasError) ...[
                              const SizedBox(height: 6),
                              Text(
                                field.errorText!,
                                style: const TextStyle(
                                  color: C.red,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    FieldLabel(
                      'Jenis kelamin',
                      child: DropdownButtonFormField<String>(
                        initialValue: gender,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.wc_rounded),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Perempuan',
                            child: Text('Perempuan'),
                          ),
                          DropdownMenuItem(
                            value: 'Laki-laki',
                            child: Text('Laki-laki'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => gender = value ?? gender);
                        },
                      ),
                    ),

                    FieldLabel(
                      'Nomor HP / WhatsApp aktif',
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Contoh: 081200000000',
                          prefixIcon: Icon(Icons.phone_android_rounded),
                        ),
                        validator: (value) {
                          final length = (value ?? '').trim().length;
                          return length < 10 || length > 15
                              ? 'Isi nomor HP 10–15 digit'
                              : null;
                        },
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Divider(color: C.line),
                    const SizedBox(height: 17),

                    const _FormSection(
                      icon: Icons.home_outlined,
                      title: 'Alamat Domisili',
                      subtitle: 'Informasi tempat tinggal pasien',
                    ),
                    const SizedBox(height: 18),

                    FieldLabel(
                      'Alamat lengkap',
                      child: TextFormField(
                        controller: address,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Jalan, nomor rumah, RT/RW, atau dusun',
                          alignLabelWithHint: true,
                        ),
                        validator: validateRequired,
                      ),
                    ),

                    FieldLabel(
                      'Provinsi',
                      child: TextFormField(
                        controller: province,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Jawa Tengah',
                          prefixIcon: Icon(Icons.map_outlined),
                        ),
                        validator: validateRequired,
                      ),
                    ),

                    FieldLabel(
                      'Kabupaten / Kota',
                      child: TextFormField(
                        controller: city,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Pemalang',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        validator: validateRequired,
                      ),
                    ),

                    FieldLabel(
                      'Kecamatan',
                      child: TextFormField(
                        controller: district,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Comal',
                          prefixIcon: Icon(Icons.place_outlined),
                        ),
                        validator: validateRequired,
                      ),
                    ),

                    FieldLabel(
                      'Kelurahan / Desa',
                      child: TextFormField(
                        controller: village,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Purwoharjo',
                          prefixIcon: Icon(Icons.home_outlined),
                        ),
                        validator: validateRequired,
                      ),
                    ),

                    CheckboxListTile(
                      value: agree,
                      onChanged: (value) =>
                          setState(() => agree = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Saya memahami bahwa aplikasi ini merupakan '
                        'simulasi dan tidak menggunakan identitas '
                        'pasien sungguhan.',
                        style: TextStyle(fontSize: 11, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: saving ? null : submit,
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text(saving ? 'Menyimpan...' : 'Simpan Profil & Lanjut'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FormSection({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: C.mint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: C.green),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: C.deep,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10.5, color: C.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// FORM PASIEN LAMA - TETAP
// =====================================================

class OldPatientPage extends StatefulWidget {
  final DemoStore store;

  const OldPatientPage({super.key, required this.store});

  @override
  State<OldPatientPage> createState() => _OldPatientPageState();
}

class _OldPatientPageState extends State<OldPatientPage> {
  final rm = TextEditingController();
  DateTime? birth;
  bool checking = false;

  @override
  void dispose() {
    rm.dispose();
    super.dispose();
  }

  Future<void> check() async {
    if (rm.text.trim().isEmpty || birth == null) {
      snack(context, 'Isi nomor RM dan tanggal lahir.', error: true);
      return;
    }

    setState(() => checking = true);

    final ok = await widget.store.identifyOld(
      rm.text.trim(),
      DemoStore.dateKey(birth!),
    );

    if (!mounted) return;

    setState(() => checking = false);

    if (ok) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      snack(
        context,
        'Data tidak ditemukan. Periksa kembali nomor RM '
        'dan tanggal lahir.',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pasien Lama')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HeaderText(
              'Temukan profil Anda',
              'Masukkan identitas pasien lama untuk '
                  'mencoba alur simulasi.',
            ),
            const SizedBox(height: 20),

            SheetCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldLabel(
                    'Nomor rekam medis dummy',
                    child: TextField(
                      controller: rm,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: RM-00025',
                      ),
                    ),
                  ),

                  FieldLabel(
                    'Tanggal lahir',
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2002, 5, 15),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null && mounted) {
                          setState(() => birth = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month_outlined),
                        ),
                        child: Text(
                          birth == null
                              ? 'Pilih tanggal lahir'
                              : dateText(DemoStore.dateKey(birth!)),
                          style: TextStyle(
                            color: birth == null ? C.muted : C.ink,
                          ),
                        ),
                      ),
                    ),
                  ),

                  FilledButton.icon(
                    onPressed: checking ? null : check,
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      checking ? 'Memeriksa...' : 'Cari Profil Pasien',
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
                      Icon(Icons.info_outline, color: C.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Akun pasien lama untuk demo',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No. RM: RM-00025\n'
                    'Tanggal lahir: 15 Mei 2002\n'
                    'Nama: Budi Santoso',
                    style: TextStyle(fontSize: 12, height: 1.8, color: C.muted),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Simulasi ini bukan verifikasi '
                    'identitas untuk layanan nyata.',
                    style: TextStyle(color: C.muted, fontSize: 11),
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
