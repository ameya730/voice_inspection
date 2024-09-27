import 'package:flutter/material.dart';
import 'package:voice_poc/pages/01_login/s_login.dart';
import 'package:voice_poc/widgets/buttons/button_with_loader.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final service = LoginService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) => service.setEmail = value,
                    decoration: const InputDecoration(
                      hintText: 'Input email',
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) => service.setPassword = value,
                    decoration: const InputDecoration(
                      hintText: 'Input Password',
                      labelText: 'Password',
                    ),
                  ),
                ),
                WDButtonWithLoad(
                  label: 'Login',
                  callback: () async => await service.loginFn(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
