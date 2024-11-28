import 'package:flutter/material.dart';
import '../models/user_model.dart';  // Asegúrate de importar el modelo de usuario
import '../services/user_service.dart';  // Asegúrate de importar el servicio de usuario

class EditDietPreferencesScreen extends StatefulWidget {
  const EditDietPreferencesScreen({super.key});

  @override
  State<EditDietPreferencesScreen> createState() => _EditDietPreferencesScreenState();
}

class _EditDietPreferencesScreenState extends State<EditDietPreferencesScreen> {
  // Lista de dietas
  final List<String> _diets = [
    'Vegetariano',
    'Vegano',
    'Pescetariano',
    'Sin gluten',
    'Sin lácteos',
    'Keto',
    'Baja en carbohidratos',
    'Paleo',
  ];

  // Map para manejar el estado de cada checkbox (si está seleccionado o no)
  Map<String, bool> _selectedDiets = {};

  @override
  void initState() {
    super.initState();
    // Inicializamos los valores de los checkboxes a false (no seleccionados)
    _selectedDiets = {for (var diet in _diets) diet: false};

    // Recuperar la dieta preferida actual del usuario
    // Asumimos que el `UserModel.instance.diet` es un String o una lista de dietas
    if (UserModel.instance.diet != null) {
      // Si la dieta es un solo valor, lo marcamos como seleccionado
      if (_diets.contains(UserModel.instance.diet)) {
        _selectedDiets[UserModel.instance.diet!] = true;
      }
      // Si la dieta es una lista (en el caso de dietas múltiples), marcamos las opciones correspondientes
      else if (UserModel.instance.diet is List<String>) {
        for (var diet in UserModel.instance.diet as List<String>) {
          _selectedDiets[diet] = true;
        }
      }
    }
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
            // Título de la pantalla
            const Text(
              'Edita tus preferencias de dieta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Lista de dietas con checkboxes
            const Text(
              'Preferencias dietéticas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _diets.map((diet) {
                  return CheckboxListTile(
                    title: Text(diet),
                    value: _selectedDiets[diet] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedDiets[diet] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 40),

            // Botón para guardar las preferencias
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Recoger la primera dieta seleccionada
                  String? selectedDiet = _diets.firstWhere(
                          (diet) => _selectedDiets[diet] == true,
                      orElse: () => ''
                  );  // Obtener la primera dieta seleccionada

                  // Actualizar el modelo de usuario
                  UserModel.update(
                    uid: UserModel.instance.uid,
                    email: UserModel.instance.email,
                    name: UserModel.instance.name,
                    photoUrl: UserModel.instance.photoUrl,
                    sex: UserModel.instance.sex,
                    weight: UserModel.instance.weight,
                    height: UserModel.instance.height,
                    diet: selectedDiet.isEmpty ? null : selectedDiet,  // Solo guardar una dieta
                  );

                  // Guardar los datos en Firebase o cualquier otro servicio
                  userService.saveUser(UserModel.instance);

                  // Mostrar mensaje de confirmación
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preferencias de dieta guardadas')),
                  );

                  // Navegar a la pantalla anterior o home
                  Navigator.pop(context);
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
