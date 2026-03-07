import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/activited/presentation/screens/activited_screen.dart';
import 'package:satoshimex/features/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 2; // Iniciamos en el Roadmap
  int previousIndex = 0;

  final List<Widget> screens = const [
    ActivitedScreen(key: ValueKey('activited')),
    WalletScreen(key: ValueKey('wallet')),
    RoadmapScreen(key: ValueKey('roadmap')),
    ChatbotScreen(key: ValueKey('chatbot')),
    ProfileScreen(key: ValueKey('profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final isForward = currentIndex > previousIndex;

          // Slide para entrada/salida
          final offsetAnimation = Tween<Offset>(
            begin: isForward ? const Offset(1, 0) : const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation);

          // Fade + slide
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: screens[currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.primaryAmber, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == currentIndex) return;
            setState(() {
              previousIndex = currentIndex;
              currentIndex = index;
            });
          },
          // Aplicamos el diseño circular mediante una función auxiliar
          items: [
            _buildNavItem(Icons.auto_graph_rounded, "Actividad", 0),
            _buildNavItem(Icons.account_balance_wallet_rounded, "Cartera", 1),
            _buildNavItem(Icons.map_rounded, "Roadmap", 2),
            _buildNavItem(Icons.forum_rounded, "ChatBot", 3),
            _buildNavItem(Icons.person_rounded, "Perfil", 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    bool isSelected = currentIndex == index;
    return BottomNavigationBarItem(
      label: label,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAmber : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : Colors.grey, // Cambia color si está seleccionado
        ),
      ),
    );
  }
}
