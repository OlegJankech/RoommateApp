import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Debt extends StatelessWidget {
  final String? owedToName;
  final String? owedToID;
  final String? debtorName;
  final String? debtorID;
  final double? amount;
  final DateTime? date;
  final String? msg;
  bool paid = false;
  DatabaseReference? id;

  Debt(
      {super.key,
      this.owedToName,
      this.owedToID,
      this.debtorName,
      this.debtorID,
      this.amount,
      this.date,
      this.msg,
      this.paid = false});

  void setId(DatabaseReference eyedee) {
    id = eyedee;
  }

  Map<String, dynamic> toJson() {
    return {
      'owedToName': owedToName,
      'owedToID': owedToID,
      'debtorName': debtorName,
      'debtorID': debtorID,
      'amount': amount,
      'date': date?.toIso8601String(),
      'message': msg,
      'paid': paid,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$debtorName owes $owedToName'),
      subtitle: Text('Amount: \$${amount?.toStringAsFixed(2)}'),
      trailing: Icon(
        paid == true ? Icons.check_circle : Icons.cancel,
        color: paid == true ? Colors.green : Colors.red,
      ),
    );
  }
}

Debt addDebt(Map<dynamic, dynamic> record) {
  Map<String, dynamic> attributes = {
    'owedTo': '',
    'debtor': '',
    'amount': 0.0,
    'message': '',
    'date': DateTime.now().toIso8601String(),
    'paid': false,
  };

  record.forEach((key, value) {
    attributes[key] = value;
  });

  Debt debt = Debt(
    owedToName: attributes['owedTo'],
    owedToID: attributes['owedToID'],
    debtorName: attributes['debtor'],
    debtorID: attributes['debtorID'],
    amount: double.parse(attributes['amount'].toString()),
    msg: attributes['message'],
    date: DateTime.parse(attributes['date']),
    paid: attributes['paid'],
  );
  return debt;
}
