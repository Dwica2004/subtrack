import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';
import '../widgets/subscription_card.dart';
import '../widgets/empty_state.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  List<Subscription> _subscriptions = [];
  bool _loading = true;
  String _selectedCategory = 'Semua';

  static const _filterCategories = [
    'Semua', 'Streaming', 'Musik', 'Produktivitas', 'Game', 'Cloud', 'Berita', 'Kesehatan', 'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _storage.loadSubscriptions();
    setState(() {
      _subscriptions = data;
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _storage.saveSubscriptions(_subscriptions);
  }

  List<Subscription> get _filtered => _selectedCategory == 'Semua'
      ? _subscriptions
      : _subscriptions.where((s) => s.category == _selectedCategory).toList();

  double get _totalMonthly => _subscriptions.fold(0, (sum, s) => sum + s.price);

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push<Subscription>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditScreen()),
    );
    if (result != null) {
      setState(() => _subscriptions.add(result));
      await _save();
      _showSnackbar('Langganan berhasil ditambahkan');
    }
  }

  Future<void> _navigateToEdit(Subscription sub) async {
    final result = await Navigator.push<Subscription>(
      context,
      MaterialPageRoute(builder: (_) => AddEditScreen(subscription: sub)),
    );
    if (result != null) {
      final idx = _subscriptions.indexWhere((s) => s.id == sub.id);
      if (idx != -1) {
        setState(() => _subscriptions[idx] = result);
        await _save();
        _showSnackbar('Langganan berhasil diperbarui');
      }
    }
  }

  Future<void> _navigateToDetail(Subscription sub) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(subscription: sub)),
    );
  }

  Future<void> _navigateToStats() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StatisticsScreen(subscriptions: _subscriptions)),
    );
  }

  Future<void> _confirmDelete(Subscription sub) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Langganan?'),
        content: Text('Apakah Anda yakin ingin menghapus "${sub.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _subscriptions.removeWhere((s) => s.id == sub.id));
      await _save();
      _showSnackbar('Langganan berhasil dihapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(now);
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('SubsTrack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Statistik',
            onPressed: _subscriptions.isEmpty ? null : _navigateToStats,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAbout,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : Column(
              children: [
                _buildSummaryCard(formatter, monthName),
                if (_subscriptions.isNotEmpty) _buildFilterBar(),
                Expanded(
                  child: _subscriptions.isEmpty
                      ? EmptyState(onAdd: _navigateToAdd)
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_list_off, size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tidak ada langganan\ndalam kategori "$_selectedCategory"',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 8, bottom: 80),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) => SubscriptionCard(
                                subscription: filtered[i],
                                onTap: () => _navigateToDetail(filtered[i]),
                                onEdit: () => _navigateToEdit(filtered[i]),
                                onDelete: () => _confirmDelete(filtered[i]),
                              ),
                            ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAdd,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _filterCategories.length,
        itemBuilder: (_, i) {
          final cat = _filterCategories[i];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF6C63FF) : Colors.grey.shade300,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(NumberFormat formatter, String monthName) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9C8FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wallet_outlined, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                'Total Pengeluaran Bulanan',
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(_totalMonthly),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statChip(Icons.calendar_month_outlined, monthName),
              const SizedBox(width: 8),
              _statChip(Icons.subscriptions_outlined, '${_subscriptions.length} Langganan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('SubsTrack'),
        content: const Text('Aplikasi manajemen langganan digital.\nVersi 1.0.0'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
