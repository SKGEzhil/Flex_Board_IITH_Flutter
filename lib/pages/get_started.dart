import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../widgets/register_form.dart';

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

    // Load the animation file from the assets folder
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
                                    ImageFilter.blur(sigmaX: 75, sigmaY: 75),
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
                            "Flex",
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
                                "Board",
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



