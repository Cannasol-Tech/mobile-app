import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/Formatters/formatters.dart';


class SystemValInput extends StatelessWidget {
  final double width;
  final dynamic setMethod; 
  final dynamic controller;
  final String hintText;
  final bool obscureText;

  const SystemValInput({
    super.key,
    required this.width,
    required this.setMethod,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      width: width,
      child:
      TextFormField(
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: controller,
        obscureText: obscureText,
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],
        // decoration: InputDecoration(
        //     enabledBorder: const OutlineInputBorder(
        //       borderSide: BorderSide(color: Colors.white),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(color: Colors.grey.shade400),
        //     ),
        //     fillColor: Colors.grey.shade200,
        //     filled: true,
        //     hintText: hintText,
        //     hintStyle: TextStyle(color: Colors.grey[500])),
            onFieldSubmitted: (dynamic submittedVal) {
              controller.text = submittedVal;
              setMethod(submittedVal);
              }
      ),
      );
  }
}