import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/api.dart';
import '../widgets/form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    child: Text('Please Log in to continue',
                        style: Theme.of(context).textTheme.titleSmall),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: MyTextField(
                      text: "Username",
                      obscureText: false,
                      icon: Icons.person_outline,
                      textController: _user,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 30),
                    child: MyTextField(
                      text: "Password",
                      obscureText: true,
                      icon: Icons.lock_outline_rounded,
                      textController: _password,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_user.value.text == 'admin' &&
                              _password.value.text == 'admin') {
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/admin-home', (route) => false);
                            return;
                          }
                          try {
                            var response = await api.post(
                              '/login',
                              data: FormData.fromMap({
                                "username": _user.value.text,
                                "password": _password.value.text,
                              }),
                            );
                            final pref = await SharedPreferences.getInstance();

                            await pref.setString(
                                "userId", response.data['user_id']);
                            await pref.setString("name", response.data['name']);
                            await pref.setString("username", _user.value.text);
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          } on DioError catch (e) {
                            // showError(context, e.response?.data['msg']);
                            print(e.response);
                          }
                        }
                      },
                      child: const Text(
                        'LOGIN ',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forget Password',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showError(BuildContext context, String? msg) {
    return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text(msg ?? 'Unexpected Error Ocurred'),
            actions: [
              TextButton(
                onPressed: (() => Navigator.pop(context)),
                child: const Text("Ok"),
              )
            ],
          )),
    );
  }
}
