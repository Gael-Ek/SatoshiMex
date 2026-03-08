import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder escucha los cambios de appAuth
    return ListenableBuilder(
      listenable: appAuth,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryAmber, width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.deepNavy,
                child: Icon(Icons.person, size: 60, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 16),
            // AQUÍ SE MUESTRA EL NOMBRE DINÁMICO
            // En ProfileHeader...
            Text(
              appAuth
                  .userName, // Esto llamará al getter que ya debería tener el nombre
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Aquí puedes mostrar un mensaje diferente si es invitado o usuario
            Text(
              appAuth.isLoggedIn ? "Bitcoin Enthusiast" : "Invitado",
              style: TextStyle(color: AppColors.primaryAmber, fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Logros de SatoshiMX",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () => print("Ver todos los logros"),
              child: Text(
                "Ver todos",
                style: TextStyle(color: AppColors.primaryAmber, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAchievement("Bitcoin Pioneer", Icons.emoji_events),
            _buildAchievement("Sats Stacker", Icons.storage),
            _buildAchievement("Node Runner", Icons.hub),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievement(String label, IconData icon) {
    return Container(
      width: 105,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryAmber, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildItem(Icons.person_outline, "Configuración de Perfil", () {}),
          _buildItem(Icons.lock_outline, "Privacidad", () {}),
          _buildItem(Icons.notifications_none, "Notificaciones", () {}),
          _buildItem(Icons.security, "Seguridad", () {}),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primaryAmber),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }
}

// Asegúrate de tener este import

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      // ListTile ya maneja el efecto visual y el tap, no necesitas InkWell extra
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
        onTap: () async {
          // El diálogo de confirmación
          final bool? confirmar = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.deepNavy,
              title: const Text(
                "Cerrar Sesión",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "¿Estás seguro de que deseas salir?",
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    "Salir",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          // Lógica de cierre: Aquí es donde conectas con tu estado de Auth
          if (confirmar == true) {
            await appAuth.logout();

            if (!context.mounted) return;
            context.go('/login');
          }
        },
      ),
    );
  }
}

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;

  AuthNotifier() {
    _loadAuthState(); // Cargar datos al crear la instancia
  }

  bool get isLoggedIn => _isLoggedIn;
  String get userName {
    if (_userName != null) return _userName!;
    return "Invitado";
  }

  // Cargar datos del disco
  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name');
    _isLoggedIn = _userName != null;
    notifyListeners();
  }

  Future<void> login(String name) async {
    // 1. Guardar en persistencia PRIMERO
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);

    // 2. Actualizar variables locales
    _userName = name;
    _isLoggedIn = true;

    // 3. Notificar a los widgets (como ProfileHeader)
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = null;

    // Borrar de persistencia
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');

    notifyListeners();
  }
}

// 1. Cambia el nombre de la instancia a algo distinto
final appAuth = AuthNotifier();

final GoRouter router = GoRouter(
  // 2. Usa ese nuevo nombre aquí
  refreshListenable: appAuth,
  redirect: (context, state) {
    // 3. Y úsalo también aquí
    final bool loggedIn = appAuth.isLoggedIn;
    final bool loggingIn = state.uri.path == '/login';

    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/home';

    return null;
  },
  routes: [
    // ... tus rutas
  ],
);
