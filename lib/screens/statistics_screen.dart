import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Subscription> subscriptions;

  const StatisticsScreen({super.key, required this.subscriptions});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _touchedIndex = -1;

  static const _categoryColors = {
    'Streaming': Color(0xFFE50914),
    'Musik': Color(0xFF1DB954),
    'Produktivitas': Color(0xFF0078D4),
    'Game': Color(0xFFFF6B35),
    'Cloud': Color(0xFF00B4D8),
    'Berita': Color(0xFF6C63FF),
    'Kesehatan': Color(0xFF2ECC71),
    'Lainnya': Color(0xFF95A5A6),
  };

  Map<String, double> get _byCategory {
    final map = <String, double>{};
    for (final s in widget.subscriptions) {
      map[s.category] = (map[s.category] ?? 0) + s.price;
    }
    return map;
  }

  double get _total => widget.subscriptions.fold(0, (sum, s) => sum + s.price);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final byCategory = _byCategory;
    final categories = byCategory.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Statistik Pengeluaran', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: widget.subscriptions.isEmpty
          ? const Center(
              child: Text('Belum ada data untuk ditampilkan', style: TextStyle(color: Colors.grey)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalCard(formatter),
                  const SizedBox(height: 16),
                  _buildChartCard(categories, byCategory, formatter),
                  const SizedBox(height: 16),
                  _buildLegendCard(categories, byCategory, formatter),
                  const SizedBox(height: 16),
                  _buildRankingCard(formatter),
                ],
              ),
            ),
    );
  }

  Widget _buildTotalCard(NumberFormat formatter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Pengeluaran per Bulan', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Text(formatter.format(_total), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${widget.subscriptions.length} layanan aktif', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildChartCard(List<String> categories, Map<String, double> byCategory, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Distribusi per Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D2D2D))),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 3,
                centerSpaceRadius: 55,
                sections: List.generate(categories.length, (i) {
                  final cat = categories[i];
                  final value = byCategory[cat]!;
                  final pct = _total > 0 ? (value / _total * 100) : 0;
                  final isTouched = i == _touchedIndex;
                  final color = _categoryColors[cat] ?? const Color(0xFF95A5A6);

                  return PieChartSectionData(
                    color: color,
                    value: value,
                    title: '${pct.toStringAsFixed(0)}%',
                    radius: isTouched ? 70 : 58,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCard(List<String> categories, Map<String, double> byCategory, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rincian per Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D2D2D))),
          const SizedBox(height: 12),
          ...categories.map((cat) {
            final value = byCategory[cat]!;
            final pct = _total > 0 ? (value / _total * 100) : 0;
            final color = _categoryColors[cat] ?? const Color(0xFF95A5A6);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(cat, style: const TextStyle(fontSize: 13, color: Color(0xFF2D2D2D)))),
                  Text(formatter.format(value), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text('${pct.toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRankingCard(NumberFormat formatter) {
    final sorted = [...widget.subscriptions]..sort((a, b) => b.price.compareTo(a.price));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Langganan Termahal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D2D2D))),
          const SizedBox(height: 12),
          ...sorted.take(5).toList().asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final rankColors = [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];
            final rankColor = i < 3 ? rankColors[i] : const Color(0xFF9E9E9E);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: rankColor.withOpacity(0.15), shape: BoxShape.circle),
                    child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: rankColor)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s.name, style: const TextStyle(fontSize: 13))),
                  Text(formatter.format(s.price), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D2D2D))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
