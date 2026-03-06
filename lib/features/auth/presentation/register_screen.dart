import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart'; // Asegúrate de que aquí estén tus widgets personalizados

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      // 1. APPBAR PARA EL BOTÓN DE REGRESAR Y TÍTULO
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Regresa a la pantalla anterior (Login)
            Navigator.pop(context);
          },
        ),
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
            // Reduje un poco el padding superior vertical porque el AppBar ya da espacio
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- LOGO BITCOIN ---
                const LogoBitcoin(),
                const SizedBox(height: 16),

                // --- TÍTULO PRINCIPAL ---
                Text(
                  'SatoshiMX',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // --- SUBTÍTULO ---
                Text(
                  'Aprende sobre Bitcoin y más',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.slateBlueGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Nombre completo',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const CustomTextField(
                  hintText: 'Tu nombre',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

                // --- CAMPO 2: NOMBRE DE USUARIO ---
                Text(
                  'Nombre de usuario',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const CustomTextField(
                  hintText: 'Tu nombre de usuario',
                  prefixIcon: Icons.account_circle_outlined,
                ),
                const SizedBox(height: 20),

                // --- CAMPO 3: CONTRASEÑA ---
                Text(
                  'Contraseña',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Crea una contraseña',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  suffixIcon: Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.slateBlueGray,
                  ),
                ),
                const SizedBox(height: 32),

                // --- BOTÓN REGISTRARSE ---
                CustomButton(
                  text: 'Registrarse',
                  onPressed: () {
                    // Acción para crear la cuenta
                    print("Botón de registro presionado");
                  },
                ),
                const SizedBox(height: 24),

                // --- TEXTO FINAL: INICIA SESIÓN ---
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
                      onTap: () {
                        // Regresa al login
                        Navigator.pop(context);
                      },
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
