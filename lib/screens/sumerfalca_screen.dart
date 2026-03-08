import 'package:flutter/material.dart';
import 'package:dolar/data/model/dolar_response.dart';
import 'package:dolar/data/repository.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SumerfalcaScreen extends StatefulWidget {
  const SumerfalcaScreen({Key? key}) : super(key: key);

  @override
  State<SumerfalcaScreen> createState() => _SumerfalcaScreenState();
}

class _SumerfalcaScreenState extends State<SumerfalcaScreen> {
  DolarResponse? _dolarOficial;
  bool _isLoading = true;
  String? _error;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _fetchDolarData();
  }

  Future<void> _fetchDolarData() async {
    try {
      final repository = DolarRepository(); 
      final rates = await repository.fetchDolarInfo();
      
      if (mounted) { 
        setState(() {
          if (rates.isNotEmpty) {
            final nonNullRates = rates.where((rate) => rate != null).cast<DolarResponse>();
            _dolarOficial = nonNullRates.firstWhere(
              (rate) => rate.fuente.toLowerCase() == 'oficial',
              orElse: () => nonNullRates.first, 
            );
          } else {
            _error = 'No se encontraron datos';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) { 
        setState(() {
          _error = 'Error al cargar datos';
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(String fecha) {
    if (fecha.isEmpty) return 'Fecha no disponible';
    try {
      final dateTime = DateTime.parse(fecha).toLocal(); 
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return fecha;
    }
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(4);
    return formatted.replaceAll('.', ',');
  }

  Future<void> _captureAndSaveScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/dolar_${DateTime.now().millisecondsSinceEpoch}.png').create();
        await imagePath.writeAsBytes(image);
        
        await Share.shareXFiles([XFile(imagePath.path)]);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Captura lista para compartir y guardar!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al capturar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo oscuro para las franjas sobrantes
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndSaveScreenshot,
        backgroundColor: Colors.red,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          // El Screenshot envuelve solo la caja proporcional para evitar capturar bordes negros
          child: Screenshot(
            controller: _screenshotController,
            child: AspectRatio(
              // ⚠️ IMPORTANTE: Cambia 1080 / 1920 por el Ancho / Alto exacto de tu imagen 'sumerfalcal.jpeg'
              aspectRatio: 1080 / 1920, 
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // --- LA IMAGEN DE FONDO ---
                      Image.asset(
                        'assets/imagen/sumerfalcal.jpeg',
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        fit: BoxFit.fill, // Se llena perfecto porque la caja ya tiene la proporción de la imagen
                      ),
                      
                      // --- ESTADOS DE CARGA Y ERROR ---
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator(color: Colors.white))
                      else if (_error != null)
                        Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 241, 4, 4),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                      else ...[
                        // --- EL PRECIO DEL DÓLAR (CENTRALIZADO PERFECTAMENTE) ---
                        Positioned(
                          top: constraints.maxHeight * 0.62, 
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              _formatPrice(_dolarOficial?.promedio ?? 0.0),
                              style: const TextStyle(
                                color: Colors.black, 
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        // --- LA FECHA ---
                        Positioned(
                          top: constraints.maxHeight * 0.902, // Ajusta este % si es necesario
                          left: constraints.maxWidth * 0.41, // Ajusta este % si es necesario
                          child: Text(
                            _formatDate(_dolarOficial?.fechaActualizacion ?? ""),
                            style: const TextStyle(
                              color: Colors.black, 
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}