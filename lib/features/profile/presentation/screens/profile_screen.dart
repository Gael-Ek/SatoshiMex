import 'package:flutter/material.dart';
import 'package:satoshimex/features/profile/presentation/widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: const [
            ProfileHeader(),
            SizedBox(height: 32),
            AchievementSection(),
            SizedBox(height: 32),
            SettingsSection(),
            SizedBox(height: 24),
            LogoutTile(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text("Perfil", style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
