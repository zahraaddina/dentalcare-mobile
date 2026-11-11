class Patient {
  final String id;
  final String name;
  final String birth;
  final String gender;
  final String phone;
  final String address;
  final String? rm;
  const Patient({required this.id, required this.name, required this.birth, required this.gender, required this.phone, required this.address, this.rm});
  Patient copyWith({String? phone, String? address}) => Patient(id: id, name: name, birth: birth, gender: gender, phone: phone ?? this.phone, address: address ?? this.address, rm: rm);
  Map<String, dynamic> toJson() => {'id':id,'name':name,'birth':birth,'gender':gender,'phone':phone,'address':address,'rm':rm};
  factory Patient.fromJson(Map<String,dynamic> json) => Patient(id:json['id'] as String,name:json['name'] as String,birth:json['birth'] as String,gender:json['gender'] as String,phone:json['phone'] as String,address:json['address'] as String,rm:json['rm'] as String?);
}

class Poli {
  final String id, name, short, description, details;
  final String prefix;
  final int iconId;
  const Poli(this.id,this.name,this.short,this.description,this.details,this.prefix,this.iconId);
}

const polies = [
  Poli('umum','Poli Gigi Umum','Gigi Umum','Pemeriksaan kesehatan gigi dan mulut umum.','Pemeriksaan awal kondisi gigi dan mulut serta konsultasi keluhan umum. Pilihan layanan yang sesuai akan ditentukan saat pemeriksaan oleh tenaga kesehatan.','A',0),
  Poli('konservasi','Poli Konservasi Gigi','Konservasi','Pelayanan perawatan dan pemeliharaan gigi.','Layanan yang berkaitan dengan upaya mempertahankan gigi, termasuk evaluasi kebutuhan restorasi atau perawatan saluran akar.','B',1),
  Poli('anak','Poli Kedokteran Gigi Anak','Gigi Anak','Pelayanan kesehatan gigi untuk pasien anak.','Pemeriksaan gigi dan mulut anak, edukasi kebersihan gigi, serta evaluasi kebutuhan perawatan sesuai kondisi pasien.','C',2),
];
Poli findPoli(String id) => polies.firstWhere((p)=>p.id==id, orElse:()=>polies.first);

class Booking {
  final String id, patientId, poliId, date, session, queue, status, createdAt;
  final String complaint;
  const Booking({required this.id,required this.patientId,required this.poliId,required this.date,required this.session,required this.queue,required this.status,required this.createdAt,this.complaint=''});
  Booking withStatus(String next) => Booking(id:id,patientId:patientId,poliId:poliId,date:date,session:session,queue:queue,status:next,createdAt:createdAt,complaint:complaint);
  Map<String,dynamic> toJson() => {'id':id,'patientId':patientId,'poliId':poliId,'date':date,'session':session,'queue':queue,'status':status,'createdAt':createdAt,'complaint':complaint};
  factory Booking.fromJson(Map<String,dynamic> j)=>Booking(id:j['id'] as String,patientId:j['patientId'] as String,poliId:j['poliId'] as String,date:j['date'] as String,session:j['session'] as String,queue:j['queue'] as String,status:j['status'] as String,createdAt:j['createdAt'] as String,complaint:j['complaint'] as String? ?? '');
}

const statuses = {'registered':'Terdaftar','checked_in':'Sudah check-in','waiting':'Menunggu','in_service':'Dalam pelayanan','completed':'Selesai','cancelled':'Dibatalkan','no_show':'Tidak hadir'};
String statusLabel(String status)=>statuses[status]??status;
String sessionLabel(String value)=> value=='pagi'?'08.00–10.00':'13.00–15.00';
