import 'package:flutter/material.dart';

Widget addDebtButton(
    BuildContext context,
    TextEditingController messageController,
    TextEditingController amountController,
    Function addDebtCallback) {
  return FloatingActionButton(
    heroTag: 'addDebtButton', // unique from other button
    onPressed: () {
      showModalBottomSheet(
        isScrollControlled: true, // move up with keyboard
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                      ),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          String message = messageController.text;
                          double amount =
                              double.tryParse(amountController.text) ?? 0.0;

                          // If the message is empty or amount is invalid, don't add // never going to be null
                          if (message.isNotEmpty && amount > 0) {
                            addDebtCallback(message, amount);
                            Navigator.pop(context); // Close bottom sheet
                          }
                        },
                        child: Text(
                          'Add Debt',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
    child: Icon(Icons.add),
  );
}
