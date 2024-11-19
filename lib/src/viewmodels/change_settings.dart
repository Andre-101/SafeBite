import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
import 'package:google_sign_in/google_sign_in.dart';
=======
import '../services/authentication_service.dart';
>>>>>>> isaac

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
<<<<<<< HEAD
            // Título de la pantalla
=======
>>>>>>> isaac
            const Text(
              'Ajustes de cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

<<<<<<< HEAD
            // Opción para cerrar sesión
=======
>>>>>>> isaac
            ListTile(
              title: const Text('Cerrar sesión'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
<<<<<<< HEAD
                // Cerrar sesión con Google
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                
                // Limpiar preferencias locales
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('username');
                // Redirigir al login
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),

            // Opción para eliminar cuenta
            ListTile(
              title: const Text('Eliminar cuenta'),
              trailing: const Icon(Icons.delete_forever),
              onTap: () async {
                // Confirmar eliminación de cuenta
=======
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
>>>>>>> isaac
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar cuenta'),
                      content: const Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no puede deshacerse.'),
                      actions: <Widget>[
                        TextButton(
<<<<<<< HEAD
                          onPressed: () {
                            Navigator.of(context).pop();  // Cerrar el diálogo sin eliminar la cuenta
                          },
=======
                          onPressed: () => Navigator.of(context).pop(),
>>>>>>> isaac
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
<<<<<<< HEAD
                            // Lógica para eliminar la cuenta (puedes implementar esto según tu backend o necesidades)
                            // En este ejemplo, solo eliminamos las preferencias locales
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();  // Elimina todos los datos guardados
                            
                            // Cerrar sesión y redirigir al login
                            final GoogleSignIn googleSignIn = GoogleSignIn();
                            await googleSignIn.signOut();
                            
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
=======
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context, 
                                '/login', 
                                (route) => false
                              );
                            }
>>>>>>> isaac
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
