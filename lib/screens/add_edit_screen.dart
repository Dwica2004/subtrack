import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../models/subscription.dart';

class AddEditScreen extends StatefulWidget {
  final Subscription? subscription;

  const AddEditScreen({super.key, this.subscription});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _category = 'Streaming';
  int? _paymentDate;
  bool _isEdit = false;

  static const _categories = [
    'Streaming',
    'Musik',
    'Produktivitas',
    'Game',
    'Cloud',
    'Berita',
    'Kesehatan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.subscription != null) {
      _isEdit = true;
      final s = widget.subscription!;
      _nameCtrl.text = s.name;
      _priceCtrl.text = s.price.toStringAsFixed(0);
      _notesCtrl.text = s.notes;
      _category = s.category;
      _paymentDate = s.paymentDate;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_paymentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Tanggal pembayaran wajib dipilih'),
            ],
          ),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final price = double.tryParse(_priceCtrl.text.replaceAll('.', '')) ?? 0;
    final sub = Subscription(
      id: widget.subscription?.id ?? const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      price: price,
      category: _category,
      paymentDate: _paymentDate!,
      notes: _notesCtrl.text.trim(),
      createdAt: widget.subscription?.createdAt ?? DateTime.now(),
    );
    Navigator.pop(context, sub);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEdit ? 'Edit Langganan' : 'Tambah Langganan',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Informasi Langganan'),
              _buildCard([
                _buildTextField(
                  controller: _nameCtrl,
                  label: 'Nama Aplikasi',
                  icon: Icons.apps_outlined,
                  hint: 'contoh: Netflix, Spotify',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Nama aplikasi tidak boleh kosong';
                    return null;
                  },
                ),
                const Divider(height: 1),
                _buildTextField(
                  controller: _priceCtrl,
                  label: 'Harga per Bulan (Rp)',
                  icon: Icons.payments_outlined,
                  hint: 'contoh: 54000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Harga tidak boleh kosong';
                    final price = double.tryParse(v);
                    if (price == null || price <= 0) return 'Harga harus berupa angka yang valid';
                    return null;
                  },
                ),
              ]),
              const SizedBox(height: 16),
              _sectionLabel('Kategori'),
              _buildCategoryGrid(),
              const SizedBox(height: 16),
              _sectionLabel('Tanggal Pembayaran'),
              _buildDateSelector(),
              const SizedBox(height: 16),
              _sectionLabel('Catatan (Opsional)'),
              _buildCard([
                _buildTextField(
                  controller: _notesCtrl,
                  label: 'Catatan',
                  icon: Icons.note_outlined,
                  hint: 'Tambahkan catatan...',
                  maxLines: 3,
                ),
              ]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  child: Text(
                    _isEdit ? 'Simpan Perubahan' : 'Simpan Langganan',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6C63FF),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
          border: InputBorder.none,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _categories.map((cat) {
          final selected = cat == _category;
          return GestureDetector(
            onTap: () => setState(() => _category = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF6C63FF) : const Color(0xFFF0EFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF6C63FF),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF6C63FF)),
                const SizedBox(width: 6),
                Text(
                  _paymentDate != null
                      ? 'Tanggal dipilih: $_paymentDate'
                      : 'Pilih tanggal setiap bulan',
                  style: TextStyle(
                    fontSize: 13,
                    color: _paymentDate != null ? const Color(0xFF2D2D2D) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(28, (i) {
              final date = i + 1;
              final selected = date == _paymentDate;
              return GestureDetector(
                onTap: () => setState(() => _paymentDate = date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF6C63FF) : const Color(0xFFF0EFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$date',
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF6C63FF),
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
