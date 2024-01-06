import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lost_flutter/controllers/authentication_controller.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/google_auth_controller.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:rive/rive.dart';
import 'package:get/get.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  Artboard? _riveArtboard;

  @override
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
                                    ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                child: RegisterForm()),
                          ));
                },
                color: const Color.fromRGBO(0, 0, 0, 1),
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
                            "Forum",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
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
                                "Hub",
                                style: TextStyle(fontSize: 50),
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
                            "@",
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
                                "IITH",
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
  final roll_no_text = TextEditingController();
  final google_roll_no = TextEditingController();
  final password_text = TextEditingController();
  final serverUtils = ServerUtils();
  final LoadingController loadingController = Get.put(LoadingController());
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());


  bool isLoading = false;

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
                  name_text: roll_no_text,
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

                            print(roll_no_text.text);
                            print(password_text.text);

                            authenticationController.login(roll_no_text.text, password_text.text, context);

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
                    showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            // title: Text('Enter roll to to continue'),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Enter Roll No to continue: ',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                CupertinoTextField(
                                  controller: google_roll_no,
                                  placeholder: 'Roll No',
                                ),
                              ],
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text('Select',
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent)),
                                onPressed: () {
                                  authenticationController.googleSignIn(context);
                                },
                              ),
                            ],
                          );
                        });

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

class RegisterForm extends StatelessWidget {
  RegisterForm({
    super.key,
  });

  final roll_no_text = TextEditingController();
  final google_roll_no = TextEditingController();
  final password_text = TextEditingController();
  final name_text = TextEditingController();
  final email_text = TextEditingController();
  final serverUtils = ServerUtils();
  final LoadingController loadingController = Get.put(LoadingController());
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  // final RegistrationController _registrationController = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
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
                  name_text: roll_no_text,
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
                  height: 25,
                ),
                loadingController.isLoading.value
                    ? const CircularProgressIndicator(
                        semanticsLabel: "Loading",
                        color: Colors.black,
                      )
                    : CupertinoButton(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        onPressed: () async {
                          print(roll_no_text.text);
                          print(password_text.text);

                          authenticationController.register(
                              name_text.text,
                              roll_no_text.text,
                              email_text.text,
                              password_text.text,
                              context);

                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        )),
                const SizedBox(
                  height: 5,
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
                  height: 10,
                ),
                loadingController.isLoading.value
                    ? const CupertinoActivityIndicator()
                    : GestureDetector(
                        onTap: () {

                          authenticationController.googleSignIn(context);

                          // showCupertinoDialog(
                          //     context: context,
                          //     barrierDismissible: true,
                          //     builder: (context) {
                          //       return CupertinoAlertDialog(
                          //         // title: Text('Enter roll to to continue'),
                          //         content: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           children: [
                          //             Align(
                          //               alignment: Alignment.topLeft,
                          //               child: Text(
                          //                 'Enter Roll No to continue: ',
                          //                 style: TextStyle(
                          //                     fontSize: 17,
                          //                     fontWeight: FontWeight.w500),
                          //               ),
                          //             ),
                          //             SizedBox(
                          //               height: 7,
                          //             ),
                          //             CupertinoTextField(
                          //               controller: google_roll_no,
                          //               placeholder: 'Roll No',
                          //             ),
                          //           ],
                          //         ),
                          //         actions: [
                          //           CupertinoDialogAction(
                          //             child: const Text('Cancel',
                          //                 style:
                          //                     TextStyle(color: Colors.black)),
                          //             onPressed: () {
                          //               Navigator.pop(context);
                          //             },
                          //           ),
                          //           CupertinoDialogAction(
                          //             child: loadingController.isLoading.value
                          //                 ? CupertinoActivityIndicator()
                          //                 : Text('Select',
                          //                     style: TextStyle(
                          //                         color:
                          //                             Colors.deepOrangeAccent)),
                          //             onPressed: () async {
                          //               // loadingController.startLoading();
                          //
                          //               authenticationController.googleSignIn(
                          //                   google_roll_no.text, context);
                          //             },
                          //           ),
                          //         ],
                          //       );
                          //     });

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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
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
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  fontSize: 16),
            )),
        TextFormField(
          controller: name_text,
          cursorColor: Colors.deepOrange,
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
                  Padding(padding: const EdgeInsets.all(15), child: TextFieldIcon())),
        ),
      ],
    );
  }
}
