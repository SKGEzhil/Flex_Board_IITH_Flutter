import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/home.dart';
import 'package:lost_flutter/server_utils.dart';
import 'package:rive/rive.dart';
import 'package:lost_flutter/user_bloc.dart';

class MyRiveAnimation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
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
                              child: Container(
                                height: 500,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.94),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 32),
                                child: Scaffold(
                                  resizeToAvoidBottomInset : false,
                                  backgroundColor: Colors.transparent,
                                  body: SignInForm(),
                                ),
                              ),
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
    return Column(
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
            const SizedBox(
              height: 20,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Roll No",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins",
                      fontSize: 20),
                )),
            TextFormField(
              controller: user_text,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter your Roll no",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromRGBO(0, 0, 0, 1)), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromRGBO(0, 0, 0, 1)), //<-- SEE HERE
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
            const SizedBox(
              height: 20,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins",
                      fontSize: 20),
                )),
            TextFormField(
              controller: password_text,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter your Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(0, 0, 0, 1)), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(0, 0, 0, 1)), //<-- SEE HERE
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/password.png',
                      width: 30,
                      height: 30,
                    ),
                  )),
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
                onPressed: () {

                print(user_text.text);
                print(password_text.text);

                serverUtils.login(user_text.text, password_text.text, context);

                username = user_text.text;
                userBloc.eventSink.add(userAction.getName);

                  // Navigator.pushReplacement(context, MaterialPageRoute(
                  //   builder: (context) => const home(),
                  // ));
                }),
            const SizedBox(
              height: 30,
            ),
          ],
        ))
      ],
    );
  }
}
