import 'package:flutter/material.dart';

Future showAlertDialog({
  required BuildContext context,
  required String text,
  required Function onApprove,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes Sure!'),
            onPressed: () {
              onApprove();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
