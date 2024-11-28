import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/authentication_service.dart';  // Asegúrate de que el path sea correcto.

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthenticationService(context);  // Usamos el AuthenticationService.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la pantalla
            const Text(
              'Ajustes de cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Opción para cerrar sesión
            ListTile(
              title: const Text('Cerrar sesión'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                try {
                  print('Intentando cerrar sesión...');  // Mensaje de intento de cierre de sesión
                  // Llamada al método signOut del AuthenticationService
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();  // Ignora el ID de Google

                  // Redirigir al login
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  // Si ocurre un error, solo redirigimos al login
                  print('Error al cerrar sesión: $e');
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),

            // Opción para eliminar cuenta
            ListTile(
              title: const Text('Eliminar cuenta'),
              trailing: const Icon(Icons.delete_forever),
              onTap: () async {
                // Confirmar eliminación de cuenta
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar cuenta'),
                      content: const Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no puede deshacerse.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Cerrar el diálogo sin eliminar la cuenta
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await user.delete(); // Eliminar cuenta
                              }

                              // Cerrar sesión y redirigir al login
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();  // Ignorar el ID de Google
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                            } catch (e) {
                              // Manejar error si ocurre al eliminar cuenta
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al eliminar cuenta: $e')),
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
