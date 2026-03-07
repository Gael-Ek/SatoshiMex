import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/auth/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/features/onboarding/presentation/providers/onboarding_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. LA FUNCIÓN QUE SE EJECUTA AL PRESIONAR EL BOTÓN
  Future<void> _handleRegister() async {
    // Validamos que los campos no estén vacíos
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    // Activamos el estado de carga
    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.register(
      _nameController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    // 5. Procesar respuesta
    if (result == true) {
      ref.read(onboardginShowProvider.notifier).completeOnboarding();
      context.go('/home');
    } else {
      // Error: Mostrar mensaje del backend
      _showSnackBar('Error al registrarse', isError: true);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Crea tu cuenta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LogoBitcoin(),
                const SizedBox(height: 16),
                const Text(
                  'SatoshiMX',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aprende sobre Bitcoin y más',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.slateBlueGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),

                // --- CAMPO 1 ---
                const Text(
                  'Nombre completo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Tu nombre',
                  prefixIcon: Icons.person_outline,
                  controller: _nameController, // <-- ASIGNAMOS EL CONTROLADOR
                ),
                const SizedBox(height: 20),

                // --- CAMPO 2 ---
                const Text(
                  'Nombre de usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Tu nombre de usuario',
                  prefixIcon: Icons.account_circle_outlined,
                  controller:
                      _usernameController, // <-- ASIGNAMOS EL CONTROLADOR
                ),
                const SizedBox(height: 20),

                // --- CAMPO 3 ---
                const Text(
                  'Contraseña',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Crea una contraseña',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller:
                      _passwordController, // <-- ASIGNAMOS EL CONTROLADOR
                  suffixIcon: Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.slateBlueGray,
                  ),
                ),
                const SizedBox(height: 32),

                // --- BOTÓN REGISTRARSE ---
                // Si está cargando, mostramos un CircularProgressIndicator, si no, el botón normal
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAmber,
                        ),
                      )
                    : CustomButton(
                        text: 'Registrarse',
                        onPressed:
                            _handleRegister, // <-- LLAMAMOS A LA FUNCIÓN AL PRESIONAR
                      ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes una cuenta? ',
                      style: TextStyle(
                        color: AppColors.slateBlueGray,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/login'),
                      child: Text(
                        'Inicia sesión',
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
