import 'package:flutter/material.dart';
import 'package:dolar/data/model/dolar_response.dart';

class ConverterView extends StatefulWidget {
  final List<DolarResponse> rates;

  const ConverterView({super.key, required this.rates});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  String _amountText = ""; 
  DolarResponse? _selectedRate;
  bool _isUsdToVes = true;
  double _convertedResult = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.rates.isNotEmpty) {
      _selectedRate = widget.rates.first;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},'
      );
    }
    return amount.toStringAsFixed(2);
  }

  String _formatInputAmount(String amount) {
    if (amount.isEmpty) return amount;
    
    // Remove existing commas for parsing
    String cleanAmount = amount.replaceAll(',', '');
    
    // Parse and reformat with commas
    double? parsed = double.tryParse(cleanAmount);
    if (parsed != null && parsed >= 1000) {
      return parsed.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},'
      );
    }
    return amount;
  }

  void _calculateConversion() {
    if (_amountText.isEmpty || _selectedRate == null) {
      setState(() => _convertedResult = 0.0);
      return;
    }
    
    double amount = double.tryParse(_amountText) ?? 0.0;

    setState(() {
      if (_isUsdToVes) {
        _convertedResult = amount * _selectedRate!.promedio;
      } else {
        _convertedResult = amount / _selectedRate!.promedio;
      }
    });
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'C') {
        _amountText = ""; 
      } else if (key == '⌫') {
        if (_amountText.isNotEmpty) {
          _amountText = _amountText.substring(0, _amountText.length - 1); 
        }
      } else if (key == '.') {
        if (!_amountText.contains('.')) {
          _amountText += _amountText.isEmpty ? "0." : "."; 
        }
      } else if (key == '00') {
        if (_amountText.isNotEmpty && _amountText != "0") {
          _amountText += "00"; 
        }
      } else {
        if (_amountText.length < 12) { 
          if (_amountText == "0") {
            _amountText = key; 
          } else {
            _amountText += key; 
          }
        }
      }
      _calculateConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Redujimos el padding general
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Títulos más compactos
          const Text('CURRENCY', style: TextStyle(color: Color(0xFF39FF14), fontSize: 10, letterSpacing: 2)),
          const Text('EXCHANGE', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 15), // Espacio reducido (antes 40)

          _buildDropdown(),
          const SizedBox(height: 10), // Espacio reducido

          _buildDisplay(),
          const SizedBox(height: 10), // Espacio reducido

          // El teclado tomará el espacio restante sin desbordarse
          Expanded(
            child: _buildKeypad(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      // Padding interno reducido
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DolarResponse>(
          isExpanded: true,
          dropdownColor: const Color(0xFF121212),
          value: _selectedRate,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF39FF14)),
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          items: widget.rates.map((DolarResponse rate) {
            return DropdownMenuItem<DolarResponse>(
              value: rate,
              child: Text("DOLAR ${rate.nombre.toUpperCase()} - Bs. ${rate.promedio.toStringAsFixed(2)}"),
            );
          }).toList(),
          onChanged: (DolarResponse? newValue) {
            setState(() {
              _selectedRate = newValue;
              _calculateConversion();
            });
          },
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15), // Padding interno reducido de 20 a 15
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF39FF14).withAlpha((0.4 * 255).round())),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF39FF14).withAlpha((0.05 * 255).round()),
            blurRadius: 15,
            spreadRadius: 1,
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _isUsdToVes ? 'ENVÍAS USD (\$)' : 'ENVÍAS VES (Bs)',
            style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2), // Letra más pequeña
          ),
          Text(
            _amountText.isEmpty ? "0" : _formatInputAmount(_amountText),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold), // De 35 a 28
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(color: Colors.white12, height: 15), // De 30 a 15
          Text(
            _isUsdToVes ? 'RECIBES VES (Bs)' : 'RECIBES USD (\$)',
            style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2),
          ),
          Text(
            _convertedResult == 0.0 ? "0.00" : _formatAmount(_convertedResult),
            style: const TextStyle(color: Color(0xFF39FF14), fontSize: 32, fontWeight: FontWeight.bold), // De 40 a 32
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final buttons = [
      '7', '8', '9', 'C',
      '4', '5', '6', '⌫',
      '1', '2', '3', '⇅',
      '00', '0', '.', ''
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
        childAspectRatio: 1.4, // <--- MAGIA AQUÍ: De 1.1 a 1.4 hace los botones más bajos y anchos
        crossAxisSpacing: 8, // Separación reducida
        mainAxisSpacing: 8,  // Separación reducida
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return _buildCalculatorButton(buttons[index]);
      },
    );
  }

  Widget _buildCalculatorButton(String text) {
    if (text.isEmpty) return const SizedBox.shrink(); 

    bool isAction = ['C', '⌫', '⇅'].contains(text);
    Color textColor = Colors.white;
    if (text == 'C') textColor = Colors.redAccent;
    if (text == '⇅') textColor = const Color(0xFF39FF14);
    if (text == '⌫') textColor = Colors.orangeAccent;

    return InkWell(
      onTap: () {
        if (text == '⇅') {
          setState(() {
            _isUsdToVes = !_isUsdToVes;
            _calculateConversion();
          });
        } else {
          _onKeyPress(text); 
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isAction ? const Color(0xFF1A1A1A) : const Color(0xFF121212),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isAction ? Colors.white24 : Colors.white12),
        ),
        alignment: Alignment.center,
        child: text == '⇅' 
          ? const Icon(Icons.swap_vert, color: Color(0xFF39FF14), size: 28) // Icono más pequeño
          : Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 22, // De 26 a 22
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}