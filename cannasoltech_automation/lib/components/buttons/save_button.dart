import 'package:flutter/material.dart';
import '../../pages/save_page.dart';
import '../../shared/constants.dart';
import 'page_button.dart';

Widget saveButton(context) { 
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: SizedBox(
      width: 125,
      height: 50,
      child: PageButton(
        hero: 'saveBtn',
        color: originalConfirmButtonColor,
        buttonText: "Save",
        newPage: const SavePage(),
        pop: false,
      )
    ),
  );
}
