import "package:flutter/material.dart";

Future<void> showAlert(
  BuildContext context,
  String text,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
