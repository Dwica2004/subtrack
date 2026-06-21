import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

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
    final color = _categoryColors[subscription.category] ?? const Color(0xFF6C63FF);
    final icon = _categoryIcons[subscription.category] ?? Icons.apps_outlined;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            subscription.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.calendar_today_outlined, size: 11, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Text(
                          'Tgl ${subscription.paymentDate}',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatter.format(subscription.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF6C63FF)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
