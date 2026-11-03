import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LaporanHarianScreen extends StatefulWidget {
  const LaporanHarianScreen({super.key});

  @override
  State<LaporanHarianScreen> createState() => _LaporanHarianScreenState();
}

class _LaporanHarianScreenState extends State<LaporanHarianScreen> {
  List<Map<String, dynamic>> laporanHarian = [
    {"tanggal": "2025-05-20", "produk": "Green Tea", "jumlah": 5, "total": 50000},
    {"tanggal": "2025-05-20", "produk": "Teh Tarik", "jumlah": 3, "total": 36000},
    {"tanggal": "2025-05-20", "produk": "Churros", "jumlah": 4, "total": 60000},
    {"tanggal": "2025-05-20", "produk": "Nasi Bakar", "jumlah": 6, "total": 96000},
  ];

  String _formatCurrency(num amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  void _editItem(int index) {
    final item = laporanHarian[index];
    final produkController = TextEditingController(text: item['produk']);
    final jumlahController = TextEditingController(text: item['jumlah'].toString());
    final totalController = TextEditingController(text: item['total'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Edit Laporan Harian",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: produkController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jumlahController,
              decoration: const InputDecoration(labelText: "Jumlah Terjual"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: totalController,
              decoration: const InputDecoration(labelText: "Total Pendapatan (Rp)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF195C85),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                laporanHarian[index] = {
                  "tanggal": item['tanggal'],
                  "produk": produkController.text,
                  "jumlah": int.tryParse(jumlahController.text) ?? item['jumlah'],
                  "total": int.tryParse(totalController.text) ?? item['total'],
                };
              });
              Navigator.pop(context);
            },
            child: Text("Simpan", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _tambahItem() {
    final produkController = TextEditingController();
    final jumlahController = TextEditingController();
    final totalController = TextEditingController();
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Tambah Data Laporan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: produkController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jumlahController,
              decoration: const InputDecoration(labelText: "Jumlah Terjual"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: totalController,
              decoration: const InputDecoration(labelText: "Total Pendapatan (Rp)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF195C85),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (produkController.text.isNotEmpty) {
                setState(() {
                  laporanHarian.insert(0, {
                    "tanggal": now,
                    "produk": produkController.text,
                    "jumlah": int.tryParse(jumlahController.text) ?? 1,
                    "total": int.tryParse(totalController.text) ?? 0,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: Text("Tambah", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _hapusItem(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Konfirmasi Hapus", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Yakin ingin menghapus item laporan ini?", style: GoogleFonts.poppins()),
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
                laporanHarian.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Hapus", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF195C85);
    const primaryLightColor = Color(0xFF2C84B9);

    num totalPendapatan = laporanHarian.fold(0, (sum, item) => sum + (item['total'] as num));
    num totalTerjual = laporanHarian.fold(0, (sum, item) => sum + (item['jumlah'] as num));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text(
          'Laporan Penjualan Harian',
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: _tambahItem,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "Tambah Data",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Summary Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryLightColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TOTAL PENDAPATAN HARI INI",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(totalPendapatan),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "$totalTerjual",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Pcs Terjual",
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List Items
          Expanded(
            child: laporanHarian.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data penjualan hari ini",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: laporanHarian.length,
                    itemBuilder: (context, index) {
                      final item = laporanHarian[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE67E22).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.receipt_rounded,
                              color: Color(0xFFE67E22),
                            ),
                          ),
                          title: Text(
                            item['produk'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: const Color(0xFF2C3E50),
                            ),
                          ),
                          subtitle: Text(
                            "${item['tanggal']} • ${item['jumlah']} Porsi",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatCurrency(item['total']),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                color: Colors.blueGrey,
                                onPressed: () => _editItem(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                color: Colors.redAccent,
                                onPressed: () => _hapusItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
