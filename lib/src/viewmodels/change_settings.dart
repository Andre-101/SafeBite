import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/authentication_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajustes de cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              title: const Text('Cerrar sesión'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                try {
                  // Cerrar sesión
                  await AuthenticationService(context).signOut();
                  
                  // Limpiar preferencias locales
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  
                  if (context.mounted) {
                    // Redirigir al login
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/login', 
                      (route) => false
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al cerrar sesión: $e'))
                    );
                  }
                }
              },
            ),

            ListTile(
              title: const Text('Eliminar cuenta'),
              trailing: const Icon(Icons.delete_forever),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar cuenta'),
                      content: const Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no puede deshacerse.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context, 
                                '/login', 
                                (route) => false
                              );
                            }
                          },
                          child: const Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
