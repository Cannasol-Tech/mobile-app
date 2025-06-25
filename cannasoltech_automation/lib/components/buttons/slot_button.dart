import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'confirm_button.dart';

Widget saveSlotButton(context, slotIdx) { 
    return  
      SizedBox(
          width: 125,
          height: 40,
          child: ConfirmButton(
          color: const Color.fromARGB(179, 255, 255, 255),
          confirmMethod: Provider.of<SystemDataModel>(context, listen: false)
              .activeDevice?.saveSlots[slotIdx - 1].save as Function,
          confirmText: 'want to overwrite the contents of save slot #$slotIdx',
          buttonText: 'Save Config',
          hero: 'saveCfgBtn_$slotIdx',
        )

      );
}

Widget loadSlotButton(context, slotIdx) { 
    return  
      SizedBox(
          width: 125,
          height: 40,
          child: ConfirmButton(
            color: const Color.fromARGB(179, 255, 255, 255),
            confirmMethod: Provider.of<SystemDataModel>(context, listen: false)
                .activeDevice?.saveSlots[slotIdx - 1].load as Function,
            confirmText: 'want to load the contents of save slot #$slotIdx',
            buttonText: 'Load Config',
            hero: 'loadCfgBtn_$slotIdx',
          )

      );
}
