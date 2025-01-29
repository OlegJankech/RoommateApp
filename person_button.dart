import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'person.dart';
import 'update_database.dart';

class PersonButton extends StatefulWidget {
  final String userName;
  final String id;
  final String email;

  const PersonButton({
    super.key,
    required this.userName,
    required this.id,
    required this.email,
  });

  @override
  _PersonButtonState createState() => _PersonButtonState();
}

class _PersonButtonState extends State<PersonButton> {
  double balance = 0.0;

  @override
  void initState() {
    // on widget creation
    super.initState();
    updateBalance();
  }

  void updateBalance() {
    getBalance(FirebaseAuth.instance.currentUser!.uid, widget.id).then((value) {
      setState(() {
        balance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Person(
                    id: widget.id,
                    userName: widget.userName,
                    email: widget.email,
                    onBalanceUpdate: updateBalance,
                  )),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          // green if balance is 0, red if positive, yellow if negative
          color: balance == 0
              ? CupertinoColors.systemGreen.withOpacity(0.3)
              : balance > 0
                  ? CupertinoColors.systemRed.withOpacity(0.3)
                  : CupertinoColors.systemYellow.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.inactiveGray.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${widget.userName} - \$$balance',
            style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
