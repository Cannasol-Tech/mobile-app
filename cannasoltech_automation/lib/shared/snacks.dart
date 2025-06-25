import 'package:flutter/material.dart';


SnackBar baseSnack({String msg = '', Color color = Colors.black}) => SnackBar(
    content: Text(
      msg, 
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    showCloseIcon: true,
    closeIconColor: Colors.white54,
    elevation: 10.0,
    clipBehavior: Clip.antiAliasWithSaveLayer,
);

SnackBar greenSnack({String msg = ''}) => baseSnack(
  msg: msg, 
  color: const Color.fromARGB(175, 25, 91, 11)
);

SnackBar redSnack({String msg = ''}) => baseSnack(
  msg: msg, 
  color: const Color.fromARGB(190, 155, 25, 11),
);

SnackBar cantDownloadSnack(almNt) => redSnack(
  msg: "Unable to download file!",
);

SnackBar deviceAlarmSnack(almNt) => redSnack(
  msg: "${almNt.alarmName} alarm on ${almNt.alarmingDevice.name}!",
);

SnackBar passwordResetEmailSnack(email) => greenSnack(
  msg: "Sending password reset email to '$email'",
);

SnackBar emailNotFoundSnack(email) => redSnack(
  msg: "No user with email address '$email' found."
);

SnackBar emailSentSnack(email) => greenSnack(
  msg: "Sending password reset email to '$email'",
);

SnackBar veirifcationSentSnack(email) => greenSnack(msg: "Verification Email sent to '$email'!");

SnackBar emailVerifiedSnack = greenSnack(msg: "Email already verified!"); 

SnackBar pleaseVerifyEmailSnack = redSnack(msg: "Verify Email to enable email alerts!");

SnackBar startingDeviceSnack(name) => greenSnack(msg: "Starting system $name, this may take a few seconds...");

SnackBar deviceDoesNotExistSnack(String id) => redSnack(msg: "Device '$id' does not exist!");

SnackBar deviceAlreadyRegisteredSnack(String name) => redSnack(msg: "Device '$name' has already been registered!");

SnackBar deviceRegisteredSnack(String name) => greenSnack(msg: "Successfully registered Device '$name'!");

SnackBar alarmIgnoredSnack(String deviceName, String alarmName) => greenSnack(msg: "Ignored $alarmName alarm on device $deviceName");

SnackBar scanErrorSnack() => redSnack(msg: "Failed to scan device QR code. Please try again.");
