import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';
import 'package:rive/rive.dart';

class GetStarted extends StatefulWidget {
  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    int number = await SharedPrefs().checkFirstLaunch();
    print(number);
    if (number == 0) {
      roll_no_ = await SharedPrefs().getRollNo();
      username = await SharedPrefs().getUsername();
      print('roll_no_ = $roll_no_');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/shapes.riv',
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox(
              width: 10,
              height: 10,
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: CupertinoButton(
                  onPressed: () {
                    showGeneralDialog(
                        barrierDismissible: true,
                        barrierLabel: "SignIn",
                        context: context,
                        pageBuilder: (context, _, __) => Center(
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: RegisterForm()),
                            ));
                  },
                  color: Color.fromRGBO(0, 0, 0, 1),
                  borderRadius: BorderRadius.circular(20),
                  child: Text("Get Started")),
            ),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Find",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Yours",
                                style: TextStyle(fontSize: 60),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "With",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 43,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Ease",
                                style: TextStyle(
                                    fontSize: 43, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class SignInForm extends StatelessWidget {
  SignInForm({
    super.key,
  });

  final user_text = TextEditingController();
  final password_text = TextEditingController();
  final serverUtils = ServerUtils();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Sign In",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 37),
              ),
            ),
            Form(
                child: Column(
              children: [
                RegisterTextField(
                  name_text: user_text,
                  hintText: "Enter your Roll No",
                  subText: "Roll No",
                ),
                RegisterTextField(
                  name_text: password_text,
                  hintText: "Enter your Password",
                  subText: "Password",
                ),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                    onPressed: () async {
                      print(user_text.text);
                      print(password_text.text);

                      await serverUtils.login(
                          user_text.text, password_text.text, context);
                      username = await serverUtils.getUsername(user_text.text);
                    }),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                    text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                          text: "Register",
                          style:
                              TextStyle(color: Color.fromRGBO(0, 89, 255, 1.0)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showGeneralDialog(
                                  barrierDismissible: true,
                                  barrierLabel: "SignIn",
                                  context: context,
                                  pageBuilder: (context, _, __) => Center(
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 20, sigmaY: 20),
                                            child: RegisterForm()),
                                      ));
                            })
                    ]))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  RegisterForm({
    super.key,
  });

  final user_text = TextEditingController();
  final password_text = TextEditingController();
  final name_text = TextEditingController();
  final email_text = TextEditingController();
  final serverUtils = ServerUtils();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 37),
            ),
          ),
          Form(
            child: Column(
              children: [
                RegisterTextField(
                  name_text: name_text,
                  hintText: "Enter your name",
                  subText: "Name",
                ),
                RegisterTextField(
                  name_text: user_text,
                  hintText: "Enter your Roll No",
                  subText: "Roll No",
                ),
                RegisterTextField(
                  name_text: email_text,
                  hintText: "Enter your email id",
                  subText: "Email",
                ),
                RegisterTextField(
                  name_text: password_text,
                  hintText: "Enter your Password",
                  subText: "Password",
                ),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                    onPressed: () async {
                      print(user_text.text);
                      print(password_text.text);

                      // await serverUtils.login(
                      //     user_text.text, password_text.text, context);

                      await serverUtils.register(name_text.text, user_text.text,
                          email_text.text, password_text.text, context);

                      username = await serverUtils.getUsername(user_text.text);
                    }),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                    text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: "Sign In",
                        style:
                            TextStyle(color: Color.fromRGBO(0, 89, 255, 1.0)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            showGeneralDialog(
                                barrierDismissible: true,
                                barrierLabel: "SignIn",
                                context: context,
                                pageBuilder: (context, _, __) => Center(
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 20, sigmaY: 20),
                                          child: SignInForm()),
                                    ));
                          })
                  ],
                ))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    super.key,
    required this.name_text,
    this.hintText,
    this.subText,
  });

  final TextEditingController name_text;
  final hintText;
  final subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$subText",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: "Poppins",
                  fontSize: 20),
            )),
        TextFormField(
          controller: name_text,
          decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.3),
              filled: true,
              hintText: "$hintText",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                    width: 1, color: Color.fromRGBO(0, 0, 0, 1)), //<-- SEE HERE
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                    width: 1, color: Color.fromRGBO(0, 0, 0, 1)), //<-- SEE HERE
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset(
                  'assets/profile.png',
                  width: 30,
                  height: 30,
                ),
              )),
        ),
      ],
    );
  }
}
