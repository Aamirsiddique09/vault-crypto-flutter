import 'package:flutter/material.dart';
import '../models/crypto_model.dart';

class PriceTicker extends StatelessWidget {
  final CryptoModel crypto;
  final Color accentColor;

  const PriceTicker({Key? key, required this.crypto, required this.accentColor})
    : super(key: key);

  IconData get _cryptoIcon {
    switch (crypto.symbol.toLowerCase()) {
      case 'btc':
        return Icons.currency_bitcoin;
      case 'eth':
        return Icons.eco;
      case 'sol':
        return Icons.show_chart;
      default:
        return Icons.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF333539).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFB9CBBB).withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(_cryptoIcon, color: accentColor, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: crypto.isPositive
                      ? const Color(0xFF00FF94).withOpacity(0.1)
                      : const Color(0xFFFFB4AB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  crypto.formattedChange,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: crypto.isPositive
                        ? const Color(0xFF00FF94)
                        : const Color(0xFFFFB4AB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${crypto.symbol} / USD',
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFFB9CBBB).withOpacity(0.6),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            crypto.formattedPrice,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE2E2E8),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  accentColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
