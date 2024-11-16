import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String result = '';
  final ImagePicker _picker = ImagePicker();
  String _scanResult = '';

  Future<Map<String, dynamic>?> _getProductInfo(String barcode) async {
    // Primero intentamos con nuestra API colombiana
    try {
      final colombianResponse = await http.get(
        Uri.parse('https://tu-api-colombiana.com/api/products/$barcode')
        // Reemplaza la URL con tu endpoint real
      );

      if (colombianResponse.statusCode == 200) {
        final data = json.decode(colombianResponse.body);
        return {
          'calories': data['calorias']?.toDouble() ?? 0.0,
          'sugar': data['azucares']?.toDouble() ?? 0.0,
          'sodium': data['sodio']?.toDouble() ?? 0.0,
          'name': data['nombre'],
          'image': data['imagen_url'],
          'origen': 'Colombia'
        };
      }

      // Si no se encuentra en la base colombiana, intentamos con OpenFoodFacts
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
            'origen': 'Internacional'
          };
        }
      }
      return null;
    } catch (e) {
      print('Error obteniendo información del producto: $e');
      return null;
    }
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
      Navigator.pop(context, productInfo);
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
          ],
        ),
      ),
    );
  }
}
