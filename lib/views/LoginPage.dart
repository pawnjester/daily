import 'dart:math';

import 'package:flutter/material.dart';
import 'package:daily_app/services/authentication.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginPage({this.auth, this.loginCallback});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _isLoginForm;
  String userId = "";
  final logger = Logger();
  BuildContext _scaffoldContext;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      if(_isLoginForm) {
        try {
          userId = await widget.auth.signIn(_email, _password);
          if ( userId != null && userId.length > 0) {
            widget.loginCallback();
          }
        } catch ( error ) {
          Scaffold.of(_scaffoldContext).showSnackBar(
              SnackBar(content: Text("error"),
                duration: Duration(seconds: 5),));
        };
      } else {
        userId = await widget.auth.signUp(_email, _password);
        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }

      }
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoginForm = true;
  }

  Widget buildBody () {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      _isLoginForm == true ? "Login" : "Sign Up",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _email = value.trim(),
                  ),
                  TextFormField(
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                    onSaved: (value) => _password = value.trim(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              _isLoginForm == true ? "Login" : "Sign Up",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: validateAndSubmit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isLoginForm = !_isLoginForm;
                      });
                    },
                    child: Text(
                      _isLoginForm == true ? "Create an account" : "Have an account? Login",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return buildBody();
  }
      ),
    );
  }
}
