library MapNavComponent;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'AppModel.dart';
import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart';
import 'package:google_maps/js_wrap.dart' as jsw;
import 'ComponentMap.dart';

class MapNavComponent extends WebComponent {
  User user;
  String mapQuery="90210";
  ComponentMap map;
  
  String get loc {
    String label;
    js.scoped((){
      label = "${map.center.lat}, ${map.center.lng}";
    });
    return label;
  }
  
  void locate() {
    js.scoped(() {
      Geocoder geocoder = jsw.retain(new Geocoder());

      final address = this.mapQuery;
      final request = new GeocoderRequest()
      ..address = address
      ;
    geocoder.geocode(request, (List<GeocoderResult> results, GeocoderStatus status) {
      if (status == GeocoderStatus.OK) {
        map.center = results[0].geometry.location;
        map.zoom = 20;
      } else {
        window.alert('Geocode was not successful for the following reason: ${status}');
      }
    });
  });
}

}
