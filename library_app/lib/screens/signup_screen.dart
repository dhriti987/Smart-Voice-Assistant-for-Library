import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
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
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                // const Padding(
                //   padding: EdgeInsets.only(top: 15),
                //   child: Text(
                //     'Please Log in to continue',
                //     style: TextStyle(
                //         color: Colors.grey,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15),
                //   ),
                // ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 18),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Sign Up ',
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              }),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
