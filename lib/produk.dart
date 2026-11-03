import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/cart.dart';
import 'package:tugas_akhir/login.dart';
import 'package:tugas_akhir/kasir.dart';
import 'package:tugas_akhir/laporan_harian.dart';
import 'package:tugas_akhir/laporan_bulanan.dart';
import 'package:tugas_akhir/laporan_produk.dart';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({super.key});

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  final List<Map<String, dynamic>> allProducts = [
    {"name": "Green Tea", "harga": 10000.0, "image": "assets/1.jpg", "category": "Minuman"},
    {"name": "Es Teh", "harga": 5000.0, "image": "assets/2.jpg", "category": "Minuman"},
    {"name": "Blue Soda", "harga": 20000.0, "image": "assets/3.jpg", "category": "Minuman"},
    {"name": "Teh Tarik", "harga": 12000.0, "image": "assets/4.jpg", "category": "Minuman"},
    {"name": "Churros", "harga": 15000.0, "image": "assets/5.jpg", "category": "Makanan"},
    {"name": "Onion Rings", "harga": 12000.0, "image": "assets/6.jpg", "category": "Makanan"},
    {"name": "Nasi Bakar", "harga": 16000.0, "image": "assets/7.jpg", "category": "Makanan"},
    {"name": "Pecel Ayam", "harga": 16000.0, "image": "assets/8.jpg", "category": "Makanan"},
  ];

  final List<Map<String, dynamic>> cart = [];
  String searchQuery = "";
  String selectedCategory = "Semua";

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final index = cart.indexWhere((item) => item['name'] == product['name']);
      if (index == -1) {
        cart.add({...product, "quantity": 1});
      } else {
        cart[index]["quantity"]++;
      }
    });
  }

  void _removeFromCart(Map<String, dynamic> product) {
    setState(() {
      final index = cart.indexWhere((item) => item['name'] == product['name']);
      if (index != -1) {
        if (cart[index]["quantity"] > 1) {
          cart[index]["quantity"]--;
        } else {
          cart.removeAt(index);
        }
      }
    });
  }

  int _getProductQuantity(Map<String, dynamic> product) {
    final index = cart.indexWhere((item) => item['name'] == product['name']);
    return index != -1 ? cart[index]["quantity"] : 0;
  }

  double _calculateTotalCartPrice() {
    return cart.fold(
      0.0,
      (sum, item) => sum + ((item["harga"] as double) * (item["quantity"] as int)),
    );
  }

  int _calculateTotalCartCount() {
    return cart.fold(
      0,
      (sum, item) => sum + (item["quantity"] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF195C85);
    const primaryLightColor = Color(0xFF2C84B9);

    final filteredProducts = allProducts.where((p) {
      final matchesSearch =
          p['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == "Semua" ||
          p['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final totalCount = _calculateTotalCartCount();
    final totalPrice = _calculateTotalCartPrice();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Menu Kasir",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const KasirScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
          // Cart Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cart: cart,
                        formatCurrency: formatCurrency,
                      ),
                    ),
                  );
                },
              ),
              if (totalCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$totalCount',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Search & Category Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Search Input
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Cari produk / minuman / makanan...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, color: primaryColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Chips
                Row(
                  children: ["Semua", "Minuman", "Makanan"].map((cat) {
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.poppins(
                              color: isSelected ? primaryColor : Colors.white,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Product List View
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fastfood_outlined,
                            size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          "Tidak ada produk ditemukan",
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final qty = _getProductQuantity(product);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Product Image (Preserving existing assets 1.jpg - 8.jpg)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  product["image"],
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 72,
                                    height: 72,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Name & Price
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product["name"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2C3E50),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatCurrency(product["harga"]),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Modern Quantity Stepper
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F7F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_rounded, size: 18),
                                      color: qty > 0 ? primaryColor : Colors.grey.shade400,
                                      onPressed: qty > 0 ? () => _removeFromCart(product) : null,
                                      padding: const EdgeInsets.all(6),
                                      constraints: const BoxConstraints(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text(
                                        '$qty',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: qty > 0 ? primaryColor : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_rounded, size: 18),
                                      color: primaryColor,
                                      onPressed: () {
                                        _addToCart(product);
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "${product['name']} ditambahkan ke keranjang",
                                              style: GoogleFonts.poppins(fontSize: 12),
                                            ),
                                            duration: const Duration(milliseconds: 900),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: primaryColor,
                                          ),
                                        );
                                      },
                                      padding: const EdgeInsets.all(6),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
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

      // Bottom Bar with Checkout Button & Quick Reports
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Checkout Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [primaryLightColor, primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cart: cart,
                            formatCurrency: formatCurrency,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
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
                              '$totalCount item',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            formatCurrency(totalPrice),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Buka Keranjang',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Quick Laporan Shortcuts
              Row(
                children: [
                  _buildQuickLaporanButton(
                    context,
                    label: "Harian",
                    icon: Icons.today_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LaporanHarianScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickLaporanButton(
                    context,
                    label: "Bulanan",
                    icon: Icons.calendar_month_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LaporanBulananScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickLaporanButton(
                    context,
                    label: "Produk",
                    icon: Icons.inventory_2_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LaporanProdukScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildQuickLaporanButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: const Color(0xFF195C85)),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF195C85),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: const Color(0xFF195C85).withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
