import 'package:flutter/material.dart';

import '../widgets/blue_button.dart';
import '../widgets/custom_input.dart';
import '../widgets/labels_widget.dart';
import '../widgets/logo_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LogoWidget(
                  title: 'Messenger',
                ),
                FormWidget(),
                LabelsWidget(
                  navigateRoute: 'register',
                  labelQuestion: '¿No tienes una cuenta?',
                  gestureDetectorText: 'Crea una ahora!',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            prefixIcon: Icons.mail_outline,
            hintText: 'Email',
            textController: emailTextController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            prefixIcon: Icons.lock_outline,
            hintText: 'Password',
            textController: passwordTextController,
            isPassword: true,
          ),
          const BlueButton(buttonLabel: 'Login')
        ],
      ),
    );
  }
}