import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importa el paquete image_picker
import 'dart:io'; // Para trabajar con imágenes de archivos
import '../models/user_model.dart'; // Asegúrate de importar el modelo de usuario
import '../views/user_register_diet_screen.dart'; // Asegúrate de importar la pantalla de registro de dieta

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _sex;
  late double _weight;
  late double _height;
  File? _image; // Variable para almacenar la imagen seleccionada

  final ImagePicker _picker = ImagePicker(); // Instancia de ImagePicker

  @override
  void initState() {
    super.initState();
    // Inicializa los valores con la información del UserModel
    _sex = UserModel.instance.sex ?? '';
    _weight = UserModel.instance.weight ?? 0;
    _height = UserModel.instance.height ?? 0;
  }

  // Función para seleccionar o tomar una foto
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información del Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto de perfil
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Permite seleccionar o tomar una foto al hacer clic
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image == null
                        ? NetworkImage(UserModel.instance.photoUrl ?? 'https://via.placeholder.com/150')
                        : FileImage(_image!) as ImageProvider, // Muestra la imagen seleccionada o la predeterminada
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo para el sexo (con un Dropdown para evitar que el usuario escriba)
              DropdownButtonFormField<String>(
                value: _sex.isEmpty ? null : _sex, // Si no hay valor, no seleccionamos nada por defecto
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const [
                  DropdownMenuItem(
                    value: 'Masculino',
                    child: Text('Masculino'),
                  ),
                  DropdownMenuItem(
                    value: 'Femenino',
                    child: Text('Femenino'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _sex = value ?? ''; // Actualiza el sexo con la opción seleccionada
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona tu sexo';
                  }
                  return null;
                },
              ),
              // Campo para el peso
              TextFormField(
                initialValue: _weight.toString(),
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu peso';
                  }
                  double? parsedWeight = double.tryParse(value);
                  if (parsedWeight == null || parsedWeight < 10 || parsedWeight > 200) {
                    return 'El peso debe estar entre 10 y 200 kg';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _weight = double.tryParse(value) ?? 0;
                  });
                },
              ),
              // Campo para la altura
              TextFormField(
                initialValue: _height.toString(),
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu altura';
                  }
                  double? parsedHeight = double.tryParse(value);
                  if (parsedHeight == null || parsedHeight < 10 || parsedHeight > 200) {
                    return 'La altura debe estar entre 10 y 200 cm';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _height = double.tryParse(value) ?? 0;
                  });
                },
              ),
              // Botón para guardar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Crea o actualiza el objeto de usuario con los datos nuevos
                      UserModel.update(
                        uid: UserModel.instance.uid,
                        email: UserModel.instance.email,
                        name: UserModel.instance.name,
                        photoUrl: _image?.path ?? UserModel.instance.photoUrl, // Usar la nueva foto si se seleccionó
                        sex: _sex,
                        weight: _weight,
                        height: _height,
                      );

                      // Navega a la siguiente pantalla o muestra un mensaje de éxito
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserRegisterDietScreen()),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
