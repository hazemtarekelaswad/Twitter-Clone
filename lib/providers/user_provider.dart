import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  DateTime _dob = DateTime.now();
  String _password = '';

  set name(name) => _name = name;
  set email(email) => _email = email;
  set dob(dob) => _dob = dob;
  set password(password) => _password = password;

  String get name => _name;
  String get email => _email;
  DateTime get dob => _dob;
  String get password => _password;

  // Todo: should save the data in the DB provided by the backend
  void save() {
    print(_name);
    print(_email);
    print(_dob);
    print(_password);
  }

}
