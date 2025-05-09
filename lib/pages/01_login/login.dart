import 'package:flutter/material.dart';
import 'package:voice_poc_other/pages/01_login/s_login.dart';
import 'package:voice_poc_other/widgets/buttons/button_with_loader.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';

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
        persistentFooterButtons: [Text('Version : 1.0.0')],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/inspection.png',
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.fitHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: WDLabel(
                      label: 'Inspection by Speech',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
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
                      obscureText: true,
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
      ),
    );
  }
}
