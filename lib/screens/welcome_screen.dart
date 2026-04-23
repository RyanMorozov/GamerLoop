// lib/screens/welcome_screen.dart
import 'dart:async'; // Timer için gerekli
import 'package:flutter/material.dart';
import 'package:gamerloop/constants/app_colors.dart';
import 'package:gamerloop/screens/login_screen.dart'; // Yönlendirme için ekledik
import 'package:gamerloop/widgets/background_wrapper.dart';

// Zamanlayıcı kullanacağımız için StatefulWidget'a çevirdik
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();

    // 3 saniye sonra Login ekranına geçiş yapacak zamanlayıcı
    Timer(const Duration(seconds: 3), () {
      // pushReplacement kullanıyoruz çünkü geri tuşuna basınca tekrar buraya dönmesin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        // Buraya imageUrl: "..." ekleyerek CMS simülasyonu yapabilirsin
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Belki üstte küçük bir logo taslağı
              Icon(Icons.sports_esports, size: 64, color: AppColors.accent),
              const SizedBox(height: 20),

              // Küçültülmüş Hoşgeldin Yazısı
              Text(
                'HOŞGELDİN',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 24, // 42'den 24'e düşürdük
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4, // Harf arası boşluğu da biraz azalttık
                  shadows: [
                    Shadow(
                      blurRadius: 15.0,
                      color: AppColors.accent.withOpacity(0.5),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Oyuncu Dünyasına Giriş Yapılıyor...',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}