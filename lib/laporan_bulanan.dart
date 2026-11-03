import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LaporanBulananScreen extends StatefulWidget {
  const LaporanBulananScreen({super.key});

  @override
  State<LaporanBulananScreen> createState() => _LaporanBulananScreenState();
}

class _LaporanBulananScreenState extends State<LaporanBulananScreen> {
  List<Map<String, dynamic>> laporanBulanan = [
    {"bulan": "April 2025", "produk": "Green Tea", "jumlah": 80, "total": 800000},
    {"bulan": "April 2025", "produk": "Churros", "jumlah": 60, "total": 900000},
    {"bulan": "April 2025", "produk": "Blue Soda", "jumlah": 45, "total": 900000},
    {"bulan": "Mei 2025", "produk": "Nasi Bakar", "jumlah": 95, "total": 1520000},
  ];

  String _formatCurrency(num amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  void _editItem(int index) {
    final item = laporanBulanan[index];
    final produkController = TextEditingController(text: item['produk']);
    final jumlahController = TextEditingController(text: item['jumlah'].toString());
    final totalController = TextEditingController(text: item['total'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Edit Laporan Bulanan",
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
              decoration: const InputDecoration(labelText: "Jumlah Penjualan"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: totalController,
              decoration: const InputDecoration(labelText: "Total Omset (Rp)"),
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
                laporanBulanan[index] = {
                  "bulan": item['bulan'],
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

  void _hapusItem(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Konfirmasi Hapus", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Yakin ingin menghapus rekap bulanan ini?", style: GoogleFonts.poppins()),
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
                laporanBulanan.removeAt(index);
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

    num totalPendapatan = laporanBulanan.fold(0, (sum, item) => sum + (item['total'] as num));
    num totalTerjual = laporanBulanan.fold(0, (sum, item) => sum + (item['jumlah'] as num));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text(
          'Laporan Penjualan Bulanan',
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
      body: Column(
        children: [
          // Summary Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B6B40), Color(0xFF27AE60)],
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
                        "TOTAL REKAP OMSET BULANAN",
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
                        "Produk",
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
            child: laporanBulanan.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data laporan bulanan",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: laporanBulanan.length,
                    itemBuilder: (context, index) {
                      final item = laporanBulanan[index];
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
                              color: const Color(0xFF27AE60).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: Color(0xFF27AE60),
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
                            "Periode: ${item['bulan']} • ${item['jumlah']} Terjual",
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
                                  color: const Color(0xFF1B6B40),
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
