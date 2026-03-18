class CryptoModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final double circulatingSupply;
  final List<double> sparklineIn7d;

  CryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.circulatingSupply,
    this.sparklineIn7d = const [],
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] ?? '',
      symbol: json['symbol']?.toUpperCase() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0)
          .toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
      sparklineIn7d: json['sparkline_in_7d'] != null
          ? List<double>.from(json['sparkline_in_7d']['price'] ?? [])
          : [],
    );
  }

  String get formattedPrice => '\$${currentPrice.toStringAsFixed(2)}';
  String get formattedChange =>
      '${priceChangePercentage24h >= 0 ? '+' : ''}${priceChangePercentage24h.toStringAsFixed(2)}%';
  bool get isPositive => priceChangePercentage24h >= 0;
}
