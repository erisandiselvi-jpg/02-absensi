import 'dart:io';

import 'data.dart';
import 'input.dart';

// ============================================================
// Fungsi bantu
// ============================================================

/// Mencari mahasiswa berdasarkan NIM. Mengembalikan null jika tidak ada.
Map<String, dynamic>? cariByNim(String nim) {
  for (final mhs in daftarMahasiswa) {
    if (mhs['nim'] == nim) return mhs;
  }
  return null;
}

/// Mencetak satu baris data mahasiswa.
void cetakMahasiswa(Map<String, dynamic> mhs) {
  print('${mhs['nim']} | ${mhs['nama']}');
}

/// Meminta pengguna memilih status kehadiran.
StatusHadir bacaStatus(String label) {
  final pilihan = bacaInt(
    '$label (1=hadir, 2=izin, 3=sakit, 4=alpa)',
    min: 1,
    max: 4,
  );
  return switch (pilihan) {
    1 => StatusHadir.hadir,
    2 => StatusHadir.izin,
    3 => StatusHadir.sakit,
    _ => StatusHadir.alpa,
  };
}

// ============================================================
// Fitur yang sudah jadi
// ============================================================

/// Menu 1: menampilkan semua mahasiswa.
void tampilkanDaftar() {
  print('\n=== Daftar Mahasiswa ===');
  if (daftarMahasiswa.isEmpty) {
    print('Belum ada data mahasiswa.');
    return;
  }
  for (final mhs in daftarMahasiswa) {
    cetakMahasiswa(mhs);
  }
}

/// Menu 2: mencatat absensi untuk pertemuan berikutnya.
void catatAbsensi() {
  final nomor = absensi.length + 1;
  print('\n=== Catat Absensi Pertemuan $nomor ===');
  final Map<String, StatusHadir> data = {};
  for (final mhs in daftarMahasiswa) {
    data[mhs['nim'] as String] = bacaStatus('Status ${mhs['nama']}');
  }
  absensi[nomor] = data;
  print('Absensi pertemuan $nomor tersimpan.');
}

/// Menu 3: menampilkan absensi pada satu pertemuan.
void tampilkanAbsensiPertemuan() {
  print('\n=== Absensi per Pertemuan ===');
  if (absensi.isEmpty) {
    print('Belum ada absensi.');
    return;
  }
  final nomor = bacaInt('Nomor pertemuan', min: 1, max: absensi.length);
  final data = absensi[nomor]!;
  print('Pertemuan $nomor:');
  for (final mhs in daftarMahasiswa) {
    final status = data[mhs['nim']];
    print('${mhs['nim']} | ${mhs['nama']} | ${status?.name ?? '-'}');
  }
}

// ============================================================
// Fitur pilihan (pilih minimal 3, lihat README.md)
// ============================================================

/// Menu 4 [Mudah]: menambah mahasiswa baru.
void tambahMahasiswa() {
  print('\n=== Tambah Mahasiswa ===');

  stdout.write('NIM: ');
  String nim =
  stdin.readLineSync()!;

  // Cek apakah NIM sudah terdaftar
  if (cariByNim(nim) != null) {
    print('Nim sudah terdaftar!');
  }

  stdout.write('Nama: ');
  String nama =
  stdin.readLineSync()!;

  // Tambahkan ke daftarMahasiswa
  daftarMahasiswa.add({
    'nim': nim,
    'nama': nama,
  });

  print('Mahasiswa $nama berhasil ditambahkan');
}

/// Menu 5 [Mudah]: mencari mahasiswa berdasarkan sebagian nama.
void cariMahasiswa() {
  print('\n=== Cari Mahasiswa ===');
  stdout.write('Nama: ');

String kataKunci = stdin.readLineSync() ?? '';

//Mengubah huruf menjadi kecil agar pencarian tidak membedakan huruf besar dan kecil
kataKunci = kataKunci.toLowerCase();

bool ditemukan = false;

for (var mahasiswa in daftarMahasiswa) {
  if (mahasiswa['nama']!
  .toLowerCase()
  .contains(kataKunci)) {
    print('${mahasiswa['nim']} | ${mahasiswa['nama']}');
    ditemukan = true;
  }
}

if (!ditemukan) {
  print('Mahasiswa tidak ditemukan.');
}
}

/// Menu 6 [Sedang]: mengubah status absensi seorang mahasiswa.
void ubahStatus() {
  print('=== Ubah Status Absensi ===');

  stdout.write('Nomor pertemuan: ');
  int nomor = int.parse(stdin.readLineSync()!);

  stdout.write('NIM: ');
  String nim = stdin.readLineSync()!;

  stdout.write('Status baru (1=hadir, 2=izin, 3=sakit, 4=alpa): ');
  int pilihan = int.parse(stdin.readLineSync()!);

  // Memeriksa nomor pertemuan
  if (!absensi.containsKey(nomor)) {
    print('Nomor pertemuan tidak ditemukan.');
    return;
  }

  // Memeriksa NIM mahasiswa
  if (!absensi[nomor]!.containsKey(nim)) {
    print('NIM mahasiswa tidak ditemukan pada pertemuan $nomor.');
    return;
  }

  // Menentukan status baru
  StatusHadir statusBaru;

  switch (pilihan) {
    case 1:
      statusBaru = StatusHadir.hadir;
      break;
    case 2:
      statusBaru = StatusHadir.izin;
      break;
    case 3:
      statusBaru = StatusHadir.sakit;
      break;
    case 4:
      statusBaru = StatusHadir.alpa;
      break;
    default:
      print('Pilihan status tidak valid.');
      return;
  }

  // Menyimpan status baru
  absensi[nomor]![nim] = statusBaru;

  // Mencari nama mahasiswa
  var mahasiswa = cariByNim(nim);
  String nama = mahasiswa != null ? mahasiswa['nama'].toString() : nim;

  print('Status $nama pada pertemuan $nomor diubah menjadi Hadir');
}

 
/// Menu 7 [Sedang]: menampilkan jumlah setiap status per mahasiswa.
void tampilkanRekap() {
  // TODO: untuk setiap mahasiswa, hitung berapa kali hadir, izin, sakit, dan alpa
  // dari semua pertemuan.
  print('Fitur belum tersedia.');
}

/// Menu 8 [Sulit]: menampilkan persentase kehadiran setiap mahasiswa.
void tampilkanPersentase() {
  // TODO: persentase = jumlah hadir / jumlah pertemuan x 100.
  // Tampilkan 1 angka di belakang koma.
  print('Fitur belum tersedia.');
}

/// Menu 9 [Sulit]: menampilkan mahasiswa dengan kehadiran di bawah batas.
void tampilkanDiBawahBatas() {
  // TODO: tampilkan mahasiswa yang persentase kehadirannya < batasKehadiran
  // (lihat data.dart) beserta persentasenya.
  print('Fitur belum tersedia.');
}
