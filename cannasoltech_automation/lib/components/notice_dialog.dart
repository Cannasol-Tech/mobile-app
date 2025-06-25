import 'package:flutter/material.dart';
  

noticeDialog(context, noticeTitle, noticeContent) {
  Widget okButton = TextButton(
    child: const Text("Ok", style: TextStyle(fontWeight: FontWeight.bold)),
    onPressed:  () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(noticeTitle),
    content: Text(noticeContent),
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
