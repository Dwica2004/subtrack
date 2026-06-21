import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

class StorageService {
  static const _key = 'subscriptions';

  Future<List<Subscription>> loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Subscription.fromJson(e)).toList();
  }

  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(subscriptions.map((s) => s.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
