import 'package:dolar/screens/dolartoday_screen.dart';
import 'package:flutter/material.dart';
import 'package:dolar/data/repository.dart'; // renombrado más abajo

import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const MainApp());
}

Future<void> actualizarWidgetDolar() async {
  final repo = DolarRepository();
  final dolares = await repo.fetchDolarInfo();
  
  if (dolares.isNotEmpty) {
    // Tomamos el primero, igual que en tu home_view con ratesDinamicos.first
    final dolarOficial = dolares.first; 
    final precio = dolarOficial!.promedio.toStringAsFixed(2);

    // Guardamos el dato con la llave 'precio_oficial'
    await HomeWidget.saveWidgetData<String>('precio_oficial', precio);

    // Le decimos a Android que actualice la vista
    await HomeWidget.updateWidget(
      name: 'DolarWidgetProvider', // Este nombre es crucial para el Paso 4
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DolartodayScreen(),
      ); 
    
  }
}
