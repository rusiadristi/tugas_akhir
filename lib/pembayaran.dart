import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tugas_akhir/produk.dart';

class PembayaranScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final String Function(double) formatCurrency;

  const PembayaranScreen({
    super.key,
    required this.cart,
    required this.formatCurrency,
  });

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final TextEditingController _uangDiterimaController = TextEditingController();
  final TextEditingController _kodeBayarController = TextEditingController();
  String _selectedPaymentMethod = "Tunai";
  double _uangDiterima = 0.0;
  double _total = 0.0;
  double _kembalian = 0.0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _total = widget.cart.fold(
      0.0,
      (sum, item) => sum + (item["harga"] * item["quantity"]),
    );
  }

  void _hitungKembalian() {
    setState(() {
      _uangDiterima = double.tryParse(_uangDiterimaController.text) ?? 0.0;
      _kembalian = _uangDiterima - _total;
    });
  }

  void _setQuickCash(double amount) {
    setState(() {
      _uangDiterima = amount;
      _uangDiterimaController.text = amount.toInt().toString();
      _kembalian = _uangDiterima - _total;
    });
  }

  bool _isButtonEnabled() {
    if (_selectedPaymentMethod == "Tunai") {
      return _uangDiterima >= _total;
    } else if (_selectedPaymentMethod == "Kartu") {
      return _kodeBayarController.text.trim().isNotEmpty;
    }
    return false;
  }

  String _generateReceipt() {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'id_ID');
    final dateNow = dateFormat.format(DateTime.now());
    final transactionId = 'TRX-${DateTime.now().millisecondsSinceEpoch}';

    String itemDetails = widget.cart.map((item) {
      if (item.containsKey('nama') &&
          item.containsKey('quantity') &&
          item.containsKey('harga')) {
        final subtotal = item['harga'].toDouble() * item['quantity'];
        return "${item['nama']}\n  ${item['quantity']} × ${widget.formatCurrency(item['harga'].toDouble())} = ${widget.formatCurrency(subtotal)}";
      }
      return "";
    }).join("\n");

    return """
=================================
          WAROENG NGEMIL
   Sistem Kasir & Point of Sale
       No HP: 0812-3456-7890
=================================
No. Trx : $transactionId
Waktu   : $dateNow
Kasir   : Admin
Metode  : $_selectedPaymentMethod
---------------------------------
$itemDetails
---------------------------------
TOTAL BELANJA : ${widget.formatCurrency(_total)}
${_selectedPaymentMethod == 'Tunai' ? "DIBAYAR (TUNAI): ${widget.formatCurrency(_uangDiterima)}\nKEMBALIAN      : ${widget.formatCurrency(_kembalian)}" : "KODE TRANSAKSI : ${_kodeBayarController.text}"}
=================================
  Terima Kasih Atas Kunjungan Anda!
      Selamat Menikmati Hidangan
=================================""";
  }

  @override
  void dispose() {
    _uangDiterimaController.dispose();
    _kodeBayarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF195C85);
    const primaryLightColor = Color(0xFF2C84B9);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Proses Pembayaran",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Tagihan Card
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, primaryLightColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL TAGIHAN",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${widget.cart.length} Item",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.formatCurrency(_total),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Metode Pembayaran Selector
            Text(
              "Metode Pembayaran",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMethodOption(
                    title: "Tunai (Cash)",
                    icon: Icons.payments_rounded,
                    isSelected: _selectedPaymentMethod == "Tunai",
                    onTap: () => setState(() => _selectedPaymentMethod = "Tunai"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMethodOption(
                    title: "Non-Tunai / Kartu",
                    icon: Icons.credit_card_rounded,
                    isSelected: _selectedPaymentMethod == "Kartu",
                    onTap: () => setState(() => _selectedPaymentMethod = "Kartu"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Conditional Content for Tunai
            if (_selectedPaymentMethod == "Tunai") ...[
              Text(
                "Nominal Uang Diterima",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _uangDiterimaController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  prefixStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onChanged: (value) => _hitungKembalian(),
              ),

              const SizedBox(height: 12),

              // Quick Cash Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickCashChip("Uang Pas", _total),
                  _buildQuickCashChip("Rp 20.000", 20000),
                  _buildQuickCashChip("Rp 50.000", 50000),
                  _buildQuickCashChip("Rp 100.000", 100000),
                ],
              ),

              const SizedBox(height: 20),

              // Kembalian Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _uangDiterima == 0
                      ? Colors.white
                      : (_kembalian >= 0
                          ? Colors.green.shade50
                          : Colors.red.shade50),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _uangDiterima == 0
                        ? Colors.grey.shade300
                        : (_kembalian >= 0
                            ? Colors.green.shade300
                            : Colors.red.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _kembalian >= 0
                              ? Icons.check_circle_outline_rounded
                              : Icons.warning_amber_rounded,
                          color: _kembalian >= 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Kembalian",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _kembalian >= 0
                          ? widget.formatCurrency(_kembalian)
                          : "Uang Kurang ${widget.formatCurrency((_kembalian).abs())}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _kembalian >= 0 ? Colors.green.shade800 : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Conditional Content for Kartu
            if (_selectedPaymentMethod == "Kartu") ...[
              Text(
                "Nomor Kartu / Referensi / Kode Bayar",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _kodeBayarController,
                style: GoogleFonts.poppins(fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Contoh: REF-123456 atau 4 Digit Akhir Kartu",
                  prefixIcon: const Icon(Icons.qr_code_rounded, color: primaryColor),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ],

            const SizedBox(height: 36),

            // Selesaikan Pembayaran Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: _isButtonEnabled()
                    ? const LinearGradient(
                        colors: [primaryLightColor, primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _isButtonEnabled() ? null : Colors.grey.shade300,
                boxShadow: _isButtonEnabled()
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: _isButtonEnabled() ? _processSuccessPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.print_rounded,
                      color: _isButtonEnabled() ? Colors.white : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Proses & Cetak Struk",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isButtonEnabled() ? Colors.white : Colors.grey.shade500,
                      ),
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

  Widget _buildMethodOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF195C85);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? primaryColor : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCashChip(String label, double amount) {
    return ActionChip(
      label: Text(label),
      labelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF195C85),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: () => _setQuickCash(amount),
    );
  }

  void _processSuccessPayment() {
    final receipt = _generateReceipt();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: Color(0xFF195C85)),
              const SizedBox(width: 8),
              Text(
                'Struk Transaksi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                receipt,
                style: GoogleFonts.sourceCodePro(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdukScreen()),
                  (route) => false,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Pembayaran Berhasil via $_selectedPaymentMethod!",
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: const Color(0xFF195C85),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF195C85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Selesai & Transaksi Baru',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
