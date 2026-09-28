import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Mahasiswa',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const FormMahasiswa(),
    );
  }
}

// ========================================
// HALAMAN FORM MAHASISWA
// ========================================

class FormMahasiswa extends StatefulWidget {
  const FormMahasiswa({super.key});

  @override
  State<FormMahasiswa> createState() => _FormMahasiswaState();
}

class _FormMahasiswaState extends State<FormMahasiswa> {
  // Controller untuk mengambil data input
  final TextEditingController namaController = TextEditingController();
  final TextEditingController npmController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();

  // Image Picker
  final ImagePicker picker = ImagePicker();

  // Menyimpan foto yang dipilih
  File? fotoProfil;

  // ========================================
  // FUNGSI MEMILIH FOTO
  // ========================================

  Future<void> pilihFoto() async {
    final XFile? foto = await picker.pickImage(source: ImageSource.gallery);

    if (foto != null) {
      setState(() {
        fotoProfil = File(foto.path);
      });
    }
  }

  // ========================================
  // FUNGSI SAVE
  // ========================================

  void simpanData() {
    if (namaController.text.isEmpty ||
        npmController.text.isEmpty ||
        jurusanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi semua data terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tampilkan notifikasi berhasil
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Data berhasil disimpan!'),
          actions: [
            TextButton(
              onPressed: () {
                // Tutup dialog
                Navigator.pop(context);

                // Pindah ke halaman profil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilMahasiswa(
                      nama: namaController.text,
                      npm: npmController.text,
                      jurusan: jurusanController.text,
                      foto: fotoProfil,
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    npmController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  // ========================================
  // TAMPILAN FORM
  // ========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================
            // JUDUL
            // ========================================

            const Text(
              'Lengkapi Data Anda',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Masukkan informasi mahasiswa di bawah ini.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 30),

            // ========================================
            // FOTO PROFIL
            // ========================================
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pilihFoto,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.blue.shade50,
                      backgroundImage: fotoProfil != null
                          ? FileImage(fotoProfil!)
                          : null,
                      child: fotoProfil == null
                          ? Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.blue.shade700,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Pilih Foto Profil',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // ========================================
            // INPUT NAMA
            // ========================================
            const Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            TextField(
              controller: namaController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama lengkap',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ========================================
            // INPUT NPM
            // ========================================
            const Text('NPM', style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            TextField(
              controller: npmController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan NPM',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ========================================
            // INPUT JURUSAN
            // ========================================
            const Text(
              'Jurusan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: jurusanController,
              decoration: InputDecoration(
                hintText: 'Masukkan jurusan',
                prefixIcon: const Icon(Icons.school_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ========================================
            // BUTTON SAVE
            // ========================================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: simpanData,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'SAVE',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ========================================
// HALAMAN PROFIL MAHASISWA
// ========================================

class ProfilMahasiswa extends StatelessWidget {
  final String nama;
  final String npm;
  final String jurusan;
  final File? foto;

  const ProfilMahasiswa({
    super.key,
    required this.nama,
    required this.npm,
    required this.jurusan,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ========================================
            // FOTO
            // ========================================

            CircleAvatar(
              radius: 85,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: foto != null ? FileImage(foto!) : null,
              child: foto == null
                  ? Icon(Icons.person, size: 80, color: Colors.blue.shade700)
                  : null,
            ),

            const SizedBox(height: 20),

            // ========================================
            // NAMA
            // ========================================
            Text(
              nama,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Profil Mahasiswa',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            // ========================================
            // KARTU INFORMASI
            // ========================================
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Icons.badge_outlined,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      title: const Text(
                        'NPM',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(npm),
                    ),

                    const Divider(),

                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Icons.school_outlined,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      title: const Text(
                        'Jurusan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(jurusan),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
