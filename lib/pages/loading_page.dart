import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'login_page.dart';
import 'users_page.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: checkLoginState(context, ref),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Center(
            child: Image.asset(
              'assets/loading.gif',
              height: 70.0,
            ),
          );
        },
      ),
    );
  }

  Future<void> checkLoginState(BuildContext context, WidgetRef ref) async {
    final AuthService authService = ref.read(authNotifierProvider.notifier);
    final bool authenticated = await authService.isLoggedIn();

    if (authenticated) {
      // TODO(Jimena): connect to socket service
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsersPage(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(),
          ));
    }
  }
}
