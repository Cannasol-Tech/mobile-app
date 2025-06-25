import 'package:cannasoltech_automation/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

confirmSignOutDialog(context) {
  Widget yesButton = TextButton(
    child: const Text("Yes"),
    onPressed:  () {
    Navigator.of(context).pop(); // dismiss dialog
    FirebaseAuth.instance.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
    },
  );

  Widget noButton = TextButton(
    child: const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Notice!"),
    content: const Text("Are you sure you want to sign out?"),
    actions: [yesButton, noButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget signOutButton (context, color, buttonText, hero) {
  return
    FloatingActionButton(            
      heroTag: "signOutBtn",
      foregroundColor: Colors.black,
      backgroundColor: color,
      child: const Text("Sign Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: (){
          confirmSignOutDialog(context);
        }
  );
}
