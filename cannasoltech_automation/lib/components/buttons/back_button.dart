import 'package:flutter/material.dart';
import '../../shared/constants.dart';

Widget backButton (context) {
  return
  SizedBox(
    width: 100,
    height: 50,
    child: FloatingActionButton(            
      heroTag: 'backBtn',
      foregroundColor: Colors.black,
      backgroundColor: originalConfirmButtonColor,
      child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: (){
        Navigator.pop(context);
      }
    )
  );
}
