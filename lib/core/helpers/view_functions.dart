import 'package:flutter/material.dart';

class ViewFunctions {
  static void showCustomSnackBar({
    required BuildContext context,
    required String text,
    bool? hasIcon,
    IconData? iconType,
    Color? iconColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            hasIcon ?? false
                ? Icon(
                    iconType,
                    color: iconColor,
                  )
                : Container(
                    height: 22.0,
                  ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
        elevation: 50,
        backgroundColor: Colors.black,
      ),
    );
  }
}
