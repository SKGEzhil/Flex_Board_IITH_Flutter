import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/widgets/register_form.dart';
import 'package:lost_flutter/widgets/register_text_field.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/google_auth_controller.dart';
import '../controllers/loading_controller.dart';
import '../utils/server_utils.dart';

class SignInForm extends StatelessWidget {
  SignInForm({
    super.key,
  });

  /// Define the controllers for the text fields
  final rollNoText = TextEditingController();
  final googleRollNo = TextEditingController();
  final passwordText = TextEditingController();

  /// Declarations
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final LoadingController loadingController = Get.put(LoadingController());
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                  nameText: rollNoText,
                  hintText: "Enter your Roll No",
                  subText: "Roll No",
                  field: "roll_no",
                ),
                RegisterTextField(
                  nameText: passwordText,
                  hintText: "Enter your Password",
                  subText: "Password",
                  field: "password",
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return loadingController.isLoading.value
                      ? const CircularProgressIndicator(
                          semanticsLabel: "Loading",
                          color: Colors.deepOrangeAccent,
                        )
                      : CupertinoButton(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            print(rollNoText.text);
                            print(passwordText.text);

                            authenticationController.login(
                                rollNoText.text, passwordText.text, context);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          ));
                }),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'OR',
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                Divider(
                  height: 0,
                  color: Colors.black.withOpacity(0.1),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    authenticationController.googleSignIn(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google_icon.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
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
                                      ImageFilter.blur(sigmaX: 50, sigmaY: 50),
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrange),
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
                                                      sigmaX: 50, sigmaY: 50),
                                                  child: RegisterForm()),
                                            ));
                                  })
                          ])),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
