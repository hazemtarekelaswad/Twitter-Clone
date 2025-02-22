import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/screens/auth_welcome_screen/auth_welcome_screen.dart';

import '../../constants.dart';
import '../update_password_screen/UpdatePasswordScreen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';

  Future<void> _pressLogoutButton(context) async {
    // if (OAuth.isSignedIn()) OAuth.logout();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.resetAll();
    Auth.token = '';
    Auth.userId = '';
    Auth.email = '';
    Auth.password = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.popUntil(
        context, ModalRoute.withName(AuthWelcomeScreen.routeName));
    Navigator.of(context).pushNamed(AuthWelcomeScreen.routeName);
  }

  void _pressChangePasswordButton(context) {
    Navigator.of(context).pushNamed(UpdatePasswordScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your account'),
            Text(
              Auth.username.isEmpty
                  ? 'You don\'t have a username yet'
                  : '@${Auth.username}',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          TextButton(
            onPressed: () => _pressChangePasswordButton(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: const [
                  Text(
                    'Change your password',
                    style: TextStyle(
                      fontSize: 16,
                      color: kOnPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.blueGrey.shade100),
            ),
          ),
          TextButton(
            onPressed: () => _pressLogoutButton(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: const [
                  Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kWarningColor,
                    ),
                  ),
                ],
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.blueGrey.shade100),
            ),
          ),
        ],
      ),
    );
  }
}
