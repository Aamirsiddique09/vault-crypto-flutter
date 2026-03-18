import 'dart:math';
import '../models/crypto_model.dart';

class CryptoService {
  // Local mock data for cryptocurrencies
  static final List<Map<String, dynamic>> _localCryptoData = [
    {
      'id': 'bitcoin',
      'symbol': 'btc',
      'name': 'Bitcoin',
      'image': 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      'current_price': 64231.50,
      'price_change_24h': 1523.20,
      'price_change_percentage_24h': 2.43,
      'market_cap': 1260000000000,
      'total_volume': 35000000000,
      'circulating_supply': 19600000,
      'sparkline_in_7d': {'price': _generateSparkline(60000, 65000, 30)},
    },
    {
      'id': 'ethereum',
      'symbol': 'eth',
      'name': 'Ethereum',
      'image':
          'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      'current_price': 3452.12,
      'price_change_24h': 62.15,
      'price_change_percentage_24h': 1.83,
      'market_cap': 415000000000,
      'total_volume': 15000000000,
      'circulating_supply': 120000000,
      'sparkline_in_7d': {'price': _generateSparkline(3200, 3500, 30)},
    },
    {
      'id': 'solana',
      'symbol': 'sol',
      'name': 'Solana',
      'image':
          'https://assets.coingecko.com/coins/images/4128/large/solana.png',
      'current_price': 145.89,
      'price_change_24h': -0.73,
      'price_change_percentage_24h': -0.50,
      'market_cap': 65000000000,
      'total_volume': 2800000000,
      'circulating_supply': 446000000,
      'sparkline_in_7d': {'price': _generateSparkline(140, 150, 30)},
    },
  ];

  // Generate realistic-looking sparkline data
  static List<double> _generateSparkline(double min, double max, int points) {
    final random = Random();
    final List<double> prices = [];
    double currentPrice = (min + max) / 2;

    for (int i = 0; i < points; i++) {
      double change = (random.nextDouble() - 0.5) * (max - min) * 0.05;
      currentPrice += change;
      currentPrice = currentPrice.clamp(min, max);
      prices.add(currentPrice);
    }
    return prices;
  }

  // Simulate network delay for realistic behavior
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Fetch top cryptocurrencies by market cap (local data)
  Future<List<CryptoModel>> getTopCryptos({int limit = 10}) async {
    await _simulateDelay();

    try {
      final data = _localCryptoData.take(limit).toList();
      return data.map((json) => CryptoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error loading local crypto data: $e');
    }
  }

  // Fetch specific coins (BTC, ETH, SOL) from local data
  Future<List<CryptoModel>> getSpecificCoins(List<String> coinIds) async {
    await _simulateDelay();

    try {
      final data = _localCryptoData.where((crypto) {
        return coinIds.contains(crypto['id']);
      }).toList();

      // Update prices slightly to simulate live market movement
      final updatedData = data.map((crypto) {
        final updatedCrypto = Map<String, dynamic>.from(crypto);
        final random = Random();
        final priceFluctuation =
            (random.nextDouble() - 0.5) * 0.002; // ±0.1% change
        final currentPrice = (crypto['current_price'] as double);
        updatedCrypto['current_price'] = currentPrice * (1 + priceFluctuation);
        updatedCrypto['price_change_24h'] =
            (crypto['price_change_24h'] as double) * (1 + priceFluctuation);
        return updatedCrypto;
      }).toList();

      return updatedData.map((json) => CryptoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error loading specific coins: $e');
    }
  }

  // Get portfolio history (local calculation)
  Future<List<FlSpot>> getPortfolioHistory() async {
    await _simulateDelay();

    try {
      final List<FlSpot> spots = [];
      double baseValue = 11000;
      final random = Random();

      for (int i = 0; i < 30; i++) {
        // Simulate realistic growth with some volatility
        double growthFactor =
            1 + (0.02 * (i / 30)) + (random.nextDouble() - 0.5) * 0.01;
        baseValue = baseValue * growthFactor;
        spots.add(FlSpot(i.toDouble(), baseValue));
      }
      return spots;
    } catch (e) {
      throw Exception('Error generating portfolio history: $e');
    }
  }

  // Get additional coins data (extended local database)
  Future<List<CryptoModel>> getExtendedCoins() async {
    await _simulateDelay();

    final extendedData = [
      ..._localCryptoData,
      {
        'id': 'cardano',
        'symbol': 'ada',
        'name': 'Cardano',
        'image':
            'https://assets.coingecko.com/coins/images/975/large/cardano.png',
        'current_price': 0.58,
        'price_change_24h': 0.02,
        'price_change_percentage_24h': 3.57,
        'market_cap': 20000000000,
        'total_volume': 500000000,
        'circulating_supply': 35000000000,
        'sparkline_in_7d': {'price': _generateSparkline(0.50, 0.60, 30)},
      },
      {
        'id': 'polkadot',
        'symbol': 'dot',
        'name': 'Polkadot',
        'image':
            'https://assets.coingecko.com/coins/images/12171/large/polkadot.png',
        'current_price': 7.85,
        'price_change_24h': -0.15,
        'price_change_percentage_24h': -1.87,
        'market_cap': 10000000000,
        'total_volume': 300000000,
        'circulating_supply': 1270000000,
        'sparkline_in_7d': {'price': _generateSparkline(7.50, 8.20, 30)},
      },
      {
        'id': 'chainlink',
        'symbol': 'link',
        'name': 'Chainlink',
        'image':
            'https://assets.coingecko.com/coins/images/877/large/chainlink.png',
        'current_price': 18.45,
        'price_change_24h': 0.89,
        'price_change_percentage_24h': 5.08,
        'market_cap': 10800000000,
        'total_volume': 450000000,
        'circulating_supply': 587000000,
        'sparkline_in_7d': {'price': _generateSparkline(16.00, 19.00, 30)},
      },
    ];

    return extendedData.map((json) => CryptoModel.fromJson(json)).toList();
  }

  // Simulate a price update (for real-time feel)
  Stream<CryptoModel> getPriceUpdates(String coinId) async* {
    final coinData = _localCryptoData.firstWhere(
      (c) => c['id'] == coinId,
      orElse: () => _localCryptoData.first,
    );

    final random = Random();

    while (true) {
      await Future.delayed(const Duration(seconds: 5));

      final basePrice = coinData['current_price'] as double;
      final fluctuation = (random.nextDouble() - 0.5) * 0.005; // ±0.25%
      final newPrice = basePrice * (1 + fluctuation);

      final updatedCoin = Map<String, dynamic>.from(coinData);
      updatedCoin['current_price'] = newPrice;

      yield CryptoModel.fromJson(updatedCoin);
    }
  }
}

// Chart data point class
class FlSpot {
  final double x;
  final double y;
  FlSpot(this.x, this.y);
}
