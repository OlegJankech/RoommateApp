import 'package:firebase_database/firebase_database.dart';
import 'debt.dart';

final databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference saveDebt(Debt debt) {
  var id = databaseReference.child('debts/').push();
  id.set(debt.toJson());
  return id;
}

// save a signed up user to a list of users in the database
DatabaseReference saveUser(String name, String email) {
  var id = databaseReference.child('users/').push();
  id.set({'name': name, 'email': email});
  return id;
}

void updateDebt(Debt debt, DatabaseReference id) {
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
