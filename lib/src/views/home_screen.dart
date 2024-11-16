import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = '';
  String userName = '';
  String? photoUrl;

  double dailyCalories = 0;
  double dailySugar = 0;
  double dailySodium = 0;


  @override
 void initState() {
    super.initState();
    _loadUsername();
    _loadUserProfile();
    _loadDailyProgress(); // Cargar el progreso del día
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Usuario';
    });
  }

  void _loadUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    photoUrl = prefs.getString('photoUrl') ?? 'https://via.placeholder.com/150';
  });
}

Future<void> _loadDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyCalories = prefs.getDouble('dailyCalories') ?? 0;
      dailySugar = prefs.getDouble('dailySugar') ?? 0;
      dailySodium = prefs.getDouble('dailySodium') ?? 0;
    });
  }

  Future<void> _updateDailyProgress(double calories, double sugar, double sodium) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyCalories = calories;
      dailySugar = sugar;
      dailySodium = sodium;
    });

    prefs.setDouble('dailyCalories', calories);
    prefs.setDouble('dailySugar', sugar);
    prefs.setDouble('dailySodium', sodium);
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Inicio'),
      centerTitle: true,
      actions: [
        // Foto de perfil en la esquina superior derecha
        IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage('assets/images/Perfil_placeholder.jpg'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ],
    ),
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background-home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Mensaje de bienvenida centrado
          Text(
            'Bienvenido/a $userName, ¿qué vamos a comer hoy?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),

           // Barras de progreso para calorías, azúcar y sodio
            _buildProgressBar("Calorías por día", dailyCalories, 2000), // Máximo 2000 calorías
            _buildProgressBar("Azúcar por día", dailySugar, 50), // Máximo 50g de azúcar
            _buildProgressBar("Sodio por día", dailySodium, 2300), // Máximo 2300mg de sodio

            const Spacer(),

          // Resultado del escáner
          Text(
            'Barcode Result: $result',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          // Ícono de cámara centrado en el borde inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, size: 50),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScannerScreen(),
                  ),
                );
                
                if (result != null && result is Map<String, double>) {
                  _updateDailyProgress(
                    result['calories'] ?? 0,
                    result['sugar'] ?? 0,
                    result['sodium'] ?? 0,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

  // Función para construir las barras de progreso
  Widget _buildProgressBar(String label, double currentValue, double maxValue) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 300,
          child: LinearProgressIndicator(
            value: currentValue / maxValue,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            color: Colors.lightGreenAccent[400],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${currentValue.toStringAsFixed(0)} / ${maxValue.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}


