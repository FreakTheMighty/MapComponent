library UserModel;

import 'dart:html';
import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart';
import 'package:google_maps/js_wrap.dart' as jsw;

class App {
  User user;
  List<Overlay> overlays;
  
  App(){
    overlays = [];
    user = new User();
  }
  
}

class User {

  LatLng _loc;
  set loc(LatLng loc) => _loc = jsw.retain(loc);
  LatLng get loc => jsw.retain(_loc);

  User(){
    js.scoped(() {
      loc = new LatLng(0,0);
    });
  }

}

class Overlay {
  
  String message;
  LatLng loc;
  
  Overlay(){
    message="Hello World";
    loc = new LatLng(0,0);
  }

}

App _app;

App get app {
  if (_app == null) {
    _app = new App();
  }
  return _app;
}
