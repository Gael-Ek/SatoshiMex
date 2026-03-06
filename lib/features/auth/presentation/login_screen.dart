import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. FONDO DE LA PANTALLA
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
                // --- LOGO BITCOIN ---
                const LogoBitcoin(),
                const SizedBox(height: 16),

                // --- TEXTO: SATOSHIMX ---
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

                // --- TÍTULO PRINCIPAL ---
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

                // --- SUBTÍTULO ---
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

                // --- TU WIDGET: CAMPO DE USUARIO ---
                const CustomTextField(
                  hintText: 'Nombre de usuario',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 24),

                // --- ETIQUETAS: CONTRASEÑA Y OLVIDÓ CONTRASEÑA ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contraseña',
                      style: TextStyle(
                        color: AppColors.white, // Color blanco
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Acción para recuperar contraseña
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: AppColors.primaryAmber, // Color naranja/dorado
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // --- TU WIDGET: CAMPO DE CONTRASEÑA ---
                CustomTextField(
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  suffixIcon: Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.slateBlueGray,
                  ),
                ),
                const SizedBox(height: 32),

                // --- TU WIDGET: BOTÓN DE INICIAR SESIÓN ---
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: () {
                    print("Botón presionado");
                  },
                ),
                const SizedBox(height: 24),

                // --- TEXTO FINAL: REGÍSTRATE ---
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
                        // Navegar a la pantalla de registro
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
