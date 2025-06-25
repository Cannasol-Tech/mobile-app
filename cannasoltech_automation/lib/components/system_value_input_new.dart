

import 'invalid_input.dart';
import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/Formatters/formatters.dart';

class SysValInput extends StatefulWidget {
  final double width;
  final dynamic setMethod; 
  final dynamic controller;
  // final String hintText;
  final dynamic minVal;
  final dynamic maxVal;
  final dynamic units;

  const SysValInput({
    super.key,
    required this.width,
    required this.setMethod,
    required this.controller,
    // required this.hintText,
    required this.minVal,
    required this.maxVal,
    required this.units,
  });
  @override
  State<SysValInput> createState() => SysValInputState();
}

class SysValInputState extends State<SysValInput> {
  bool _valid = false;
  String? validateInput(String? input) {
    double inVal = double.tryParse(input.toString()) ?? 00.00;
    if (inVal >= widget.minVal && inVal <= widget.maxVal){
      _valid = true;
    }
    else{
      _valid = false;
      return "Invalid (${widget.minVal} - ${widget.maxVal})";
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      width: widget.width,
      child: TextFormField(
        onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_valid){
              widget.setMethod(widget.controller.text);
            }
            else {
              invalidInputDialog(context, widget.minVal, widget.maxVal);
            }
        },
        
        autovalidateMode: AutovalidateMode.always,
        validator: validateInput,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        controller: widget.controller,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 1), 
                        ],
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color.fromRGBO(22, 90, 126, 245),
          suffixText: widget.units,
          suffixStyle: widget.units != "L/min" ? const TextStyle(fontSize: 16, color: Colors.black) : const TextStyle(fontSize: 10, color: Colors.black),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
            ),
          ),
            onFieldSubmitted: (dynamic submittedVal) {
              if (_valid){
                widget.controller.text = submittedVal.replaceAll(' ', '');
                widget.setMethod(submittedVal);
              }
              else {
                invalidInputDialog(context, widget.minVal, widget.maxVal);
              }
            }
      ),
    );
  }
}