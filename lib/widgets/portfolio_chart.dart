import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioChart extends StatefulWidget {
  final List<double> priceData;

  const PortfolioChart({super.key, required this.priceData});

  @override
  State<PortfolioChart> createState() => _PortfolioChartState();
}

class _PortfolioChartState extends State<PortfolioChart> {
  List<Color> gradientColors = [
    const Color(0xFF00FF94).withOpacity(0.2),
    const Color(0xFF00FF94).withOpacity(0),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.priceData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final spots = widget.priceData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Color(0xFFB9CBBB),
                  fontSize: 10,
                  letterSpacing: 1,
                );
                String text;
                if (value == 0)
                  text = 'Jan 01';
                else if (value == 15)
                  text = 'Jan 15';
                else if (value == 29)
                  text = 'Jan 30';
                else
                  return const SizedBox.shrink();

                return Text(text, style: style);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length - 1.toDouble(),
        minY: spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.95,
        maxY: spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.05,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF00FF94),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                if (index == spots.length - 1) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: const Color(0xFF00FF94),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(radius: 0);
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpots) {
              return const Color(0xFF1A1C20);
            },

            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Color(0xFF00FF94),
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
