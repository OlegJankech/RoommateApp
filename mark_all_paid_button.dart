import 'package:flutter/material.dart';
import 'package:flutter_application_1/debt.dart';

Widget markAllPaidButton(
  BuildContext context,
  List<Debt> debts,
  Function markAllPaid,
) {
  return GestureDetector(
    onLongPress: () {
      markAllPaid(debts);
    },
    child: FloatingActionButton(
      heroTag: 'markAllPaidButton',
      onPressed: () {}, // no response on short press
      backgroundColor: Colors.green.withOpacity(0.79),
      child: Icon(Icons.check_circle, color: Colors.white),
    ),
  );
}
