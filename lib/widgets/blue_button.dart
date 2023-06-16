import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({
    required this.buttonLabel,
    this.onPressed,
    super.key,
  });

  final Function()? onPressed; //if its null, it deactivates the button
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      disabledColor: Colors.grey[400],
      shape: const StadiumBorder(),
      elevation: 2,
      color: Colors.blue,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            buttonLabel,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
