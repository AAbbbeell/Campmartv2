import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletTransaction {
  final String id;
  final String type; // 'deposit' or 'payment'
  final double amount;
  final String description;
  final DateTime date;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
      };

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: json['id'] as String,
        type: json['type'] as String,
        amount: (json['amount'] as num).toDouble(),
        description: json['description'] as String,
        date: DateTime.parse(json['date'] as String),
      );
}

class WalletService extends ChangeNotifier {
  static const _balanceKey = 'wallet_balance';
  static const _transactionsKey = 'wallet_transactions';

  double _balance = 0;
  List<WalletTransaction> _transactions = [];

  double get balance => _balance;
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _balance = prefs.getDouble(_balanceKey) ?? 0;
    final txJson = prefs.getString(_transactionsKey);
    if (txJson != null) {
      final list = List<Map<String, dynamic>>.from(jsonDecode(txJson));
      _transactions = list.map((t) => WalletTransaction.fromJson(t)).toList();
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, _balance);
    await prefs.setString(
      _transactionsKey,
      jsonEncode(_transactions.map((t) => t.toJson()).toList()),
    );
  }

  Future<void> deposit(double amount, {String description = 'Wallet top-up'}) async {
    if (amount <= 0) return;
    _balance += amount;
    _transactions.insert(
      0,
      WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'deposit',
        amount: amount,
        description: description,
        date: DateTime.now(),
      ),
    );
    await _persist();
    notifyListeners();
  }

  bool canPay(double amount) => _balance >= amount;

  String? pay(double amount, {required String description}) {
    if (amount <= 0) return 'Invalid amount';
    if (!canPay(amount)) return 'Insufficient wallet balance';
    _balance -= amount;
    _transactions.insert(
      0,
      WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'payment',
        amount: amount,
        description: description,
        date: DateTime.now(),
      ),
    );
    _persist();
    notifyListeners();
    return null;
  }
}
