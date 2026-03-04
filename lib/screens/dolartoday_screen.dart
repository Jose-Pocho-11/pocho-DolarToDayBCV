import 'package:flutter/material.dart';
import 'package:dolar/data/model/dolar_response.dart';
import 'package:dolar/data/repository.dart';

// Importamos las nuevas vistas modulares
import 'package:dolar/screens/home_view.dart';
import 'package:dolar/screens/converter_view.dart';

class DolartodayScreen extends StatefulWidget {
  const DolartodayScreen({super.key});

  @override
  State<DolartodayScreen> createState() => _DolartodayScreenState();
}

class _DolartodayScreenState extends State<DolartodayScreen> {
  dolarRepository repository = dolarRepository();
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