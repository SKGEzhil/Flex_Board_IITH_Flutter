import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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

  Artboard? _riveArtboard;

  void initState() {
    super.initState();
    rootBundle.load('assets/intro.riv').then(
          (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;
        var controller =
        StateMachineController.fromArtboard(artboard, 'Button');
        if (controller != null) {
          artboard.addController(controller);
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/intro.riv',
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
          ),

          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: const SizedBox(
              width: 10,
              height: 10,
            ),
          )),
          Positioned(
            top: 300,
            left: 60,
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
                child: const Text("Get Started")),
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
                            "Text",
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
                                "Text",
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
                            "Text",
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
                                "Text",
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

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final user_text = TextEditingController();

  final password_text = TextEditingController();

  final serverUtils = ServerUtils();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(40))),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  field: "roll_no",
                ),
                RegisterTextField(
                  name_text: password_text,
                  hintText: "Enter your Password",
                  subText: "Password",
                  field: "password",
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    color: isLoading ? Colors.black : Colors.black,
                    onPressed: () async {


                      print(user_text.text);
                      print(password_text.text);

                      if(user_text.text.isEmpty || password_text.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      await serverUtils.login(user_text.text,
                          password_text.text, fcmToken, context);
                      username = await serverUtils.getUsername(user_text.text);
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            semanticsLabel: "Loading",
                            color: Colors.white,
                          )
                        : const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          )),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                            TextSpan(
                                text: "Register",
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 89, 255, 1.0)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
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
                          ])),
                    ),
                  ),
                )
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
          borderRadius: const BorderRadius.all(Radius.circular(40))),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  field: "name",
                ),
                RegisterTextField(
                  name_text: user_text,
                  hintText: "Enter your Roll No",
                  subText: "Roll No",
                  field: "roll_no",
                ),
                RegisterTextField(
                  name_text: email_text,
                  hintText: "Enter your email id",
                  subText: "Email",
                  field: "email",
                ),
                RegisterTextField(
                  name_text: password_text,
                  hintText: "Enter your Password",
                  subText: "Password",
                  field: "password",
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                    onPressed: () async {
                      print(user_text.text);
                      print(password_text.text);

                      if(name_text.text.isEmpty || user_text.text.isEmpty || email_text.text.isEmpty || password_text.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                        return;
                      }

                      await serverUtils.register(
                          name_text.text,
                          user_text.text,
                          email_text.text,
                          password_text.text,
                          fcmToken,
                          context);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 19,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showGeneralDialog(
                        barrierDismissible: true,
                        barrierLabel: "SignIn",
                        context: context,
                        pageBuilder: (context, _, __) => Center(
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: const SignInForm()),
                            ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RichText(
                          text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Sign In",
                              style: const TextStyle(
                                  color: Color.fromRGBO(0, 89, 255, 1.0)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                  showGeneralDialog(
                                      barrierDismissible: true,
                                      barrierLabel: "SignIn",
                                      context: context,
                                      pageBuilder: (context, _, __) => Center(
                                            child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 20, sigmaY: 20),
                                                child: const SignInForm()),
                                          ));
                                })
                        ],
                      )),
                    ),
                  ),
                )
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
    required this.field,
  });

  final TextEditingController name_text;
  final hintText;
  final subText;
  final field;

  Widget TextFieldIcon() {
    switch (field) {
      case "name":
        return Image.asset(
          'assets/profile.png',
          width: 30,
          height: 30,
        );
      case "roll_no":
        return Image.asset(
          'assets/roll_no.png',
          width: 30,
          height: 30,
        );
      case "email":
        return Image.asset(
          'assets/email.png',
          width: 30,
          height: 30,
        );
      case "password":
        return Image.asset(
          'assets/password.png',
          width: 30,
          height: 30,
        );
      default:
        return Image.asset(
          'assets/profile.png',
          width: 30,
          height: 30,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$subText",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  fontSize: 16),
            )),
        TextFormField(
          controller: name_text,
          obscureText: field == 'password' ? true : false,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.3),
              filled: true,
              hintText: "$hintText",
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    width: 0,
                    color: Colors.white.withOpacity(0)), //<-- SEE HERE
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    width: 0,
                    color: Colors.white.withOpacity(0)), //<-- SEE HERE
              ),
              prefixIcon:
                  Padding(padding: EdgeInsets.all(15), child: TextFieldIcon())),
        ),
      ],
    );
  }
}
