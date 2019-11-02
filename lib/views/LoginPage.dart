import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_app/services/authentication.dart';

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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      String userId = "";

      userId = await widget.auth.signUp(_email, _password);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "Login",
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
                            "Login",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: validateAndSubmit,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Create an account"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}