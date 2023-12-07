import 'dart:async';
import 'package:lost_flutter/globals.dart';


enum userAction{
  getName,
  booltrue,
  boolfalse
}

class UserBloc{

  final _stateStreamController = StreamController<String>.broadcast();
  StreamSink<String> get userSink => _stateStreamController.sink;
  Stream<String> get userStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<userAction>.broadcast();
  StreamSink<userAction> get eventSink => _eventStreamController.sink;
  Stream<userAction> get eventStream => _eventStreamController.stream;

  UserBloc(){
    var user = "";
    eventStream.listen((event) {
      if(event == userAction.getName){
        user = username;
      }
      userSink.add(user);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }

}

