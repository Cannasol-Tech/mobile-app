
import 'package:flutter/material.dart';

  class OkButton extends StatelessWidget {
    const OkButton({super.key});
    @override build (BuildContext context) {
      return TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.of(context).pop(); // dismiss dialog
        },
      );  
    }
  }
  
showAlertDialog(BuildContext context, String alertText) {
  AlertDialog alert = AlertDialog(
    title: const Text("Notice!"),
    content: Text(alertText),
    actions: const [OkButton()],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}