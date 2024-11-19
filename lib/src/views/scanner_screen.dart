import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String result = '';
  final ImagePicker _picker = ImagePicker();
  String _scanResult = '';

  Future<Map<String, dynamic>?> _searchInFirestore(String barcode) async {
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(barcode)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'calories': double.parse(data['calories'].toString()),
          'sugar': double.parse(data['sugar'].toString()),
          'sodium': double.parse(data['sodium'].toString()),
          'name': data['name'],
          'image': data['image'],
          'origen': 'Firebase (Colombia)'
        };
      }
    } catch (e) {
      print('Error al buscar en Firestore: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getProductInfo(String barcode) async {

    // Primero buscamos en Firestore en lugar del JSON local
    final firestoreProduct = await _searchInFirestore(barcode);
    if (firestoreProduct != null) return firestoreProduct;
    
    try {
      final openFoodResponse = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json')
      );

      if (openFoodResponse.statusCode == 200) {
        final data = json.decode(openFoodResponse.body);
        if (data['status'] == 1) {
          final product = data['product'];
          final nutriments = product['nutriments'];
          
          return {
            'calories': nutriments['energy-kcal_100g']?.toDouble() ?? 0.0,
            'sugar': nutriments['sugars_100g']?.toDouble() ?? 0.0,
            'sodium': nutriments['sodium_100g']?.toDouble() ?? 0.0,
            'name': product['product_name'],
            'image': product['image_url'],
            'origen': 'Internacional (OpenFoodFacts)'
          };
        }
      }
    } catch (e) {
      print('Error al consultar OpenFoodFacts: $e');
    }

    // Si no se encuentra en ninguna fuente, devolvemos null
    return null;
  }

  Future<void> _processBarcode(String barcode) async {
    setState(() {
      result = 'Buscando información del producto...';
    });

    final productInfo = await _getProductInfo(barcode);
    
    if (productInfo != null) {
      setState(() {
        result = 'Producto encontrado: ${productInfo['name']}';
      });
      Navigator.pop(context, {
        'calories': productInfo['calories'],
        'sugar': productInfo['sugar'],
        'sodium': productInfo['sodium']
      });
    } else {
      setState(() {
        result = 'No se encontró información del producto';
      });
    }
  }

  Future<void> _scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final res = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SimpleBarcodeScannerPage(),
          ),
        );
        if (res is String && res != '-1') {
          await _processBarcode(res);
        }
      }
    } catch (e) {
      print('Error al escanear desde galería: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Escáner'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ),
                    );
                    if (res is String) {
                      await _processBarcode(res);
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Usar Cámara'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _scanFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Abrir Galería'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                try {
<<<<<<< HEAD
                  // Carga el archivo JSON
                  final String jsonString = await rootBundle.loadString('assets/images/colombian_database.json');
                  final Map<String, dynamic> jsonData = json.decode(jsonString);
                  
                  int uploadedCount = 0;
                  
                  // Sube cada producto
                  for (var product in jsonData['products']) {
                    if (product['barcode'] != 'PENDIENTE') {
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(product['barcode'])
                          .set({
                        'name': product['name'],
                        'volume': product['volume'],
                        'calories': product['calories'],
                        'sugar': product['sugar'],
                        'sodium': product['sodium'],
                        'image': product['image'],
                      });
                      uploadedCount++;
                      print('Subido producto: ${product['name']}');
=======
                  // Agregar log para verificar si está entrando a la función
                  print('Iniciando carga de base de datos...');
                  
                  // Verificar que el archivo existe y se puede cargar
                  final String jsonString = await rootBundle.loadString('assets/colombian_database.json');
                  print('JSON cargado exitosamente');
                  
                  final Map<String, dynamic> jsonData = json.decode(jsonString);
                  print('JSON decodificado. Productos encontrados: ${jsonData['products']?.length ?? 0}');
                  
                  int uploadedCount = 0;
                  
                  // Verificar la estructura del JSON antes de procesar
                  if (jsonData['products'] == null || !(jsonData['products'] is List)) {
                    throw Exception('Estructura de JSON inválida');
                  }
                  
                  // Sube cada producto
                  for (var product in jsonData['products']) {
                    try {
                      if (product['barcode'] != 'PENDIENTE') {
                        print('Intentando subir producto: ${product['barcode']}');
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product['barcode'])
                            .set({
                          'name': product['name'],
                          'volume': product['volume'],
                          'calories': product['calories'],
                          'sugar': product['sugar'],
                          'sodium': product['sodium'],
                          'image': product['image'],
                        });
                        uploadedCount++;
                        print('Producto subido exitosamente: ${product['name']}');
                      }
                    } catch (e) {
                      print('Error al subir producto individual: ${product['barcode']} - Error: $e');
>>>>>>> isaac
                    }
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Subidos $uploadedCount productos a Firestore')),
                  );
                  
                } catch (e) {
                  print('Error al subir productos: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al subir productos a Firestore')),
                  );
                }
              },
              child: const Text('Subir Base de Datos Colombia'),
            ),
          ],
        ),
      ),
    );
  }
}
