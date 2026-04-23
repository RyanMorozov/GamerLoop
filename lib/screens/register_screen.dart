import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gamerloop/app/session_manager.dart';
import 'package:gamerloop/constants/app_colors.dart';
import 'package:gamerloop/widgets/background_wrapper.dart';
import 'package:gamerloop/widgets/terms_consent_row.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _termsAccepted = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Future<void> _createAccount() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Devam etmek için kullanım koşullarını onayla.')),
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreler eşleşmiyor.')),
      );
      return;
    }

    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    await SessionManager.signIn(
      firstName: _nameController.text.trim().isEmpty
          ? 'Oyuncu'
          : _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kayıt başarılı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: -40,
              child: _GlowOrb(
                size: 230,
                color: AppColors.accent.withOpacity(0.20),
              ),
            ),
            Positioned(
              bottom: -70,
              right: -30,
              child: _GlowOrb(
                size: 270,
                color: Colors.blueAccent.withOpacity(0.15),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yeni hesabını oluştur ve topluluğa katıl.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _GlassPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kullanıcı adı',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'oyuncu_adin',
                              icon: Icons.person_outline_rounded,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Soyad',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _lastNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'soyadin',
                              icon: Icons.badge_outlined,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'E-posta',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                              hint: 'ornek@site.com',
                              icon: Icons.alternate_email_rounded,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Şifre',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Şifre Tekrar',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _confirmController,
                            obscureText: _obscureConfirm,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: '••••••••',
                              icon: Icons.verified_user_outlined,
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TermsConsentRow(
                            accepted: _termsAccepted,
                            onChanged: (bool accepted) {
                              setState(() => _termsAccepted = accepted);
                            },
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: _NeoActionButton(
                              text: 'Hesap Oluştur',
                              isLoading: _loading,
                              onPressed: _createAccount,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Zaten hesabım var, girişe dön',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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

class _GlassPanel extends StatelessWidget {
  final Widget child;

  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _NeoActionButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final bool isLoading;

  const _NeoActionButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  State<_NeoActionButton> createState() => _NeoActionButtonState();
}

class _NeoActionButtonState extends State<_NeoActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapCancel: widget.isLoading ? null : () => setState(() => _pressed = false),
      onTapUp: widget.isLoading
          ? null
          : (_) async {
              setState(() => _pressed = false);
              await widget.onPressed();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF00D88E), Color(0xFF00B7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: widget.isLoading ? 30 : (_pressed ? 10 : 22),
              spreadRadius: widget.isLoading ? 2 : (_pressed ? 0 : 1),
              offset: const Offset(0, 10),
              color: const Color(0xFF00D88E).withOpacity(
                widget.isLoading ? 0.55 : (_pressed ? 0.25 : 0.42),
              ),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: widget.isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.text,
                    key: const ValueKey('text'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
