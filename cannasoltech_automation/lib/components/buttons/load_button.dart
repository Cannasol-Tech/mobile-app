import 'package:cannasoltech_automation/pages/load_page.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import 'page_button.dart';

Widget loadButton(context) { 
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: SizedBox(
      width: 125,
      height: 50,
      child: PageButton(
        hero: 'loadBtn',
        color: originalConfirmButtonColor,
        buttonText: "Load",
        newPage: const LoadPage(),
        pop: false,
      )
    ),
  );
}
