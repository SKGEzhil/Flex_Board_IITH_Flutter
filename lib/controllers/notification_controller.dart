import 'package:get/get.dart';

import '../models.dart';

class NotificationController extends GetxController {

  var isNotification = false.obs;
  Post post = Post(
    id: '',
    rollNo: '',
    name: '',
    subject: '',
    tags: [''],
    date: '',
    image: '', content: '', cabFrom: '', cabTo: '', cabDate: '', profilePic: '',
  );

}