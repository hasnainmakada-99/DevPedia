import 'package:flutter/material.dart';

Future showAlertDialog({
  required BuildContext context,
  required String titleText,
  required String contentText,
  required VoidCallback onApprove,
  required VoidCallback onReject,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: [
          TextButton(
            onPressed: onReject,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onApprove,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
