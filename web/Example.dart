library Rtifact;

import 'dart:isolate';
import 'dart:async';

import 'package:web_ui/watcher.dart' as watchers;

import 'AppModel.dart';
import 'ComponentMap.dart';
import 'dart:html';
import 'DivOverlay.dart';
import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart';
import 'package:google_maps/js_wrap.dart' as jsw;

ComponentMap map;

void main() {

//  query("#text");
//  query("#postcontent").on.scroll.add(updateLook);

  js.scoped((){
    final mapOptions = new MapOptions()
      ..zoom = 20
      ..center = new LatLng(34.1011, -118.4062)
      ..mapTypeId = MapTypeId.SATELLITE
      ;
      var elem = query("#map");
      map = new ComponentMap(elem, mapOptions);
      jsw.retain(map);
      final swBound = new LatLng(34.0697095, -118.3621191);
      final neBound = new LatLng(34.2697094, -118.0621215);
      final bounds = new LatLngBounds(swBound, neBound);

      //DivOverlay overlay = jsw.retain(new DivOverlay(bounds, query("#postcontent"), map));

  });

  Timer timer;
  timer = new Timer(const Duration(milliseconds: 1000), () {
    Stream<Geoposition> watchPosition = window.navigator.geolocation.watchPosition();
    watchPosition.listen(positionFound, onError: positionNotFound);
    Future<Geoposition> currentPostion = window.navigator.geolocation.getCurrentPosition();
    currentPostion.then(positionFound, onError: positionNotFound);
    timer.cancel();
  });
}

void updateLook(Event event){
  DivElement postElem = query("#postsubmission");
  DivElement target = event.target;
  var scrollNorm = target.scrollTop/target.scrollHeight*80;
  postElem.style.setProperty("box-shadow", "0px 2px 20px rgba(0,0,0,$scrollNorm)");
}

void positionFound(Geoposition event){
  print("Found user's location ${event.coords.latitude}, ${event.coords.longitude}");
  print("Accuracy ${event.coords.accuracy}");
  js.scoped(() {
    LatLng loc = new LatLng(event.coords.latitude, event.coords.longitude);
    map.center = loc;
    app.user.loc = loc;
  });
}

void positionNotFound(error){
  print(error);
  print("Location not found");
}