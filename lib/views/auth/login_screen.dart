import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFocusNode = FocusNode();
  final _passworldFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: _formData['email'],
                    decoration: InputDecoration(labelText: 'e-mail'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passworldFocusNode);
                    },
                    onSaved: (value) => _formData['email'] = value,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _formData['password'],
                    decoration: InputDecoration(labelText: 'senha'),
                    autocorrect: false,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    onSaved: (value) => _formData['password'] = value,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Informe uma senha válida';
                      }
                      return null;
                    },
                  ),
                  FlatButton(
                    child: Text('Logar'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'cadastrar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text(
                          'Logar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
