import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/demo_store.dart';
import '../models/app_models.dart';
import '../widgets/common.dart';
import 'booking_detail_page.dart';
import 'booking_flow_page.dart';
import 'profile_page.dart';

// ======================================================
// NAVIGASI UTAMA
// ======================================================

class ShellPage extends StatefulWidget {
  final DemoStore store;
  const ShellPage({super.key, required this.store});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int selected = 0;

  Future<void> book({String? poliId}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingFlowPage(store: widget.store)),
    );
    if (mounted) setState(() {});
  }

  void openDetail(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BookingDetailPage(store: widget.store, bookingId: booking.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(
        store: widget.store,
        onBook: book,
        onTab: (index) => setState(() => selected = index),
        onDetail: openDetail,
      ),
      BookingsTab(
        store: widget.store,
        onBook: () => book(),
        onDetail: openDetail,
      ),
      HistoryTab(store: widget.store, onDetail: openDetail),
      ProfileTab(store: widget.store),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selected]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          setState(() => selected = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Pendaftaran',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ======================================================
// DATA PELAYANAN GIGI - SIMULASI
// ======================================================

class DentalService {
  final String title;
  final String description;
  final String detail;
  final IconData icon;

  const DentalService(this.title, this.description, this.detail, this.icon);
}

const dentalServices = <DentalService>[
  DentalService(
    'Pembersihan Karang Gigi',
    'Membersihkan plak dan karang gigi yang menumpuk.',
    'Pembersihan karang gigi atau scaling bertujuan '
        'menghilangkan plak dan karang gigi yang sulit '
        'dibersihkan dengan sikat gigi.\n\n'
        'Tindakan dilakukan sesuai hasil pemeriksaan dokter gigi.',
    Icons.cleaning_services_outlined,
  ),
  DentalService(
    'Penambalan Gigi',
    'Memperbaiki bagian gigi berlubang atau rusak.',
    'Penambalan gigi merupakan tindakan restorasi '
        'untuk memperbaiki gigi yang rusak atau berlubang.\n\n'
        'Dokter akan memeriksa apakah gigi dapat ditambal '
        'atau membutuhkan perawatan lainnya.',
    Icons.healing_outlined,
  ),
  DentalService(
    'Perawatan Ortodonti',
    'Perawatan susunan gigi dan hubungan gigitan.',
    'Ortodonti bertujuan membantu memperbaiki '
        'susunan gigi dan hubungan gigitan.\n\n'
        'Penggunaan kawat gigi atau alat ortodonti lain '
        'ditentukan setelah pemeriksaan dan perencanaan.',
    Icons.grid_on_rounded,
  ),
  DentalService(
    'Pencabutan Gigi',
    'Tindakan pencabutan berdasarkan indikasi medis.',
    'Pencabutan gigi dilakukan ketika terdapat '
        'indikasi medis tertentu.\n\n'
        'Tidak semua gigi yang sakit harus dicabut. '
        'Dokter akan memeriksa kemungkinan perawatan '
        'lain terlebih dahulu.',
    Icons.medical_services_outlined,
  ),
  DentalService(
    'Perawatan Saluran Akar',
    'Perawatan jaringan pada bagian dalam gigi.',
    'Perawatan saluran akar dilakukan untuk menangani '
        'masalah pada jaringan pulpa di bagian dalam gigi.\n\n'
        'Kebutuhan tindakan ditentukan melalui pemeriksaan '
        'oleh dokter gigi.',
    Icons.health_and_safety_outlined,
  ),
  DentalService(
    'Perawatan Gigi Anak',
    'Pemeriksaan dan perawatan kesehatan gigi anak.',
    'Pelayanan gigi anak mencakup pemeriksaan, '
        'pencegahan masalah gigi, edukasi, dan perawatan '
        'sesuai usia serta kondisi anak.',
    Icons.child_care_rounded,
  ),
];

// ======================================================
// DATA EDUKASI
// ======================================================

class DentalArticle {
  final String title;
  final String category;
  final String summary;
  final String duration;
  final IconData icon;
  final List<String> paragraphs;
  final String tipTitle;
  final String tip;

  const DentalArticle({
    required this.title,
    required this.category,
    required this.summary,
    required this.duration,
    required this.icon,
    required this.paragraphs,
    required this.tipTitle,
    required this.tip,
  });
}

const dentalArticles = <DentalArticle>[
  DentalArticle(
    title: 'Kapan Waktu Tepat Periksa Gigi Rutin?',
    category: 'Tips Dokter Gigi',
    summary: 'Pemeriksaan berkala membantu mengenali masalah gigi lebih awal.',
    duration: '3 menit',
    icon: Icons.event_available_rounded,
    paragraphs: [
      'Banyak orang baru mengunjungi dokter gigi ketika '
          'merasakan sakit. Padahal, beberapa masalah gigi '
          'dan gusi dapat berkembang tanpa gejala pada awalnya.',
      'Pemeriksaan berkala membantu dokter melihat kondisi '
          'gigi, gusi, dan kebersihan rongga mulut. '
          'Dengan begitu, masalah dapat dikenali lebih awal.',
      'Sebagian pasien mungkin dianjurkan kontrol sekitar '
          'enam bulan sekali. Namun, frekuensi pemeriksaan '
          'yang tepat dapat berbeda sesuai kondisi '
          'dan faktor risiko masing-masing pasien.',
    ],
    tipTitle: 'Jadwal kontrol sesuai kebutuhan',
    tip:
        'Tanyakan kepada dokter gigi kapan Anda perlu '
        'melakukan pemeriksaan berikutnya. '
        'Jangan menunggu sakit untuk berkonsultasi.',
  ),
  DentalArticle(
    title: 'Cara Menyikat Gigi yang Benar',
    category: 'Perawatan Harian',
    summary: 'Kebiasaan sederhana untuk menjaga kebersihan gigi dan gusi.',
    duration: '2 menit',
    icon: Icons.cleaning_services_rounded,
    paragraphs: [
      'Menyikat gigi secara teratur merupakan salah satu '
          'langkah penting untuk menjaga kesehatan gigi dan mulut.',
      'Gunakan sikat gigi berbulu lembut dan pasta gigi '
          'berfluorida. Bersihkan seluruh permukaan gigi '
          'secara perlahan, setidaknya dua kali sehari.',
      'Sela-sela gigi juga perlu dibersihkan menggunakan '
          'benang gigi atau alat yang dianjurkan tenaga kesehatan.',
    ],
    tipTitle: 'Jaga kebiasaan setiap hari',
    tip:
        'Sikat gigi dua kali sehari, gunakan pasta gigi '
        'berfluorida, dan konsultasikan teknik '
        'menyikat gigi saat pemeriksaan.',
  ),
  DentalArticle(
    title: 'Kenali Tanda Masalah Kesehatan Gigi',
    category: 'Kenali Gejala',
    summary: 'Jangan abaikan nyeri gigi, gusi berdarah, dan gigi sensitif.',
    duration: '3 menit',
    icon: Icons.health_and_safety_outlined,
    paragraphs: [
      'Nyeri gigi, gusi berdarah, gigi sensitif, '
          'dan bau mulut yang menetap dapat menjadi alasan '
          'untuk melakukan pemeriksaan gigi.',
      'Keluhan tersebut dapat mempunyai berbagai penyebab. '
          'Pemeriksaan oleh dokter diperlukan untuk menentukan '
          'penanganan yang sesuai.',
      'Jika terjadi pembengkakan wajah yang memburuk, '
          'demam disertai dugaan infeksi gigi, atau kesulitan '
          'menelan maupun bernapas, segera cari pertolongan medis.',
    ],
    tipTitle: 'Jangan menentukan diagnosis sendiri',
    tip:
        'Gunakan kolom keluhan saat pendaftaran untuk '
        'menjelaskan kondisi dengan bahasa sehari-hari. '
        'Dokter tetap perlu melakukan pemeriksaan.',
  ),
];

// ======================================================
// BERANDA
// ======================================================

class HomeTab extends StatelessWidget {
  final DemoStore store;
  final Future<void> Function({String? poliId}) onBook;
  final void Function(int) onTab;
  final void Function(Booking) onDetail;

  const HomeTab({
    super.key,
    required this.store,
    required this.onBook,
    required this.onTab,
    required this.onDetail,
  });

  void openService(BuildContext context, DentalService service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DentalIllustration(icon: service.icon, size: 100),
                const SizedBox(height: 16),
                Text(
                  service.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: C.deep,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  service.detail,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.7,
                    color: C.muted,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Informasi layanan simulasi. '
                  'Tindakan ditentukan setelah pemeriksaan.',
                  style: TextStyle(fontSize: 11, color: C.muted),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = store.patient?.name.split(' ').first ?? 'Pasien';
    final next = store.nextBooking;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: C.mint,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: ToothIcon(size: 36, color: C.green)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
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
                    'Layanan kesehatan gigi & mulut',
                    style: TextStyle(fontSize: 10.5, color: C.muted),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => onTab(3),
              icon: const Icon(Icons.person_outline_rounded),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          'Halo, $name!',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: C.deep,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Yuk, jaga kesehatan gigi dan senyum Anda.',
          style: TextStyle(fontSize: 12, color: C.muted),
        ),
        const SizedBox(height: 20),

        // BANNER PENDAFTARAN
        Container(
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.green, C.deep]),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              const Positioned(
                right: -10,
                top: 8,
                child: Opacity(
                  opacity: .18,
                  child: ToothIcon(size: 110, color: Colors.white),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PENDAFTARAN ONLINE',
                    style: TextStyle(
                      color: Color(0xFFD5F0E2),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: 220,
                    child: Text(
                      'Senyum sehat dimulai dari sini',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 230,
                    child: Text(
                      'Ceritakan keluhan jika ada, pilih jadwal, '
                      'lalu dapatkan tiket reservasi.',
                      style: TextStyle(
                        color: Color(0xFFE0F5E9),
                        fontSize: 11.5,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),
                  FilledButton.icon(
                    onPressed: () => onBook(),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: C.green,
                    ),
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: const Text('Daftar Kunjungan'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 27),

        // KUNJUNGAN
        const SectionTitle('Kunjungan Mendatang'),
        const SizedBox(height: 12),
        if (next == null)
          const SheetCard(
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: C.green, size: 28),
                SizedBox(width: 13),
                Expanded(
                  child: Text(
                    'Belum ada pendaftaran aktif. '
                    'Silakan daftar untuk pemeriksaan gigi.',
                    style: TextStyle(fontSize: 12, height: 1.6, color: C.muted),
                  ),
                ),
              ],
            ),
          )
        else
          InkWell(
            onTap: () => onDetail(next),
            child: BookingTile(booking: next),
          ),
        const SizedBox(height: 28),

        // KATALOG PELAYANAN
        const SectionTitle('Pelayanan Kesehatan Gigi'),
        const SizedBox(height: 6),
        const Text(
          'Kenali berbagai jenis perawatan gigi dan mulut.',
          style: TextStyle(fontSize: 11.5, color: C.muted),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dentalServices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 255,
          ),
          itemBuilder: (context, index) {
            final service = dentalServices[index];
            return DentalServiceCard(
              service: service,
              onTap: () => openService(context, service),
            );
          },
        ),
        const SizedBox(height: 28),

        // EDUKASI
        const Row(
          children: [
            Icon(Icons.menu_book_rounded, color: C.green, size: 21),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Edukasi & Tips Kesehatan Gigi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: C.deep,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Artikel dan panduan sederhana untuk menjaga kesehatan gigi.',
          style: TextStyle(fontSize: 11.5, color: C.muted, height: 1.5),
        ),
        const SizedBox(height: 16),
        ...dentalArticles.map(
          (article) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DentalArticleCard(
              article: article,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DentalArticlePage(article: article),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SheetCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: C.green),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  '',
                  style: TextStyle(fontSize: 11, color: C.muted, height: 1.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'RSGM COMAL • Prototipe Tugas UTS',
            style: TextStyle(fontSize: 10, color: C.muted),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// KARTU PELAYANAN
// ======================================================

class DentalServiceCard extends StatelessWidget {
  final DentalService service;
  final VoidCallback onTap;

  const DentalServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: C.line),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              DentalIllustration(icon: service.icon, size: 74),
              const SizedBox(height: 12),
              Text(
                service.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: C.deep,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  service.description,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.2,
                    height: 1.5,
                    color: C.muted,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Baca selengkapnya',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: C.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// KARTU ARTIKEL
// ======================================================

class DentalArticleCard extends StatelessWidget {
  final DentalArticle article;
  final VoidCallback onTap;

  const DentalArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ArticleTag(article.category),
                  const Spacer(),
                  const Icon(Icons.schedule_rounded, size: 15, color: C.green),
                  const SizedBox(width: 4),
                  Text(
                    'Baca ${article.duration}',
                    style: const TextStyle(fontSize: 10, color: C.muted),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: C.mint,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: ToothIcon(size: 43, color: C.green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: C.deep,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          article.summary,
                          style: const TextStyle(
                            fontSize: 11,
                            color: C.muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Baca Selengkapnya',
                    style: TextStyle(
                      color: C.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_rounded, color: C.green, size: 17),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// HALAMAN DETAIL ARTIKEL
// ======================================================

class DentalArticlePage extends StatelessWidget {
  final DentalArticle article;

  const DentalArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edukasi Kesehatan Gigi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ArticleTag(article.category),
            ),
            const SizedBox(height: 15),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 23,
                height: 1.3,
                color: C.deep,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: C.mint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: C.green,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tim Edukasi RSGM COMAL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: C.deep,
                          ),
                        ),
                        Text(
                          'Materi simulasi • ${article.duration} baca',
                          style: const TextStyle(
                            color: C.muted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 195,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [C.mint, Color(0xFFD4F5E7)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const ToothIcon(size: 140, color: C.green),
                  Positioned(
                    right: 45,
                    bottom: 24,
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.white,
                      child: Icon(article.icon, color: C.green, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            ...article.paragraphs.map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  paragraph,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.8,
                    color: C.muted,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: C.mint,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.tips_and_updates_rounded,
                        color: C.green,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          article.tipTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: C.deep,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.tip,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Artikel ini adalah materi edukasi simulasi. '
              'Informasi tidak menggantikan pemeriksaan dokter gigi.',
              style: TextStyle(fontSize: 10.5, color: C.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleTag extends StatelessWidget {
  final String label;

  const ArticleTag(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: C.mint,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: C.green,
        ),
      ),
    );
  }
}

// ======================================================
// ILUSTRASI GIGI CUSTOM
// ======================================================

class DentalIllustration extends StatelessWidget {
  final IconData icon;
  final double size;

  const DentalIllustration({super.key, required this.icon, this.size = 74});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: C.mint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ToothIcon(size: size * .70, color: C.green),
          Positioned(
            right: 3,
            bottom: 3,
            child: CircleAvatar(
              radius: size * .16,
              backgroundColor: Colors.white,
              child: Icon(icon, color: C.green, size: size * .22),
            ),
          ),
        ],
      ),
    );
  }
}

class ToothIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ToothIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: ToothPainter(color)),
    );
  }
}

class ToothPainter extends CustomPainter {
  final Color color;

  const ToothPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * .50, h * .19)
      ..cubicTo(w * .30, h * .06, w * .12, h * .17, w * .16, h * .40)
      ..cubicTo(w * .19, h * .57, w * .27, h * .84, w * .37, h * .86)
      ..cubicTo(w * .45, h * .88, w * .44, h * .61, w * .50, h * .61)
      ..cubicTo(w * .56, h * .61, w * .55, h * .88, w * .63, h * .86)
      ..cubicTo(w * .73, h * .84, w * .81, h * .57, w * .84, h * .40)
      ..cubicTo(w * .88, h * .17, w * .70, h * .06, w * .50, h * .19)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .045
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final smile = Path()
      ..moveTo(w * .39, h * .40)
      ..quadraticBezierTo(w * .50, h * .49, w * .61, h * .40);

    canvas.drawPath(
      smile,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .033
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(w * .37, h * .33),
      w * .018,
      Paint()..color = color,
    );

    canvas.drawCircle(
      Offset(w * .63, h * .33),
      w * .018,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant ToothPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// ======================================================
// BOOKING TILE
// ======================================================

class BookingTile extends StatelessWidget {
  final Booking booking;
  final bool showStatus;

  const BookingTile({super.key, required this.booking, this.showStatus = true});

  @override
  Widget build(BuildContext context) {
    return SheetCard(
      child: Column(
        children: [
          Row(
            children: [
              PoliIcon(findPoli(booking.poliId), size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.poliId == 'umum'
                          ? 'Pemeriksaan awal gigi'
                          : findPoli(booking.poliId).name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shortDate(booking.date),
                      style: const TextStyle(color: C.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (showStatus) StatusPill(booking.status),
            ],
          ),
          const SizedBox(height: 13),
          const Divider(color: C.line),
          Row(
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                color: C.green,
                size: 18,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  booking.id,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: C.muted),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// PENDAFTARAN SAYA
// ======================================================

class BookingsTab extends StatelessWidget {
  final DemoStore store;
  final VoidCallback onBook;
  final void Function(Booking) onDetail;

  const BookingsTab({
    super.key,
    required this.store,
    required this.onBook,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const HeaderText(
          'Pendaftaran Saya',
          'Pantau tiket, status, dan jadwal reservasi Anda.',
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: onBook,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Buat pendaftaran baru'),
        ),
        const SizedBox(height: 25),
        const SectionTitle('Pendaftaran aktif'),
        const SizedBox(height: 13),
        if (store.active.isEmpty)
          EmptyView(
            icon: Icons.event_busy_outlined,
            title: 'Belum ada pendaftaran aktif',
            description: 'Pendaftaran yang berhasil akan terlihat di sini.',
            action: OutlinedButton(
              onPressed: onBook,
              child: const Text('Daftar sekarang'),
            ),
          )
        else
          ...store.active.map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onDetail(booking),
                child: BookingTile(booking: booking),
              ),
            ),
          ),
      ],
    );
  }
}

// ======================================================
// RIWAYAT KUNJUNGAN
// ======================================================

class HistoryTab extends StatelessWidget {
  final DemoStore store;
  final void Function(Booking) onDetail;

  const HistoryTab({super.key, required this.store, required this.onDetail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const HeaderText(
          'Riwayat Kunjungan',
          'Kunjungan yang telah selesai di RSGM COMAL.',
        ),
        const SizedBox(height: 20),
        if (store.completed.isEmpty)
          const EmptyView(
            icon: Icons.history_toggle_off_rounded,
            title: 'Belum ada riwayat kunjungan',
            description:
                'Kunjungan akan muncul setelah pelayanan '
                'dinyatakan selesai dalam simulasi.',
          ),
        ...store.completed.map(
          (booking) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => onDetail(booking),
              child: BookingTile(booking: booking),
            ),
          ),
        ),
      ],
    );
  }
}
