import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/widgets/time_tag.dart';
import '../controllers/cab_sharing_controller.dart';

class CabSharingContainer extends StatelessWidget {
   CabSharingContainer({
    super.key, required this.cabDate, required this.cabFrom, required this.cabTo, required this.isCreatePost,

  });

  final cabDate;
  final cabFrom;
  final cabTo;
  final isCreatePost;

  final cabSharingFrom = TextEditingController();
  final cabSharingTo = TextEditingController();
  final CabSharingController cabSharingController = Get.put(CabSharingController());

  void showPopup(context, label){
    showCupertinoDialog(context: context, barrierDismissible: true, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(label == 'From' ? 'From Location' : 'To Location'),
        content: CupertinoTextField(
          controller: label == 'From' ? cabSharingFrom : cabSharingTo,
          placeholder: 'Enter location',
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel',
                style: TextStyle(color: Colors.deepOrangeAccent)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: Text('Select',
                style: TextStyle(color: Colors.deepOrangeAccent)),
            onPressed: () {
              label == 'From' ? cabSharingController.fromLocation.value = cabSharingFrom.text : cabSharingController.toLocation.value = cabSharingTo.text;
              Navigator.pop(context);
            },
          ),
        ],
      );
    });

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.1)
      ),
      child: Padding(
        padding:
        const EdgeInsets.fromLTRB(
            8, 4, 8, 4),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Cab Sharing',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: isCreatePost ? TimeTag() :

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.deepOrange.withOpacity(0.1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 5,),
                            Icon(Icons.time_to_leave,
                              size: 17,),
                            SizedBox(width: 3,),
                            Text(
                              '${cabDate}',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 12),
                            ),
                            SizedBox(width: 5,),

                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onTap: () {
                    if(isCreatePost){
                      showPopup(context, 'From');
                    } else {
                      null;
                    }
                  },
                  child: Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: cabSharingController.fromLocation.value ==
                            'From' && isCreatePost ? Colors.deepOrange
                            .withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 5,),
                            Text(
                              'From : ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),

                            if(isCreatePost)
                              Obx(() =>
                                  Text(
                                    cabSharingController.fromLocation.value ==
                                        'From'
                                        ? 'Select'
                                        : cabSharingController.fromLocation
                                        .value,
                                    style: TextStyle(
                                        color: cabSharingController
                                            .fromLocation.value == 'From'
                                            ? Colors.deepOrangeAccent
                                            : Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),)
                            else
                              Text(
                                '${cabFrom}',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            SizedBox(width: 5,),


                          ],
                        ),
                      ),
                    );
                  }
                  ),
                ),
                SizedBox(height: 5,),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onTap: () {
                    if(isCreatePost){
                      showPopup(context, 'To');
                    } else {
                      null;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      color: cabSharingController.toLocation.value == 'To' && isCreatePost ? Colors.deepOrange.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 5,),
                          Text(
                            'To : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),

                          if(isCreatePost)
                            Obx(() => Text(
                              cabSharingController.toLocation.value == 'To' ? 'Select' : cabSharingController.toLocation.value,
                              style: TextStyle(
                                  color: cabSharingController.toLocation.value == 'To' ? Colors.deepOrangeAccent : Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),)
                          else
                            Text(
                              '${cabTo}',
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          SizedBox(width: 5,),


                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
