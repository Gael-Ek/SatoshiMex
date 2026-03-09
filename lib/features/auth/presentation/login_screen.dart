import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/auth/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:satoshimex/features/profile/presentation/widgets/profile_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackBar('Por favor, llena todos los campos', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final token = await AuthService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      await appAuth.login(username);

      ref.read(onboardginShowProvider.notifier).completeOnboarding();

      context.go('/home');
    } else {
      _showSnackBar('Usuario o contraseña incorrectos', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : AppColors.slateBlueGray,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LogoBitcoin(),
                const SizedBox(height: 16),

                Text(
                  'SATOSHIMX',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryAmber,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Bienvenido de\nnuevo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Continúa tu viaje en el mundo de BitCoin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.slateBlueGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  'Nombre de usuario',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // ASIGNAMOS EL CONTROLADOR
                CustomTextField(
                  hintText: 'Nombre de usuario',
                  prefixIcon: Icons.person_outline,
                  controller: _usernameController,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contraseña',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: AppColors.primaryAmber,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                CustomTextField(
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                  suffixIcon: Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.slateBlueGray,
                  ),
                ),
                const SizedBox(height: 32),

                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAmber,
                        ),
                      )
                    : CustomButton(
                        text: 'Iniciar Sesión',
                        onPressed: _handleLogin,
                      ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(
                        color: AppColors.slateBlueGray,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/register');
                      },
                      child: Text(
                        'Regístrate gratis',
                        style: TextStyle(
                          color: AppColors.primaryAmber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
