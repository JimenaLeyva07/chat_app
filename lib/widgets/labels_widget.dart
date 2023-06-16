import 'package:flutter/material.dart';

class LabelsWidget extends StatelessWidget {
  const LabelsWidget({
    required this.navigateRoute,
    required this.labelQuestion,
    required this.gestureDetectorText,
    super.key,
  });

  final String navigateRoute;
  final String labelQuestion;
  final String gestureDetectorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          labelQuestion,
          style: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, navigateRoute);
          },
          child: Text(
            gestureDetectorText,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
