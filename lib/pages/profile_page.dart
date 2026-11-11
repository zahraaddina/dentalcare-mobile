import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/demo_store.dart';
import '../models/app_models.dart';
import '../widgets/common.dart';

// =====================================================
// PROFIL PASIEN
// =====================================================

class ProfileTab extends StatelessWidget {
  final DemoStore store;

  const ProfileTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final p = store.patient!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const HeaderText(
          'Profil Pasien',
          'Identitas yang digunakan untuk '
              'pendaftaran online.',
        ),
        const SizedBox(height: 20),

        // HEADER PROFIL
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.green, C.deep]),
            borderRadius: BorderRadius.circular(23),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 29,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      p.rm ?? p.id,
                      style: const TextStyle(
                        color: Color(0xFFD9EDE1),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // DATA IDENTITAS
        SheetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Identitas',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              LabeledValue('NIK', store.patientDetail('nik')),
              LabeledValue('Nama lengkap', p.name),
              LabeledValue('Tempat lahir', store.patientDetail('birthPlace')),
              LabeledValue('Tanggal lahir', dateText(p.birth)),
              LabeledValue('Jenis kelamin', p.gender),
              LabeledValue('ID pasien', p.id),
              if (p.rm != null) LabeledValue('No. RM', p.rm!),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // INFORMASI KONTAK
        SheetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Informasi Kontak',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditContactPage(store: store),
                      ),
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              LabeledValue('Nomor HP / WA', p.phone),
              LabeledValue('Alamat', p.address),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ALAMAT ADMINISTRATIF
        SheetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Alamat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              LabeledValue('Provinsi', store.patientDetail('province')),
              LabeledValue('Kabupaten / Kota', store.patientDetail('city')),
              LabeledValue('Kecamatan', store.patientDetail('district')),
              LabeledValue('Kelurahan / Desa', store.patientDetail('village')),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // LOGOUT
        OutlinedButton.icon(
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
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
                    child: const Text('Keluar'),
                  ),
                ],
              ),
            );

            if (ok == true) {
              await store.signOut();
            }
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Keluar dari profil'),
        ),

        // KONTROL DEMO
        if (kDebugMode) ...[
          const SizedBox(height: 26),
          const Divider(color: C.line),
          const SizedBox(height: 12),

          const SizedBox(height: 10),
          const SizedBox(height: 10),

          ...store.active.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: SheetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b.id,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Saat ini: ${statusLabel(b.status)}',
                      style: const TextStyle(fontSize: 11, color: C.muted),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => store.simulateNext(b.id),
                      child: const Text('Simulasikan status berikutnya'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 22),
        const Center(
          child: Text(
            'RSGM COMAL • Prototipe UTS '
            'dengan data simulasi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: C.muted),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// EDIT KONTAK
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kontak')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HeaderText(
              'Perbarui kontak',
              'Hanya nomor HP dan alamat yang '
                  'dapat diubah pada prototipe ini.',
            ),
            const SizedBox(height: 20),
            SheetCard(
              child: Form(
                key: form,
                child: Column(
                  children: [
                    FieldLabel(
                      'Nomor HP dummy',
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
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
                        maxLines: 2,
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
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                if (!form.currentState!.validate()) {
                  return;
                }

                await widget.store.editContact(
                  phone.text.trim(),
                  address.text.trim(),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
