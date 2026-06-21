import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

class DetailScreen extends StatelessWidget {
  final Subscription subscription;

  const DetailScreen({super.key, required this.subscription});

  static const _categoryIcons = {
    'Streaming': Icons.play_circle_outline,
    'Musik': Icons.music_note_outlined,
    'Produktivitas': Icons.work_outline,
    'Game': Icons.sports_esports_outlined,
    'Cloud': Icons.cloud_outlined,
    'Berita': Icons.newspaper_outlined,
    'Kesehatan': Icons.health_and_safety_outlined,
    'Lainnya': Icons.apps_outlined,
  };

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

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final color = _categoryColors[subscription.category] ?? const Color(0xFF6C63FF);
    final icon = _categoryIcons[subscription.category] ?? Icons.apps_outlined;
    final createdDate = DateFormat('dd MMMM yyyy', 'id_ID').format(subscription.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subscription.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoCard([
                    _infoRow(Icons.payments_outlined, 'Harga per Bulan', formatter.format(subscription.price), color),
                    const Divider(height: 1),
                    _infoRow(Icons.category_outlined, 'Kategori', subscription.category, color),
                    const Divider(height: 1),
                    _infoRow(
                      Icons.calendar_today_outlined,
                      'Tanggal Pembayaran',
                      'Setiap tanggal ${subscription.paymentDate}',
                      color,
                    ),
                    const Divider(height: 1),
                    _infoRow(Icons.access_time_outlined, 'Ditambahkan', createdDate, color),
                  ]),
                  if (subscription.notes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.note_outlined, color: color, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Catatan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            subscription.notes,
                            style: const TextStyle(color: Color(0xFF555555), height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _annualCard(formatter, color),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF2D2D2D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _annualCard(NumberFormat formatter, Color color) {
    final annual = subscription.price * 12;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimasi Pengeluaran Tahunan',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            formatter.format(annual),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatter.format(subscription.price)} × 12 bulan',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
