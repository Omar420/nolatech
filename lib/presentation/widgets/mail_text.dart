import 'package:flutter/material.dart';

class MailTextWidget extends StatelessWidget {
  const MailTextWidget({
    super.key,
    required this.icon,
    required this.value,
    required this.textStyle,
  });
  final IconData icon;
  final String value;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: textStyle.color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: textStyle,
        ),
      ],
    );
  }
}
