import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/change_diet.dart';
import '../viewmodels/change_health.dart';
import '../viewmodels/change_settings.dart';
import '../services/user_service.dart';


class ProfileScreen extends StatefulWidget {
  final String userUid;

  const ProfileScreen({super.key, required this.userUid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserService _userService;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userService = UserService(context);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await _userService.getUserData(widget.userUid);
      if (data != null) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró información del usuario.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos del usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Perfil'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text('No se pudo cargar la información del usuario.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData?['photoUrl'] ?? 'https://via.placeholder.com/150'),
                radius: 50,
              ),
            ),
            const SizedBox(height: 20),

            // Nombre de usuario y género
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userData?['name'] ?? 'Usuario',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Icon(
                  userData?['sex'] == 'Femenino' ? Icons.female : Icons.male,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Datos de altura y peso
            Text('Altura: ${userData?['height'] ?? 'No definido'} cm', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Peso: ${userData?['weight'] ?? 'No definido'} kg', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            // Mostrar dieta
            Text('Dieta: ${userData?['diet'] ?? 'No definida'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // Botones para cambiar información
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de editar información de salud
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditHealthInfoScreen()));
              },
              child: const Text(
                '¿Quieres cambiar tu información de salud?',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de editar preferencias de dieta
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditDietPreferencesScreen()));
              },
              child: const Text(
                '¿Quieres cambiar las preferencias de tu dieta?',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de configuración
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
