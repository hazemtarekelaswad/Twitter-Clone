import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/signup_form.dart';

import '../../constants.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          kLogoPath,
          color: kSecondaryColor,
          width: 20,
          height: 20,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: SignupForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
