import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'debt.dart';
import 'add_debt_button.dart';
import 'update_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'mark_all_paid_button.dart';

class Person extends StatefulWidget {
  final String id;
  final String userName;
  final String email;
  Function onBalanceUpdate;

  Person(
      {super.key,
      this.id = 'Error',
      this.userName = 'Error',
      this.email = 'Error',
      required this.onBalanceUpdate});

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Declare TextEditingControllers to hold input
  TextEditingController messageController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // List to hold debts // Musn't be final so isn't an attribute of Person
  // Stores debts of ALL users
  List<Debt> debts = [];
  double balance = 0.0;

  // when first brough to Person page
  @override
  void initState() {
    super.initState();
    getAllDebts().then((value) {
      setState(() {
        debts = value.reversed.toList();
      });
    });
    updateBalance();
  }

  void updateBalance() {
    getBalance(FirebaseAuth.instance.currentUser!.uid, widget.id).then((value) {
      setState(() {
        balance = value;
      });
    });
    widget.onBalanceUpdate();
  }

  void addDebt(String message, double amount) {
    setState(() {
      Debt newDebt = Debt(
        owedToName: FirebaseAuth.instance.currentUser?.displayName,
        owedToID: FirebaseAuth.instance.currentUser?.uid,
        debtorName: widget.userName,
        debtorID: widget.id,
        amount: amount,
        date: DateTime.now(),
        paid: false,
        msg: message,
      );
      debts.insert(0, newDebt);
      DatabaseReference id = saveDebt(newDebt);
      newDebt.setId(id); // Set the database reference ID
      updateBalance();
    });
  }

  void markAllPaid(List<Debt> debts) {
    setState(() {
      for (Debt debt in debts) {
        // if between you and the other person
        if (debt.debtorID == FirebaseAuth.instance.currentUser?.uid ||
            debt.owedToID == FirebaseAuth.instance.currentUser?.uid) {
          debt.paid = true;
          markDebtPaid(debt, debt.id!);
        }
      }
    });
    updateBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/try3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: CupertinoNavigationBar(
            // BACK BUTTON
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_circle_left_outlined,
                color: CupertinoColors.white,
              ),
            ),

            middle: Text(
              widget.userName,
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              'Balance: \$$balance',
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: CupertinoColors.systemGrey.withOpacity(0.3),
          ),
          body: Stack(children: [
            ListView.builder(
              itemCount: debts.length,
              itemBuilder: (context, index) {
                Debt transaction = debts[index];
                return ListTile(
                  tileColor:
                      // if paid its green, if its owed to you its yellow, if you owe its red
                      transaction.paid
                          ? Colors.green.withOpacity(0.2)
                          : transaction.debtorID ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? Colors.red.withOpacity(0.2)
                              : Colors.yellow.withOpacity(0.2),
                  title: Text(
                    '\$${transaction.amount} - ${transaction.msg}',
                    style: TextStyle(color: Color.fromARGB(199, 77, 57, 57)),
                  ),
                  subtitle: Text(
                    transaction.date.toString().split(' ')[0],
                    style:
                        TextStyle(color: const Color.fromARGB(199, 77, 57, 57)),
                  ),
                  enabled: !transaction.paid,
                  onLongPress: () {
                    setState(() {
                      // only if you are the debtor
                      if (transaction.debtorID ==
                          FirebaseAuth.instance.currentUser?.uid) {
                        transaction.paid = true;
                        // update the database
                        markDebtPaid(transaction, transaction.id!);
                      }
                    });
                    updateBalance();
                  },
                  trailing: Icon(
                    transaction.paid
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: transaction.paid ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: addDebtButton(
                  context, messageController, amountController, addDebt),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: markAllPaidButton(context, debts, markAllPaid),
            )
          ]),
        ),
      ],
    );
  }
}
