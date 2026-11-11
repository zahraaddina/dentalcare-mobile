import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/demo_store.dart';
import '../models/app_models.dart';
import '../widgets/common.dart';

// =====================================================
// PROFIL PASIEN RSGM COMAL
// =====================================================

class ProfileTab extends StatelessWidget {
  final DemoStore store;

  const ProfileTab({super.key, required this.store});

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Keluar dari profil?'),
        content: const Text(
          'Data simulasi dapat diakses lagi '
          'dengan mendaftar ulang atau masuk '
          'sebagai pasien lama.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar', style: TextStyle(color: C.red)),
          ),
        ],
      ),
    );

    if (ok == true) {
      await store.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = store.patient!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      children: [
        // JUDUL HALAMAN
        const Text(
          'Profil Pasien',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: C.deep,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Kelola dan lihat informasi identitas Anda.',
          style: TextStyle(fontSize: 12, color: C.muted, height: 1.5),
        ),

        const SizedBox(height: 22),

        // =========================================
        // KARTU PROFIL UTAMA
        // =========================================
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF17765D), C.deep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: C.green.withValues(alpha: .15),
                blurRadius: 23,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: Stack(
              children: [
                Positioned(
                  right: -42,
                  top: -55,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .08),
                        width: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -70,
                  left: -45,
                  child: Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: .04),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // AVATAR
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .17),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .22),
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 43,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PROFIL PASIEN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFC5EEDC),
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  p.name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  p.rm ?? p.id,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFFDEF2E6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: Colors.white,
                              size: 21,
                            ),
                            const SizedBox(width: 11),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Identitas Pasien',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Data profil pendaftaran RSGM COMAL',
                                    style: TextStyle(
                                      color: Color(0xFFD8F0E4),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCF5E6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Simulasi',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: C.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        // =========================================
        // DATA IDENTITAS
        // =========================================
        const _ProfileSectionHeading(
          icon: Icons.badge_outlined,
          title: 'Data Identitas',
          subtitle: 'Informasi pribadi yang terdaftar',
        ),
        const SizedBox(height: 12),

        _ProfileCard(
          children: [
            _ProfileInfoRow(
              icon: Icons.credit_card_rounded,
              label: 'NIK',
              value: store.patientDetail('nik'),
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Nama lengkap',
              value: p.name,
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.location_city_outlined,
              label: 'Tempat lahir',
              value: store.patientDetail('birthPlace'),
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.cake_outlined,
              label: 'Tanggal lahir',
              value: dateText(p.birth),
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.wc_rounded,
              label: 'Jenis kelamin',
              value: p.gender,
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.perm_identity_rounded,
              label: 'ID pasien',
              value: p.id,
            ),
            if (p.rm != null) ...[
              const _ProfileDivider(),
              _ProfileInfoRow(
                icon: Icons.assignment_ind_outlined,
                label: 'No. RM',
                value: p.rm!,
              ),
            ],
          ],
        ),

        const SizedBox(height: 25),

        // =========================================
        // INFORMASI KONTAK
        // =========================================
        Row(
          children: [
            const Expanded(
              child: _ProfileSectionHeading(
                icon: Icons.contact_phone_outlined,
                title: 'Informasi Kontak',
                subtitle: 'Nomor telepon dan alamat Anda',
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: C.mint,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditContactPage(store: store),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16, color: C.green),
                      SizedBox(width: 5),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: C.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _ProfileCard(
          children: [
            _ProfileInfoRow(
              icon: Icons.phone_android_rounded,
              label: 'Nomor HP / WA',
              value: p.phone,
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.home_outlined,
              label: 'Alamat',
              value: p.address,
            ),
          ],
        ),

        const SizedBox(height: 25),

        // =========================================
        // DETAIL ALAMAT
        // =========================================
        const _ProfileSectionHeading(
          icon: Icons.map_outlined,
          title: 'Detail Alamat',
          subtitle: 'Wilayah domisili pasien',
        ),
        const SizedBox(height: 12),

        _ProfileCard(
          children: [
            _ProfileInfoRow(
              icon: Icons.public_rounded,
              label: 'Provinsi',
              value: store.patientDetail('province'),
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.location_city_outlined,
              label: 'Kabupaten / Kota',
              value: store.patientDetail('city'),
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.place_outlined,
              label: 'Kecamatan',
              value: store.patientDetail('district'),
            ),
            const _ProfileDivider(),
            _ProfileInfoRow(
              icon: Icons.home_work_outlined,
              label: 'Kelurahan / Desa',
              value: store.patientDetail('village'),
            ),
          ],
        ),

        const SizedBox(height: 23),

        // =========================================
        // KELUAR DARI PROFIL
        // =========================================
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => _logout(context),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: C.red.withValues(alpha: .25)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: C.red.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: C.red,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Text(
                      'Keluar dari profil',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: C.red,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: C.red),
                ],
              ),
            ),
          ),
        ),

        // =========================================
        // KONTROL SIMULASI PENGEMBANG
        // =========================================
        if (kDebugMode) ...[
          const SizedBox(height: 27),
          const Divider(color: C.line),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: C.gold.withValues(alpha: .20)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: C.gold, size: 22),
                SizedBox(width: 11),
              ],
            ),
          ),

          const SizedBox(height: 13),

          ...store.active.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _ProfileCard(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number_outlined,
                        color: C.green,
                        size: 20,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          b.id,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: C.deep,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Saat ini: ${statusLabel(b.status)}',
                    style: const TextStyle(fontSize: 11.5, color: C.muted),
                  ),
                  const SizedBox(height: 13),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => store.simulateNext(b.id),
                      icon: const Icon(Icons.play_arrow_rounded, size: 19),
                      label: const Text('Simulasikan status berikutnya'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 25),
        const Center(
          child: Text(
            'RSGM COMAL',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: C.muted),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// KOMPONEN JUDUL BAGIAN
// =====================================================

class _ProfileSectionHeading extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileSectionHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: C.mint,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: C.green, size: 21),
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
                  fontWeight: FontWeight.w800,
                  color: C.deep,
                ),
              ),
              const SizedBox(height: 3),
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
// KOMPONEN KARTU INFORMASI
// =====================================================

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: C.line),
        boxShadow: [
          BoxShadow(
            color: C.deep.withValues(alpha: .035),
            blurRadius: 17,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// =====================================================
// KOMPONEN BARIS INFORMASI
// =====================================================

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            color: C.mint,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: C.green, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: C.muted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                value,
                style: const TextStyle(
                  color: C.deep,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// GARIS PEMBATAS INFORMASI
// =====================================================

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Divider(height: 1, thickness: 1, color: C.line),
    );
  }
}

// =====================================================
// HALAMAN EDIT KONTAK
// FITUR TETAP SAMA, TAMPILAN DIPERBAIKI
// =====================================================

class EditContactPage extends StatefulWidget {
  final DemoStore store;

  const EditContactPage({super.key, required this.store});

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late final TextEditingController phone;
  late final TextEditingController address;

  final form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    phone = TextEditingController(text: widget.store.patient?.phone ?? '');

    address = TextEditingController(text: widget.store.patient?.address ?? '');
  }

  @override
  void dispose() {
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;

    await widget.store.editContact(phone.text.trim(), address.text.trim());

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kontak')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // HEADER EDIT KONTAK
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.green, C.deep]),
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perbarui kontak',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Perbarui informasi yang bisa dihubungi.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color: Color(0xFFE0F3E9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 17),

            const Text(
              'Hanya nomor HP dan alamat yang dapat '
              'diubah pada prototipe ini.',
              style: TextStyle(fontSize: 11.5, color: C.muted, height: 1.6),
            ),

            const SizedBox(height: 17),

            _ProfileCard(
              children: [
                Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ProfileSectionHeading(
                        icon: Icons.contact_phone_outlined,
                        title: 'Informasi Kontak',
                        subtitle: 'Lengkapi data kontak terbaru',
                      ),
                      const SizedBox(height: 22),

                      FieldLabel(
                        'Nomor HP dummy',
                        child: TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_android_rounded,
                              color: C.green,
                            ),
                            hintText: 'Masukkan nomor HP',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 8) {
                              return 'Nomor minimal 8 karakter';
                            }
                            return null;
                          },
                        ),
                      ),

                      FieldLabel(
                        'Alamat lengkap',
                        child: TextFormField(
                          controller: address,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan alamat lengkap',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Alamat wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
