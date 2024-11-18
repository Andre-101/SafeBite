import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditHealthInfoScreen extends StatefulWidget {
  const EditHealthInfoScreen({super.key});

  @override
  State<EditHealthInfoScreen> createState() => _EditHealthInfoScreenState();
}

class _EditHealthInfoScreenState extends State<EditHealthInfoScreen> {
  // Variables para almacenar los datos
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Lista de condiciones de salud con su estado (si está seleccionada o no)
  final List<String> _conditions = [
    'Diabetes',
    'Presión sanguínea alta',
    'Sensibilidad al gluten',
    'Intolerante a la lactosa',
    'Alergia al maní',
    'Alergia a frutos secos',
    'Alergia al huevo',
    'Alergia a la soya',
  ];

  // Map para manejar el estado de cada checkbox (si está seleccionado o no)
  Map<String, bool> _selectedConditions = {};

  // Variables para manejar el estado de los errores
  String? _heightError;
  String? _weightError;

  // Función para verificar si el valor ingresado es válido
  bool isValidHeight(String value) {
    final height = int.tryParse(value);
    if (height != null && height >= 40 && height <= 300) {
      setState(() {
        _heightError = null; // No hay error
      });
      return true;
    } else {
      setState(() {
        _heightError = 'Por favor, ingresa una altura válida (40-300 cm).';
      });
      return false;
    }
  }

  bool isValidWeight(String value) {
    final weight = int.tryParse(value);
    if (weight != null && weight >= 1 && weight <= 300) {
      setState(() {
        _weightError = null; // No hay error
      });
      return true;
    } else {
      setState(() {
        _weightError = 'Por favor, ingresa un peso válido (1-300 kg).';
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializamos los valores de los checkboxes a false (no seleccionados)
    _selectedConditions = {for (var condition in _conditions) condition: false};
  }

  @override
  void dispose() {
    // Liberar los controladores cuando ya no se usen
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Información de Salud'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la pantalla
            const Text(
              'Edita tu información de salud',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Campo para editar altura
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Solo números
              ],
              decoration: InputDecoration(
                labelText: 'Altura',
                suffixText: 'cm',
                border: OutlineInputBorder(),
                errorText: _heightError, // Mostrar el error si existe
              ),
              onChanged: (value) {
                isValidHeight(value); // Validar la altura en tiempo real
              },
            ),
            const SizedBox(height: 20),

            // Campo para editar peso
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Solo números
              ],
              decoration: InputDecoration(
                labelText: 'Peso',
                suffixText: 'kg',
                border: OutlineInputBorder(),
                errorText: _weightError, // Mostrar el error si existe
              ),
              onChanged: (value) {
                isValidWeight(value); // Validar el peso en tiempo real
              },
            ),
            const SizedBox(height: 20),

            // Lista de condiciones de salud con checkboxes
            const Text(
              'Condiciones de salud:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _conditions.map((condition) {
                  return CheckboxListTile(
                    title: Text(condition),
                    value: _selectedConditions[condition],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedConditions[condition] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 40),

            // Botón para guardar la información
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final String height = _heightController.text;
                  final String weight = _weightController.text;

                  // Validación para asegurarse de que los campos no estén vacíos y sean válidos
                  if (height.isNotEmpty && weight.isNotEmpty && isValidHeight(height) && isValidWeight(weight)) {
                    // Aquí podrías agregar la lógica para guardar la información, por ejemplo:
                    // - Guardar la información en una base de datos
                    // - Guardar en SharedPreferences o cualquier otro almacenamiento persistente

                    // Mostrar mensaje de confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Información de salud guardada')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor completa todos los campos')),
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
