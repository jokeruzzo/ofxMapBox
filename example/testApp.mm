#include "testApp.h"

#define POS2_LATITUDE		 52.370216 
#define POS2_LONGITUDE		 4.895168


//--------------------------------------------------------------
void testApp::setup() {
	// transparent view
	ofxiPhoneSetGLViewTransparent(true);
    // reads MBTiles
    mapKit.offlineMap("map");
    
    // online tileSet
//    if (ofxiPhoneGetOFWindow()->isRetinaSupported()){
//        mapKit.onlineMap("http://a.tiles.mapbox.com/v3/justin.map-kswgei2n.jsonp"); // see https://tiles.mapbox.com/justin/map/map-kswgei2n
//        
//    } else{
//        mapKit.onlineMap("http://a.tiles.mapbox.com/v3/justin.map-s2effxa8.jsonp"); // see https://tiles.mapbox.com/justin/map/map-s2effxa8)
//    }
    
    
    mapKit.open();
    //Changes center postion.
    mapKit.setCenter(POS2_LATITUDE, POS2_LONGITUDE);
    
    
    
    
    
}

//--------------------------------------------------------------
void testApp::update(){
    
}

//--------------------------------------------------------------
void testApp::draw() {
    
    // to get transparent view
	ofBackground(0,0);
    ofFill();
    ofPushMatrix();
    // position of red dot (for testing)
    ofPoint position =  mapKit.getScreenCoordinatesForLocation(52.3493,4.92127);
    
    ofFill();
    ofSetColor(255, 0, 0);
    ofCircle(position.x, position.y, 30);
    
    
    ofPopMatrix();      
    
    
}


//--------------------------------------------------------------
void testApp::exit() {
    //
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
    
    
    
    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
    
    
    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
    
    
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){
    
}






