import 'package:flutter/material.dart';

// Modelo ultra sencillo
class Rate {
  final String name;
  final String price;

  Rate({required this.name, required this.price});
}

class CartsMoney extends StatelessWidget {
  final List<Rate> rates;

  const CartsMoney({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.6, // Ajustado para que se vea bien sin el status
        ),
        itemCount: rates.length,
        itemBuilder: (context, index) {
          return _buildInfoCard(rates[index].name, rates[index].price);
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withAlpha((0.05 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24, // Un poco más grande para resaltar ya que hay menos texto
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}