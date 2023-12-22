import 'package:get/get.dart';

class PostTagController extends GetxController {
  var selectedTags = <String>[].obs;
  var allTags = <String>['Lost and Found', 'Cab Sharing', 'Tag 3', 'Tag 4'].obs;
  var isCabSharing = false.obs;
  var resultTags = <String>[].obs;

  void searchTags(String query) {
    if(query.isEmpty) {
      resultTags.value = allTags.value;
    } else {
      resultTags.value = allTags.value.where((tag) =>
          tag.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    resultTags.value = allTags.value;
  }

  void resetTags() {
    selectedTags.value = [];
  }

  void addTag(String tag_) {
    allTags.value.add(tag_);
  }
}