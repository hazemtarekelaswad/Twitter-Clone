import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../verification_screen/verification_screen.dart';

import '../../../themes.dart';

class SignupButton extends StatelessWidget {
  final _formKey;
  const SignupButton(this._formKey);

  /// Calls signup to make api requst and handle the coming response
  void _pressSignupButton(context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setIsEmailTaken(false);
    if (_formKey.currentState!.validate()) {
      log('Name, email, dob: PASSED');
      _formKey.currentState!
          .save(); // to save name, email, dob in user_provider

      userProvider.verifyEmail().then((res) {
        final response = jsonDecode(res.body);
        log(response.toString());
        if (res.statusCode == 200) {
          log('OTP: ${response['OTP']}');
          userProvider.setIsEmailTaken(false);
          Navigator.of(context).pushNamed(VerificationScreen.routeName);
        } else {
          log('Email has already been taken');
          userProvider.setIsEmailTaken(true);
        }
      });
    } else {
      log('Name, email, dob: FAILED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () => _pressSignupButton(context),
        style: CustomButtons.blueButton(isFit: false),
        child: const Text('Sign Up'),
      ),
    );
  }
}
