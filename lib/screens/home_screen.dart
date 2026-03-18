import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/crypto_model.dart';
import '../services/crypto_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/price_ticker.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CryptoService _cryptoService = CryptoService();
  List<CryptoModel> _cryptos = [];
  bool _isLoading = true;
  int _selectedNavIndex = 0;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Auto-refresh every 30 seconds
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetchData(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final cryptos = await _cryptoService.getSpecificCoins([
        'bitcoin',
        'ethereum',
        'solana',
      ]);
      setState(() {
        _cryptos = cryptos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get _totalBalance {
    // Mock calculation - in real app, multiply by user's holdings
    return 12450.23 +
        (_cryptos.isNotEmpty ? _cryptos[0].priceChange24h * 0.1 : 0);
  }

  double get _totalChange {
    if (_cryptos.isEmpty) return 8.42;
    final totalChange = _cryptos.fold<double>(
      0,
      (sum, c) => sum + c.priceChangePercentage24h,
    );
    return totalChange / _cryptos.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111318),
      extendBody: true,
      body: Stack(
        children: [
          // Background atmospheric effects
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF942CC7).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF14D1FF).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: _fetchData,
              color: const Color(0xFF00FF94),
              backgroundColor: const Color(0xFF1A1C20),
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF282A2E),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(
                                      0xFF3B4B3E,
                                    ).withOpacity(0.2),
                                  ),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://i.pravatar.cc/150?img=11',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Vault',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00FF94),
                                  shadows: [
                                    Shadow(
                                      color: const Color(
                                        0xFF00FF94,
                                      ).withOpacity(0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: const Color(0xFFE2E2E8).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hero Balance Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Net Worth',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFB9CBBB).withOpacity(0.6),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$${_totalBalance.toStringAsFixed(0)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFE2E2E8),
                                  letterSpacing: -2,
                                  height: 1,
                                ),
                              ),
                              Text(
                                '.${_totalBalance.toStringAsFixed(2).split('.')[1]}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF00FF94),
                                  letterSpacing: -2,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00FF94).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  size: 16,
                                  color: Color(0xFF00FF94),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_totalChange >= 0 ? '+' : ''}${_totalChange.toStringAsFixed(2)}% (\$${_totalBalance * (_totalChange / 100) > 0 ? '+' : ''}${(_totalBalance * (_totalChange / 100)).abs().toStringAsFixed(2)})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF00FF94),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Live Price Ticker
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 140,
                      child: _isLoading
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              itemCount: 3,
                              itemBuilder: (context, index) => Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF333539,
                                  ).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00FF94),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              itemCount: _cryptos.length,
                              itemBuilder: (context, index) {
                                final crypto = _cryptos[index];
                                final colors = [
                                  Colors.orange.shade400,
                                  Colors.blue.shade400,
                                  Colors.purple.shade400,
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: PriceTicker(
                                    crypto: crypto,
                                    accentColor: colors[index % colors.length],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),

                  // Main Chart Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Portfolio Growth',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFE2E2E8),
                                  ),
                                ),
                                Row(
                                  children: ['1D', '1W', '1M'].map((period) {
                                    final isSelected = period == '1D';
                                    return Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(
                                                0xFF00FF94,
                                              ).withOpacity(0.2)
                                            : const Color(0xFF282A2E),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        period,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? const Color(0xFF00FF94)
                                              : const Color(
                                                  0xFFE2E2E8,
                                                ).withOpacity(0.6),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 200,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : PortfolioChart(
                                      priceData:
                                          _cryptos.isNotEmpty &&
                                              _cryptos[0]
                                                  .sparklineIn7d
                                                  .isNotEmpty
                                          ? _cryptos[0].sparklineIn7d
                                          : List.generate(
                                              30,
                                              (i) => 10000 + i * 100,
                                            ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Portfolio Distribution & Smart Trade
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Distribution Card
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Distribution',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFE2E2E8),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    // Circular Chart
                                    SizedBox(
                                      width: 112,
                                      height: 112,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: 0.6,
                                            strokeWidth: 10,
                                            backgroundColor: const Color(
                                              0xFF282A2E,
                                            ),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  const Color(
                                                    0xFF00FF94,
                                                  ).withOpacity(0.3),
                                                ),
                                          ),
                                          CircularProgressIndicator(
                                            value: 0.25,
                                            strokeWidth: 10,
                                            backgroundColor: Colors.transparent,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  const Color(
                                                    0xFF14D1FF,
                                                  ).withOpacity(0.3),
                                                ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Assets',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFFB9CBBB,
                                                  ).withOpacity(0.6),
                                                ),
                                              ),
                                              Text(
                                                '${_cryptos.length}',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                        0xFFE2E2E8,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _buildDistributionItem(
                                            'Bitcoin',
                                            '60%',
                                            const Color(0xFF00FF94),
                                          ),
                                          const SizedBox(height: 12),
                                          _buildDistributionItem(
                                            'Ethereum',
                                            '25%',
                                            const Color(0xFF14D1FF),
                                          ),
                                          const SizedBox(height: 12),
                                          _buildDistributionItem(
                                            'Others',
                                            '15%',
                                            const Color(
                                              0xFFF5D4FF,
                                            ).withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Smart Trade Card
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Smart Trade',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFE2E2E8),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'AI-powered market entry at optimal liquidity pools.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color(
                                                0xFFB9CBBB,
                                              ).withOpacity(0.6),
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.bolt,
                                      size: 64,
                                      color: const Color(
                                        0xFF00FF94,
                                      ).withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF00FF94),
                                        Color(0xFF14D1FF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF00FF94,
                                        ).withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: -5,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(24),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Text(
                                          'EXECUTE AUTO-SWAP',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00391D),
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom padding for nav bar
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
    );
  }

  Widget _buildDistributionItem(String name, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE2E2E8),
            ),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE2E2E8),
          ),
        ),
      ],
    );
  }
}
