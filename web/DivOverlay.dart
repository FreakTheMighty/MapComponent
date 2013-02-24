library DivOverlay;

import 'dart:html';
import 'package:js/js.dart' as js;
import 'package:google_maps/js_wrap.dart' as jsw;
import 'package:google_maps/google_maps.dart';

class DivOverlay extends OverlayView {
  LatLngBounds _bounds;
  Element _element;
  GMap _map;

  DivElement _div;

  DivOverlay(LatLngBounds bounds, Element element, GMap map) : super() {
    set_onAdd(_onAdd);
    set_draw(_draw);
    set_onRemove(_onRemove);
    //this.overlayMouseTarget.appendChild(element);
    // Now initialize all properties.
    _bounds = jsw.retain(bounds);
    _element = element;
    _map = jsw.retain(map);

    // We define a property to hold the image's
    // div. We'll actually create this div
    // upon receipt of the add() method so we'll
    // leave it null for now.
    _div = null;

    // Explicitly call setMap on this overlay
    this.map = map;
  }

  void _onAdd() {

    // Note: an overlay's receipt of add() indicates that
    // the map's panes are now available for attaching
    // the overlay to the map via the DOM.

    // Create the DIV and set some basic attributes.
    final div = new DivElement();
    div.style
      ..border = 'none'
      ..borderWidth = '0px'
      ..position = 'absolute'
      ..width = '100%'
      ..height = '100%'
      ;

    // Create an IMG element and attach it to the DIV.
//    final img = new ImageElement()
//      ..src = _element
//      ;
    _element.style
      ..width = '100%'
      ..height = '100%'
      ..position = 'absolute'
      ;
    div.children.add(_element);

    // Set the overlay's div_ property to this DIV
    _div = div;

    // We add an overlay to a map via one of the map's panes.
    // We'll add this overlay to the overlayImage pane.
    (panes.overlayImage as Element).children.add(_div);
    panes.overlayMouseTarget.nodes.add(_div);
  }
  
  void clicked(var event){
    print("clicked!!");
  }

  void _draw() {
    // Size and position the overlay. We use a southwest and northeast
    // position of the overlay to peg it to the correct position and size.
    // We need to retrieve the projection from this overlay to do this.
    final overlayProjection = this.projection;

    // Retrieve the southwest and northeast coordinates of this overlay
    // in latlngs and convert them to pixels coordinates.
    // We'll use these coordinates to resize the DIV.
    final sw = overlayProjection.fromLatLngToDivPixel(_bounds.southWest);
    final ne = overlayProjection.fromLatLngToDivPixel(_bounds.northEast);

    // Resize the image's DIV to fit the indicated dimensions.
    final div = _div;
    num absoluteWidth = 800;
    div.style
      ..left = '${sw.x}px'
      ..top = '${ne.y}px'
      ..width = '${absoluteWidth}px'
      ..height = '800px'
//      ..width = '${ne.x - sw.x}px'
//      ..height = '${sw.y - ne.y}px'
      ;
//    print(div.width);
      num scale = (ne.x - sw.x)/absoluteWidth;
      print(scale);

    div.style.setProperty("-webkit-transform", "scale(${scale*.004})");
    div.style.setProperty("-webkit-transform-origin", "0% 0%");
    
  }

  void _onRemove() {
    _div.parent.$dom_removeChild(_div);
    _div = null;
  }
}
