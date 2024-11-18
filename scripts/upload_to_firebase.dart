import 'dart:convert';
import 'dart:io';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:path/path.dart' as path;

void main() async {
  // Inicializa Firebase Admin
  final cert = ServiceAccount.fromJson({
    // Copia aquí el contenido de tu archivo service-account.json
    "type": "service_account",
    "project_id": "tu-proyecto-id",
    // ... resto de las credenciales
  });

  App app = FirebaseAdmin.instance.initializeApp(
    AppOptions(credential: cert)
  );

  // Lee el archivo JSON
  final file = File(path.join(Directory.current.path, 'assets', 'images', 'colombian_database.json'));
  final jsonString = await file.readAsString();
  final jsonData = json.decode(jsonString);
  
  // Obtiene la referencia a Firestore
  final firestore = FirebaseAdmin.instance.firestore();
  
  // Sube cada producto
  for (var product in jsonData['products']) {
    if (product['barcode'] != 'PENDIENTE') {
      await firestore.collection('products').doc(product['barcode']).set({
        'name': product['name'],
        'volume': product['volume'],
        'calories': product['calories'],
        'sugar': product['sugar'],
        'sodium': product['sodium'],
        'image': product['image'],
      });
      print('Subido producto: ${product['name']}');
    }
  }
  
  print('Migración completada');
  app.delete();
} 