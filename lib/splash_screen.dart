import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenOld extends StatefulWidget {
  const SplashScreenOld({super.key});

  @override
  State<SplashScreenOld> createState() => _SplashScreenOldState();
}

class _SplashScreenOldState extends State<SplashScreenOld> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 92, 133),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Wallpaper.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Waroeng Ngemil',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
