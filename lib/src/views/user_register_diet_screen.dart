import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'home_screen.dart';  // Asegúrate de importar la pantalla HomeScreen

class UserRegisterDietScreen extends StatefulWidget {
  const UserRegisterDietScreen({super.key});

  @override
  State<UserRegisterDietScreen> createState() => _UserRegisterDietScreenState();
}

class _UserRegisterDietScreenState extends State<UserRegisterDietScreen> {
  final List<String> _diets = [
    'Vegetariano',
    'Vegano',
    'Pescetariano',
    'Sin gluten',
    'Sin lácteos',
    'Keto',
    'Baja en carbohidratos',
    'Paleo',
    '¡Ninguna!',
  ];

  String? _selectedDiet;

  @override
  void initState() {
    super.initState();
    _selectedDiet = UserModel.instance.diet;
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Preferencias de Dieta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona tu tipo de dieta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              'Tipo de dieta:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _diets.map((diet) {
                  return RadioListTile<String>(
                    title: Text(diet),
                    value: diet,
                    groupValue: _selectedDiet,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedDiet = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDiet != null) {
                    // Actualiza el modelo de usuario
                    UserModel.update(
                      uid: UserModel.instance.uid,
                      email: UserModel.instance.email,
                      name: UserModel.instance.name,
                      photoUrl: UserModel.instance.photoUrl,
                      sex: UserModel.instance.sex,
                      weight: UserModel.instance.weight,
                      height: UserModel.instance.height,
                      diet: _selectedDiet,
                    );

                    // Guardar los datos en Firebase
                    userService.saveUser(UserModel.instance);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preferencias de dieta guardadas')),
                    );

                    // Navegar al HomeScreen sin botón de volver
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home', // Ruta de la pantalla de inicio
                      (route) => false, // Elimina todas las pantallas anteriores
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
