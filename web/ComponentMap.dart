library ComponentMap;

import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart';
import 'package:google_maps/js_wrap.dart' as jsw;
import 'package:web_ui/watcher.dart';
import 'AppModel.dart';

class ComponentMap extends GMap{
  
  bool createState = true;
  
  ComponentMap(var elem, var mapOptions) : super(elem, mapOptions) {
  this.on.centerChanged.add(() {
      dispatch();
    });
  
  this.on.click.add(this.createOverlay);
  }
  
  void createOverlay(MouseEvent event){
    Overlay overlay = new Overlay();
    overlay.loc = jsw.retain(event.latLng);
    app.overlays.add(overlay);
    dispatch();
  }
  
}