import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    value: _selectedDiets[diet],
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
                  // Aquí puedes agregar la lógica para guardar las preferencias dietéticas
                  // Por ejemplo, en SharedPreferences o en una base de datos

                  // Mostrar mensaje de confirmación
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preferencias de dieta guardadas')),
                  );
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