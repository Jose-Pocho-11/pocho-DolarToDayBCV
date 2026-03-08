import 'package:flutter/material.dart';
import 'package:dolar/data/model/dolar_response.dart';
import 'package:dolar/data/repository.dart';

// Importamos las nuevas vistas modulares
import 'package:dolar/screens/home_view.dart';
import 'package:dolar/screens/converter_view.dart';
// import 'package:home_widget/home_widget.dart'; // Librería del widget (comentado para evitar errores)
// import 'package:shared_preferences/shared_preferences.dart'; // Comentado para evitar errores

class DolartodayScreen extends StatefulWidget {
  const DolartodayScreen({super.key});

  @override
  State<DolartodayScreen> createState() => _DolartodayScreenState();
}

class _DolartodayScreenState extends State<DolartodayScreen> {
  DolarRepository repository = DolarRepository();
  Future<List<DolarResponse?>>? _dolarFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Disparamos la petición una sola vez
    _dolarFuture = repository.fetchDolarInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFF39FF14),
        unselectedItemColor: Colors.white38,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Live Rates'),
          BottomNavigationBarItem(icon: Icon(Icons.currency_exchange), label: 'Convertir'),
        ],
      ),

      body: SafeArea(
        child: FutureBuilder<List<DolarResponse?>>(
          future: _dolarFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF39FF14)));
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Error al cargar los Datos", style: TextStyle(color: Colors.red)));
            } else {
              
              // Limpiamos nulos de la lista
              List<DolarResponse> rates = snapshot.data!.whereType<DolarResponse>().toList();

              // ==========================================
              // Guardamos el dato y actualizamos el widget
              // ==========================================
              if (rates.isNotEmpty) {
                final precioOficial = rates.first.promedio.toStringAsFixed(2);
                print('Actualizando widget con precio: $precioOficial'); // Debug
                
                // Código de widget comentado para evitar errores de dependencias
                /*
                // Solo ejecutar en Android, no en web
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  try {
                    if (defaultTargetPlatform == TargetPlatform.android) {
                      // Guardar con HomeWidget para que el widget lo lea
                      await HomeWidget.saveWidgetData<String>('precio_oficial', precioOficial);
                      await HomeWidget.updateWidget(name: 'DolarWidgetProvider');
                      
                      // También guardar en SharedPreferences como backup
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('precio_oficial', precioOficial);
                      
                      print('Widget actualizado correctamente'); // Debug
                    }
                  } catch (e) {
                    print('Error actualizando widget: $e'); // Debug
                  }
                });
                */
              }
              // ==========================================

              // Retornamos el módulo correspondiente según la pestaña activa
              return _selectedIndex == 0 
                  ? HomeView(rates: rates) 
                  : ConverterView(rates: rates);
            }
          },
        ),
      ),
    );
  }
}

/*
// Función para actualizar el widget desde el background (opcional)
Future<void> updateWidgetData(List<DolarResponse> rates) async {
  if (rates.isNotEmpty) {
    final precioOficial = rates.first.promedio.toStringAsFixed(2);
    // Solo ejecutar en Android, no en web
    if (defaultTargetPlatform == TargetPlatform.android) {
      await HomeWidget.saveWidgetData<String>('precio_oficial', precioOficial);
      await HomeWidget.updateWidget(name: 'DolarWidgetProvider');
    }
  }
}
*/
