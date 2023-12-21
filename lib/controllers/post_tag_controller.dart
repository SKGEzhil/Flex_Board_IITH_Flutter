import 'package:get/get.dart';

class PostTagController extends GetxController {
  var selectedTags = <String>[].obs;
  var allTags = <String>['Lost and Found', 'Cab Sharing', 'Tag 3', 'Tag 4'].obs;
  var isCabSharing = false.obs;

  void addTag(String tag_) {
    allTags.value.add(tag_);
  }
}