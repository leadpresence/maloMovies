import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void closeKeyboard() {
  Future.delayed(Duration.zero, () {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  });
}

void toastError(String message, BuildContext context, {int? seconds}) {
  closeKeyboard();
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message, style: const TextStyle( fontWeight: FontWeight.w700, color: Colors.white)),
    duration: Duration(seconds: seconds ?? 5),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "Close",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void toastMessage(String message, BuildContext context, {int? seconds}) {
  closeKeyboard();
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message, style: const TextStyle( fontWeight: FontWeight.w700, color: Colors.white)),
    duration: Duration(seconds: seconds ?? 5),
    backgroundColor: Colors.blue,
    action: SnackBarAction(
      label: "Close",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void toastSuccess(String message, BuildContext context, {int? seconds}) {
  closeKeyboard();
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message, style: const TextStyle( fontWeight: FontWeight.w700, color: Colors.white)),
    duration: Duration(seconds: seconds ?? 5),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: "Close",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
