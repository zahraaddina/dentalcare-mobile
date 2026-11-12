import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';
import '../services/patient_api.dart';

class DemoStore extends ChangeNotifier {
  Patient? patient;
  List<Booking> bookings = [];
  bool ready = false;

  static const _bookingsKey = 'rsgm_demo_bookings_v2';
  static const _paymentKey = 'rsgm_demo_payment_v1';
  static const _tokenKey = 'rsgm_patient_token_v1';

  static const _secure = FlutterSecureStorage();

  String? _token;

  Map<String, String> patientDetails = {};
  Map<String, Map<String, String>> bookingPayments = {};

  String patientDetail(String key) {
    final value = patientDetails[key];
    return value == null || value.isEmpty ? '-' : value;
  }

  // =====================================================
  // DATA PASIEN DARI LARAVEL
  // =====================================================

  void _applyPatient(Map<String, dynamic> data) {
    final patientId = int.parse(data['id'].toString());

    patient = Patient(
      id: 'PS-${patientId.toString().padLeft(4, '0')}',
      name: data['name'].toString(),
      birth: data['birth'].toString(),
      gender: data['gender'].toString(),
      phone: data['phone'].toString(),
      address: data['address'].toString(),
      rm: data['rm']?.toString(),
    );

    patientDetails = {
      'nik': data['nik']?.toString() ?? '',
      'birthPlace': data['birthPlace']?.toString() ?? '',
      'province': data['province']?.toString() ?? '',
      'city': data['city']?.toString() ?? '',
      'district': data['district']?.toString() ?? '',
      'village': data['village']?.toString() ?? '',
    };
  }

  // =====================================================
  // MEMULIHKAN SESI PASIEN
  // =====================================================

  Future<void> initialize() async {
    ready = false;

    try {
      _token = await _secure.read(key: _tokenKey);

      if (_token != null && _token!.isNotEmpty) {
        final result = await PatientApi.me(_token!);

        _applyPatient(Map<String, dynamic>.from(result['patient'] as Map));

        await _loadLocalBookings();
      }
    } on PatientApiException catch (error) {
      patient = null;
      patientDetails = {};
      bookings = [];
      bookingPayments = {};

      if (error.statusCode == 401) {
        await _secure.delete(key: _tokenKey);
        _token = null;
      }
    } catch (_) {
      patient = null;
      patientDetails = {};
      bookings = [];
      bookingPayments = {};
    }

    ready = true;
    notifyListeners();
  }

  // =====================================================
  // DATA BOOKING MASIH LOKAL
  // =====================================================

  Future<void> _loadLocalBookings() async {
    final prefs = await SharedPreferences.getInstance();

    final rawBookings = prefs.getString(_bookingsKey);
    final rawPayments = prefs.getString(_paymentKey);

    bookings = [];
    bookingPayments = {};

    if (rawBookings != null) {
      try {
        bookings = (jsonDecode(rawBookings) as List)
            .map(
              (value) =>
                  Booking.fromJson(Map<String, dynamic>.from(value as Map)),
            )
            .toList();
      } catch (_) {
        bookings = [];
      }
    }

    if (rawPayments != null) {
      try {
        final decoded = Map<String, dynamic>.from(
          jsonDecode(rawPayments) as Map,
        );

        bookingPayments = decoded.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
        );
      } catch (_) {
        bookingPayments = {};
      }
    }
  }

  Future<void> _saveLocalBookings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _bookingsKey,
      jsonEncode(bookings.map((booking) => booking.toJson()).toList()),
    );

    await prefs.setString(_paymentKey, jsonEncode(bookingPayments));

    notifyListeners();
  }

  // =====================================================
  // REGISTER PASIEN BARU
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
    final result = await PatientApi.register(
      nik: nik,
      name: name,
      birthPlace: birthPlace,
      birthDate: birth,
      gender: gender,
      phone: phone,
      address: address,
      province: province,
      city: city,
      district: district,
      village: village,
    );

    final token = result['token'].toString();

    // Simpan token lebih dulu.
    await _secure.write(key: _tokenKey, value: token);

    _token = token;

    _applyPatient(Map<String, dynamic>.from(result['patient'] as Map));

    // Booking lama adalah simulasi lokal.
    bookings = [];
    bookingPayments = {};
    await _saveLocalBookings();

    notifyListeners();
  }

  // =====================================================
  // LOGIN PASIEN LAMA
  // =====================================================

  Future<bool> identifyOld(String rm, String birth) async {
    Map<String, dynamic> result;

    try {
      result = await PatientApi.login(
        rm: rm.trim().toUpperCase(),
        birthDate: birth,
      );
    } on PatientApiException catch (error) {
      if (error.statusCode == 422 || error.statusCode == 401) {
        return false;
      }

      rethrow;
    }

    final token = result['token'].toString();

    await _secure.write(key: _tokenKey, value: token);

    _token = token;

    _applyPatient(Map<String, dynamic>.from(result['patient'] as Map));

    // Booking masih lokal, belum dikembalikan oleh backend.
    bookings = [];
    bookingPayments = {};
    await _saveLocalBookings();

    notifyListeners();

    return true;
  }

  // =====================================================
  // EDIT KONTAK, TERSIMPAN KE MYSQL
  // =====================================================

  Future<void> editContact(String phone, String address) async {
    if (patient == null || _token == null) {
      throw StateError('Sesi pasien tidak ditemukan');
    }

    final result = await PatientApi.editContact(
      token: _token!,
      phone: phone,
      address: address,
    );

    _applyPatient(Map<String, dynamic>.from(result['patient'] as Map));

    notifyListeners();
  }

  // =====================================================
  // LOGOUT: DATA DATABASE TIDAK DIHAPUS
  // =====================================================

  Future<void> signOut() async {
    final token = _token;

    if (token != null) {
      try {
        await PatientApi.logout(token);
      } catch (_) {
        // Sesi lokal tetap dihapus jika server tidak tersedia.
      }
    }

    await _secure.delete(key: _tokenKey);
    _token = null;

    patient = null;
    patientDetails = {};
    bookings = [];
    bookingPayments = {};

    notifyListeners();
  }

  // =====================================================
  // BOOKING MILIK PASIEN
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
  // PEMBAYARAN BOOKING (SIMULASI)
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
  // TANGGAL, JADWAL, DAN KUOTA SIMULASI
  // =====================================================

  static String dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
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
  // MEMBUAT BOOKING (BELUM KE MYSQL)
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
      throw StateError('Profil pasien belum tersedia');
    }

    final selectedDate = DateTime.tryParse(date);
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    if (selectedDate == null || selectedDate.isBefore(today)) {
      throw StateError('Tanggal kunjungan tidak valid');
    }

    if (available(poli, date, session) <= 0) {
      throw StateError('Kuota sesi penuh');
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

    await _saveLocalBookings();

    return booking;
  }

  // =====================================================
  // BATAL BOOKING SIMULASI
  // =====================================================

  Future<void> cancel(String id) async {
    final index = bookings.indexWhere(
      (b) => b.id == id && b.patientId == patient?.id,
    );

    if (index < 0 || bookings[index].status != 'registered') {
      return;
    }

    bookings.removeAt(index);
    bookingPayments.remove(id);

    await _saveLocalBookings();
  }

  // =====================================================
  // SIMULASI STATUS (TIDAK DIPAKAI UI PASIEN)
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

    await _saveLocalBookings();
  }
}
