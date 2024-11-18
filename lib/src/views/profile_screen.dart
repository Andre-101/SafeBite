import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/change_diet.dart';
import '../viewmodels/change_health.dart';
import '../viewmodels/change_settings.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Usuario';
  // String photoUrl = 'https://via.placeholder.com/150';
  String gender = '♂';
  String height = 'No definido';
  String weight = 'No definido';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Usuario';
      // photoUrl = prefs.getString('photoUrl') ?? 'https://via.placeholder.com/150';
      gender = prefs.getString('gender') ?? '♂';
      height = prefs.getString('height') ?? 'No definido';
      weight = prefs.getString('weight') ?? 'No definido';
    });
  }

  Future<void> _updateProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('height', height);
    await prefs.setString('weight', weight);
    setState(() {});
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/Perfil_placeholder.jpg'), // Ruta de tu placeholder
                radius: 50,
              ),
            ),
            const SizedBox(height: 20),
            
            // Nombre de usuario y género
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  gender,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Datos de altura y peso
            Text('Altura: $height cm', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Peso: $weight kg', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            
            // Links para navegar a otras pantallas
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de editar información de salud (si ya está definida)
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditHealthInfoScreen()));
              },
              child: const Text(
                '¿Quieres cambiar tu información de salud?',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de editar preferencias de dieta (si ya está definida)
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditDietPreferencesScreen()));
              },
              child: const Text(
                '¿Quieres cambiar las preferencias de tu dieta?',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de configuración (si ya está definida)
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
              child: const Text(
                'Configuración',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
