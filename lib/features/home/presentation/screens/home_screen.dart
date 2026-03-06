import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  int previousIndex = 0;

  final List<Widget> screens = const [
    RoadmapScreen(key: ValueKey('roadmap')),
    ChatbotScreen(key: ValueKey('chatbot')),
    WalletScreen(key: ValueKey('wallet')),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: AppColors.primaryAmber,
            height: 0,
            thickness: 0.5,
          ),
          BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              if (index == currentIndex) return;
              setState(() {
                previousIndex = currentIndex;
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.chat_bubble_outline),
                label: "ChatBot",
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.wallet_sharp),
                label: "Cartera",
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
