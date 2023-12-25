import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/network_connectivity_controller.dart';
import 'package:get/get.dart';

class NoInternet extends StatelessWidget {
  NoInternet({
    super.key,
  });

  final NetworkController networkController = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkController>(builder: (builder) {
      return networkController.connectionType != 0
          ? SizedBox()
          : SafeArea(
          child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red.shade400.withOpacity(0.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No internet connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              )));
    });
  }
}
