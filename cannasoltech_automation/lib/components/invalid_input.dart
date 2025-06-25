import 'package:flutter/material.dart';
  

invalidInputDialog(context, minVal, maxVal) {
  Widget okButton = TextButton(
    child: const Text("Ok", style: TextStyle(fontWeight: FontWeight.bold)),
    onPressed:  () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Invalid Input!"),
    content: Text("Please enter a value in the range ($minVal - $maxVal)"),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
