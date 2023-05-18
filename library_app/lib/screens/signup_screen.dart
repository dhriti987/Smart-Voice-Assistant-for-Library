import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:library_app/utilities/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/form_fields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Create new Account',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: MyTextField(
                        text: "Full Name",
                        obscureText: false,
                        icon: Icons.abc_outlined,
                        textController: _name,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
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
                        text: "PASSWORD",
                        obscureText: true,
                        icon: Icons.lock_outline_rounded,
                        textController: _password,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            var response = await api.post(
                              '/sign-up',
                              data: FormData.fromMap({
                                "name": _name.value.text,
                                "username": _user.value.text,
                                "password": _password.value.text,
                              }),
                            );
                            final pref = await SharedPreferences.getInstance();

                            await pref.setString(
                                "userId", response.data['user_id']);
                            await pref.setString("name", response.data['name']);
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          } on DioError catch (e) {
                            showError(context, e.response?.data['msg']);
                          }
                        }
                      },
                      child: const Text(
                        'Sign Up ',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Already Registered? Login',
                          style: Theme.of(context).textTheme.titleSmall),
                    )
                  ],
                ),
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
            title: const Text("Sign Up Failed"),
            content: Text(msg ?? 'Unexpected Error occured'),
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
