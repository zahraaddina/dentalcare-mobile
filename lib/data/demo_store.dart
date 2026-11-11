import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';

class DemoStore extends ChangeNotifier {
  Patient? patient;
  List<Booking> bookings = [];
  bool ready = false;

  static const _patientKey = 'rsgm_demo_patient_v2';
  static const _bookingsKey = 'rsgm_demo_bookings_v2';
  static const _paymentKey = 'rsgm_demo_payment_v1';
  static const _patientDetailsKey = 'rsgm_patient_details_v1';

  Map<String, Map<String, String>> bookingPayments = {};

  // Data tambahan identitas pasien.
  Map<String, String> patientDetails = {};

  String patientDetail(String key) {
    final value = patientDetails[key];
    return value == null || value.isEmpty ? '-' : value;
  }

  // =====================================================
  // MEMUAT DATA LOKAL
  // =====================================================

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final savedPatient = prefs.getString(_patientKey);
    if (savedPatient != null) {
      try {
        patient = Patient.fromJson(
          Map<String, dynamic>.from(jsonDecode(savedPatient) as Map),
        );
      } catch (_) {
        patient = null;
      }
    }

    final savedBookings = prefs.getString(_bookingsKey);
    if (savedBookings != null) {
      try {
        bookings = (jsonDecode(savedBookings) as List)
            .map((e) => Booking.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        bookings = [];
      }
    }

    final savedPayments = prefs.getString(_paymentKey);
    if (savedPayments != null) {
      try {
        final decoded = Map<String, dynamic>.from(
          jsonDecode(savedPayments) as Map,
        );

        bookingPayments = decoded.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
        );
      } catch (_) {
        bookingPayments = {};
      }
    }

    final savedDetails = prefs.getString(_patientDetailsKey);
    if (savedDetails != null) {
      try {
        patientDetails = Map<String, String>.from(
          jsonDecode(savedDetails) as Map,
        );
      } catch (_) {
        patientDetails = {};
      }
    }

    ready = true;
    notifyListeners();
  }

  // =====================================================
  // MENYIMPAN DATA LOKAL
  // =====================================================

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    if (patient == null) {
      await prefs.remove(_patientKey);
    } else {
      await prefs.setString(_patientKey, jsonEncode(patient!.toJson()));
    }

    await prefs.setString(
      _bookingsKey,
      jsonEncode(bookings.map((b) => b.toJson()).toList()),
    );

    await prefs.setString(_paymentKey, jsonEncode(bookingPayments));

    await prefs.setString(_patientDetailsKey, jsonEncode(patientDetails));

    notifyListeners();
  }

  // =====================================================
  // PENDAFTARAN PASIEN BARU
  // =====================================================

  Future<void> register({
    required String name,
    required String birth,
    required String gender,
    required String phone,
    required String address,
    String nik = '',
    String birthPlace = '',
    String province = '',
    String city = '',
    String district = '',
    String village = '',
  }) async {
    patient = Patient(
      id: 'PS-0001',
      name: name,
      birth: birth,
      gender: gender,
      phone: phone,
      address: address,
    );

    patientDetails = {
      'nik': nik,
      'birthPlace': birthPlace,
      'province': province,
      'city': city,
      'district': district,
      'village': village,
    };

    bookings = [];
    bookingPayments = {};

    await _save();
  }

  // =====================================================
  // PASIEN LAMA (DATA DEMO)
  // =====================================================

  Future<bool> identifyOld(String rm, String birth) async {
    if (rm.trim().toUpperCase() != 'RM-00025' || birth != '2002-05-15') {
      return false;
    }

    patient = const Patient(
      id: 'PS-0025',
      name: 'Budi Santoso',
      birth: '2002-05-15',
      gender: 'Laki-laki',
      phone: '0812-0000-0025',
      address: 'Alamat simulasi, Comal',
      rm: 'RM-00025',
    );

    // Detail yang tidak tersedia dibiarkan kosong.
    patientDetails = {};

    final previousDate = DateTime.now().subtract(const Duration(days: 23));

    bookings = [
      Booking(
        id: 'RSGM-DEMO-0001',
        patientId: patient!.id,
        poliId: 'umum',
        date: dateKey(previousDate),
        session: 'pagi',
        queue: 'A-003',
        status: 'completed',
        createdAt: previousDate.toIso8601String(),
      ),
    ];

    bookingPayments = {
      'RSGM-DEMO-0001': {'method': 'umum'},
    };

    await _save();
    return true;
  }

  // =====================================================
  // EDIT KONTAK
  // =====================================================

  Future<void> editContact(String phone, String address) async {
    if (patient == null) return;

    patient = patient!.copyWith(phone: phone, address: address);

    await _save();
  }

  // =====================================================
  // KELUAR
  // =====================================================

  Future<void> signOut() async {
    patient = null;
    bookings = [];
    bookingPayments = {};
    patientDetails = {};

    await _save();
  }

  // =====================================================
  // DATA BOOKING
  // =====================================================

  List<Booking> get ownBookings =>
      bookings.where((b) => b.patientId == patient?.id).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Booking> get active => ownBookings
      .where((b) => !['completed', 'cancelled', 'no_show'].contains(b.status))
      .toList();

  List<Booking> get completed =>
      ownBookings.where((b) => b.status == 'completed').toList();

  List<Booking> get cancelled => ownBookings
      .where((b) => b.status == 'cancelled' || b.status == 'no_show')
      .toList();

  Booking? get nextBooking {
    if (active.isEmpty) return null;

    final list = active.toList()..sort((a, b) => a.date.compareTo(b.date));

    return list.first;
  }

  // =====================================================
  // INFORMASI PEMBAYARAN
  // =====================================================

  Map<String, String> paymentOf(String bookingId) {
    return bookingPayments[bookingId] ?? {'method': 'umum'};
  }

  String paymentLabel(String bookingId) {
    final method = paymentOf(bookingId)['method'];

    switch (method) {
      case 'bpjs':
        return 'BPJS Kesehatan';

      case 'asuransi':
        return 'Asuransi Lain';

      default:
        return 'Umum / Mandiri';
    }
  }

  // =====================================================
  // JADWAL DAN KUOTA
  // =====================================================

  static String dateKey(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  int occupied(String poli, String date, String session) {
    final base =
        (poli == 'umum'
            ? 3
            : poli == 'konservasi'
            ? 2
            : 1) +
        (session == 'siang' ? 1 : 0);

    final dynamicCount = bookings
        .where(
          (b) =>
              b.poliId == poli &&
              b.date == date &&
              b.session == session &&
              b.status != 'cancelled',
        )
        .length;

    final day = DateTime.tryParse(date);

    if (day?.weekday == DateTime.monday &&
        poli == 'umum' &&
        session == 'siang') {
      return 10;
    }

    return (base + dynamicCount).clamp(0, 10);
  }

  int available(String poli, String date, String session) {
    return 10 - occupied(poli, date, session);
  }

  bool isDuplicate(String poli, String date) {
    return active.any((b) => b.poliId == poli && b.date == date);
  }

  // =====================================================
  // MEMBUAT PENDAFTARAN KUNJUNGAN
  // =====================================================

  Future<Booking> createBooking(
    String poli,
    String date,
    String session, {
    String complaint = '',
    String paymentMethod = 'umum',
    String bpjsNumber = '',
    String referralNumber = '',
    String insuranceName = '',
    String policyNumber = '',
  }) async {
    if (patient == null) {
      throw StateError('Profil belum tersedia');
    }

    final selected = DateTime.tryParse(date);
    final now = DateTime.now();

    final startOfToday = DateTime(now.year, now.month, now.day);

    if (selected == null || selected.isBefore(startOfToday)) {
      throw StateError('Tanggal kunjungan tidak valid');
    }

    if (available(poli, date, session) <= 0) {
      throw StateError('Kuota sesi ini penuh');
    }

    if (isDuplicate(poli, date)) {
      throw StateError('Sudah ada pendaftaran aktif pada tanggal ini');
    }

    if (!['umum', 'bpjs', 'asuransi'].contains(paymentMethod)) {
      throw StateError('Jenis pembayaran tidak valid');
    }

    if (paymentMethod == 'bpjs' && bpjsNumber.trim().isEmpty) {
      throw StateError('Isi nomor peserta BPJS');
    }

    if (paymentMethod == 'asuransi' &&
        (insuranceName.trim().isEmpty || policyNumber.trim().isEmpty)) {
      throw StateError('Lengkapi data asuransi');
    }

    final queueNumber = occupied(poli, date, session) + 1;

    final queue =
        '${findPoli(poli).prefix}-'
        '${queueNumber.toString().padLeft(3, '0')}';

    final id =
        'RSGM-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final booking = Booking(
      id: id,
      patientId: patient!.id,
      poliId: poli,
      date: date,
      session: session,
      queue: queue,
      status: 'registered',
      createdAt: DateTime.now().toIso8601String(),
      complaint: complaint.trim(),
    );

    bookings.add(booking);

    bookingPayments[id] = {
      'method': paymentMethod,
      'bpjsNumber': bpjsNumber.trim(),
      'referralNumber': referralNumber.trim(),
      'insuranceName': insuranceName.trim(),
      'policyNumber': policyNumber.trim(),
    };

    await _save();

    return booking;
  }

  // =====================================================
  // BATAL PENDAFTARAN
  // =====================================================

  Future<void> cancel(String id) async {
    final index = bookings.indexWhere(
      (b) => b.id == id && b.patientId == patient?.id,
    );

    if (index < 0 || bookings[index].status != 'registered') {
      return;
    }

    // Booking yang dibatalkan langsung hilang.
    bookings.removeAt(index);
    bookingPayments.remove(id);

    await _save();
  }

  // =====================================================
  // SIMULASI STATUS KHUSUS DEBUG
  // =====================================================

  Future<void> simulateNext(String id) async {
    if (!kDebugMode) return;

    final index = bookings.indexWhere((b) => b.id == id);

    if (index < 0) return;

    const transitions = {
      'registered': 'checked_in',
      'checked_in': 'waiting',
      'waiting': 'in_service',
      'in_service': 'completed',
    };

    final nextStatus = transitions[bookings[index].status];

    if (nextStatus == null) return;

    bookings[index] = bookings[index].withStatus(nextStatus);

    await _save();
  }
}
