import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaporanProdukScreen extends StatefulWidget {
  const LaporanProdukScreen({super.key});

  @override
  State<LaporanProdukScreen> createState() => _LaporanProdukScreenState();
}

class _LaporanProdukScreenState extends State<LaporanProdukScreen> {
  List<Map<String, dynamic>> produkTerlaris = [
    {"nama": "Churros", "terjual": 150},
    {"nama": "Green Tea", "terjual": 130},
    {"nama": "Blue Soda", "terjual": 120},
  ];

  List<Map<String, dynamic>> produkKurangDiminati = [
    {"nama": "Onion Rings", "terjual": 10},
    {"nama": "Teh Tarik", "terjual": 8},
    {"nama": "Es Teh", "terjual": 5},
  ];

  void _editProduk(
      List<Map<String, dynamic>> list, int index, String kategori) {
    final item = list[index];
    final namaController = TextEditingController(text: item['nama']);
    final terjualController = TextEditingController(text: item['terjual'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Edit $kategori",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: terjualController,
              decoration: const InputDecoration(labelText: "Jumlah Terjual (Porsi)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF195C85),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Simpan", style: GoogleFonts.poppins(color: Colors.white)),
            onPressed: () {
              setState(() {
                list[index] = {
                  "nama": namaController.text,
                  "terjual": int.tryParse(terjualController.text) ?? item['terjual'],
                };
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _hapusProduk(List<Map<String, dynamic>> list, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Konfirmasi Hapus", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Yakin ingin menghapus item ini dari data?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                list.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Hapus", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Map<String, dynamic>> data,
    required String kategori,
    required Color badgeColor,
    required IconData badgeIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(badgeIcon, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "#${index + 1}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: badgeColor,
                    ),
                  ),
                ),
                title: Text(
                  item['nama'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                subtitle: Text(
                  "${item['terjual']} Porsi Terjual",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: Colors.blueGrey,
                      onPressed: () => _editProduk(data, index, kategori),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.redAccent,
                      onPressed: () => _hapusProduk(data, index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF195C85);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text(
          "Analisis Produk",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSection(
              title: "Produk Terlaris (Favorit)",
              subtitle: "Menu dengan tingkat pembelian tertinggi",
              data: produkTerlaris,
              kategori: "Produk Terlaris",
              badgeColor: const Color(0xFFE67E22),
              badgeIcon: Icons.local_fire_department_rounded,
            ),
            _buildSection(
              title: "Perlu Ditingkatkan",
              subtitle: "Menu yang membutuhkan promo atau evaluasi",
              data: produkKurangDiminati,
              kategori: "Produk Kurang Diminati",
              badgeColor: const Color(0xFF8E44AD),
              badgeIcon: Icons.trending_down_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
