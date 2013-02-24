library OverlayComponent;

import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'AppModel.dart';
import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart' as gmaps;
import 'package:google_maps/js_wrap.dart' as jsw;
import 'ComponentMap.dart';
import 'DivOverlay.dart';

class OverlayComponent extends WebComponent {
  
  Overlay overlay;
  ComponentMap map;
  gmaps.Marker marker;
  bool hasFocus=false;
  
  void inserted(){
    print("inserted");
    //DivOverlay overlay = DivOverlay()
    final seBound = new gmaps.LatLng(overlay.loc.lat - 1, 
        overlay.loc.lng);
    final neBound = new gmaps.LatLng(overlay.loc.lat, 
        overlay.loc.lng + 1);
    final bounds = new gmaps.LatLngBounds(seBound, neBound);
    print(this.children);
    Element elem = this.children[0].parent;
    DivOverlay divOverlay = jsw.retain(new DivOverlay(bounds, elem, map));
    js.scoped(() {
        marker = new gmaps.Marker(new gmaps.MarkerOptions()
          ..map = map
          ..position = overlay.loc
        );
        jsw.retain(marker);
    });
    window.setTimeout((){elem.style.setProperty("display","inline");}, 10);

  }
    
  void removed(){
    if (this.children.isEmpty == false){
      Element elem = this.children[0].parent;
      new Timer(250, (Timer t) => elem.remove());
      new Timer(250, (Timer t) => js.scoped((){marker.map = null;}));
    }
  }
}
