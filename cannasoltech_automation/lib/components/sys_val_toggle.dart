import 'package:flutter/material.dart';


Widget sysValToggleButton(context, tag, title, width, activeDevice, sysVal, setMethod) {
  return 
  SizedBox(
    width: width,
    child: Column(
      children: <Widget>[
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        const SizedBox(height: 5),
        SizedBox( 
          width: (2*width/3),
          height: 40,
          child: FloatingActionButton(
            heroTag: tag,
            foregroundColor: Colors.black,
            backgroundColor: (activeDevice != null) ? sysVal.value ? const Color.fromRGBO(0, 198, 50, 100) : const Color.fromRGBO(200, 0, 0, 100) : const Color.fromRGBO(200, 0, 0, 100),
            child:(activeDevice != null) ? sysVal.value ? const Text("On") : const Text("Off") : const Text("Off"),
            onPressed: (){
              if (activeDevice != null){
                sysVal.value = !sysVal.value;
                setMethod(sysVal.value);
              }
            }
          )
        )
      ]
    )
  );
}