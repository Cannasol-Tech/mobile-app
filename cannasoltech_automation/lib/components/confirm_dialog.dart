import 'package:flutter/material.dart';

class YesButton extends StatelessWidget {
  const YesButton({super.key, required this.confirmMethod});
  final void Function() confirmMethod;
  @override
  Widget build (BuildContext context) {
    return TextButton(
      child: const Text("Yes"),
      onPressed: () {
        confirmMethod();
        Navigator.of(context).pop(); // dismiss dialog
      }
    );
  }
} 

class NoButton extends StatelessWidget {
  const NoButton({super.key});
  @override
  Widget build (BuildContext context) {
    return TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      }
    );
  } 
}

confirmDialog(context, confirmMethod, promptText) {  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Notice!"),
    content: Text("Are you sure you want to $promptText?"),
    actions: [YesButton(confirmMethod: confirmMethod), const NoButton()],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
