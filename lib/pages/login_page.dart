import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/show_alert.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';
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

class FormWidget extends ConsumerStatefulWidget {
  const FormWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends ConsumerState<FormWidget> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthService authService = ref.read(authNotifierProvider.notifier);
    final SocketService socketService =
        ref.read(socketServiceProvider.notifier);

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
          BlueButton(
            buttonLabel: 'Login',
            onPressed: ref.watch(authNotifierProvider).authenticating
                ? null
                : () async {
                    //to exit the keyboard
                    FocusScope.of(context).unfocus();

                    final bool loginResponse = await authService.login(
                      emailTextController.text.trim(),
                      passwordTextController.text.trim(),
                    );

                    if (loginResponse) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      //Show Alert
                      showAlert(
                        context: context,
                        title: 'Incorrect Login',
                        content: 'Check your credentials',
                      );
                    }
                  },
          )
        ],
      ),
    );
  }
}
