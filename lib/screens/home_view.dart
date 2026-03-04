import 'package:flutter/material.dart';
import 'package:dolar/data/model/dolar_response.dart';
import 'package:dolar/components/carts_money.dart';

class HomeView extends StatelessWidget {
  final List<DolarResponse> rates;

  const HomeView({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    // Transformamos los datos para tus tarjetas
    List<Rate> ratesDinamicos = rates.map((dolar) {
      return Rate(
        name: "DOLAR ${dolar.nombre.toUpperCase()}", 
        price: dolar.promedio.toStringAsFixed(2)
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          const Text(
            "DOLAR OFICIAL",
            style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 12),
          ),
          const SizedBox(height: 10),
          
          _buildBigPrice(ratesDinamicos.first.price),
          
          const Text(
            "VES / USD UNIT",
            style: TextStyle(color: Colors.white30, letterSpacing: 2, fontSize: 11),
          ),
          const SizedBox(height: 40),
          
          // Tus tarjetas dinámicas
          CartsMoney(rates: ratesDinamicos),
          
          const SizedBox(height: 40),
          _buildYieldBadge(),
          const SizedBox(height: 10),
          const Text("LAST SYNC: ACTUALIZADO",
              style: TextStyle(color: Colors.white24, fontSize: 10)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- MÉTODOS VISUALES DEL HOME ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LIVE FEED',
                  style: TextStyle(color: Color(0xFF39FF14), fontSize: 12, letterSpacing: 2)),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  children: [
                    TextSpan(text: 'POCHO', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'DOLAR', style: TextStyle(color: Color(0xFF39FF14))),
                  ],
                ),
              ),
            ],
          ),
          _buildSystemStatus(),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    DateTime now = DateTime.now();
    String date = "${now.day}.${_getMonthName(now.month)}.${now.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Row(
          children: [
            Container(
              width: 6, height: 6,
              decoration: const BoxDecoration(color: Color(0xFF39FF14), shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            const Text('SYSTEM ONLINE',
                style: TextStyle(color: Color(0xFF39FF14), fontSize: 10)),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
    return months[month - 1];
  }

  Widget _buildBigPrice(String price) {
    return Text(
      price,
      style: TextStyle(
        fontSize: 90,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF39FF14),
        shadows: [
          Shadow(blurRadius: 25, color: const Color(0xFF39FF14).withAlpha((0.8 * 255).round())),
        ],
      ),
    );
  }

  Widget _buildYieldBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withAlpha((0.3 * 255).round())),
        color: Colors.green.withAlpha((0.05 * 255).round()),
      ),
      child: const Text(
        "📈 +0.24% DAILY YIELD",
        style: TextStyle(color: Color(0xFF39FF14), fontWeight: FontWeight.bold),
      ),
    );
  }
}