import 'package:get/get.dart';

import '../models/post_model.dart';

class NotificationController extends GetxController {

  /// Observables
  var isNotification = false.obs;

  /// Declarations
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