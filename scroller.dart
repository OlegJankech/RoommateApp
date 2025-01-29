import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/person.dart';
import 'person_button.dart';
import 'updateDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Scroller extends StatefulWidget {
  const Scroller({super.key});

  @override
  State<Scroller> createState() => _ScrollerState();
}

class _ScrollerState extends State<Scroller> {
  List<Person> people = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUsers();
  }

  void fetchUsers() async {
    List<Person> users = await getAllUsers();
    setState(() {
      people = users;
      // remove self from people list
      people.removeWhere(
          (element) => element.id == FirebaseAuth.instance.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/try3.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false, // hides back button
            middle: Text(
              'The Owe List',
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: CupertinoColors.systemGrey.withOpacity(0.3),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
                  child: PersonButton(
                    userName: people[index].userName,
                    id: people[index].id,
                    email: people[index].email,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
