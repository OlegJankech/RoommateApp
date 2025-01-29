import 'package:firebase_database/firebase_database.dart';
import 'debt.dart';
import 'person.dart';

final databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference saveDebt(Debt debt) {
  var id = databaseReference.child('debts/').push();
  id.set(debt.toJson());
  return id;
}

void markDebtPaid(Debt debt, DatabaseReference id) {
  debt.paid = true;
  id.update(debt.toJson());
}

Future<List<Debt>> getAllDebts() async {
  DatabaseEvent databaseEvent = await databaseReference.child('debts/').once();
  List<Debt> debts = [];
  if (databaseEvent.snapshot.value != null) {
    for (var child in databaseEvent.snapshot.children) {
      Debt debt = addDebt(child.value as Map<dynamic, dynamic>);
      debt.setId(databaseReference.child('debts/${child.key!}'));
      debts.add(debt);
    }
  }
  return debts;
}

Future<Person> getUser(String id) async {
  List<Person> people = await getAllUsers();
  for (int i = 0; i < people.length; i++) {
    if (people[i].id == id) {
      return people[i];
    }
  }
  return Person(
    id: 'Error',
    userName: 'Error',
    email: 'Error',
    onBalanceUpdate: () {},
  );
}

// get balance between two users
Future<double> getBalance(String yourID, String otherID) async {
  List<Debt> debts = await getAllDebts();

  double balance = 0.0;
  for (int i = 0; i < debts.length; i++) {
    if (debts[i].debtorID == otherID &&
        debts[i].owedToID == yourID &&
        !debts[i].paid) {
      balance -= debts[i].amount?.toDouble() ?? 0.0;
    } else if (debts[i].owedToID == otherID &&
        debts[i].debtorID == yourID &&
        !debts[i].paid) {
      balance += debts[i].amount?.toDouble() ?? 0.0;
    }
  }
  return balance;
}

Future<List<Person>> getAllUsers() async {
  DatabaseEvent databaseEvent = await databaseReference.child('users/').once();
  List<Person> people = [];
  if (databaseEvent.snapshot.value != null) {
    for (var child in databaseEvent.snapshot.children) {
      String eyeDee = child.child('id').value as String;
      String userName = child.child('name').value as String;
      String email = child.child('email').value as String;
      people.add(Person(
          id: eyeDee,
          userName: userName,
          email: email,
          onBalanceUpdate: () {}));
    }
  }
  return people;
}

DatabaseReference saveUser(String eyeDee, String userName, String email) {
  var id = databaseReference.child('users/').push();
  id.set({'id': eyeDee, 'name': userName, 'email': email});
  return id;
}
