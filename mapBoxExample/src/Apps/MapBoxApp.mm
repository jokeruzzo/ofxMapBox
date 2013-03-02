#include "MapBoxApp.h"


#define POS2_LATITUDE		 51.842867
#define POS2_LONGITUDE		 5.854622


//--------------------------------------------------------------
MapBoxApp :: MapBoxApp () {
    cout << "creating MapBoxApp" << endl;
}

//--------------------------------------------------------------
MapBoxApp :: ~MapBoxApp () {
    cout << "destroying MapBoxApp" << endl;
}

//--------------------------------------------------------------
void MapBoxApp::setup() {
    ofBackground(0, 0);
    
	// initialize the accelerometer
	ofxAccelerometer.setup();
    
    // GPS
    coreLocation = new ofxiPhoneCoreLocation();
    
    
	hasGPS = coreLocation->startLocation();
	
	// dump lots of info to console (useful for debugging)
	ofSetLogLevel(OF_LOG_VERBOSE);
	
	ofEnableAlphaBlending();
	
	// load font for displaying info
	font.loadFont("verdana.ttf", 12);
	
    // transparency
    ofxiPhoneSendGLViewToFront();
	ofxiPhoneSetGLViewTransparent(true);
    mapKit.setMapZoom(20);
    mapKit.retinaDisplay(true);
    mapKit.onlineMap("http://api.tiles.mapbox.com/v3/examples.map-zr0njcqy.jsonp");
    mapKit.setCenter(POS2_LATITUDE, POS2_LONGITUDE);
  
    //  ofxiPhoneSendGLViewToFront();

}

//--------------------------------------------------------------
void MapBoxApp::update(){
    //
    //    if (coreLocation->getLocationAccuracy() < 30
    //        && (ofGetFrameNum() < 60)
    //        && (ofGetFrameNum() >55)
    //        &&  coreLocation->getLatitude() != 0 ){
    //
    //
    userGPSLocation = CLLocationCoordinate2DMake( coreLocation->getLatitude(), coreLocation->getLongitude());
    //        mapKit.setCenter(userGPSLocation.latitude, 	userGPSLocation.longitude);
    //
    //
    //    }

}

//--------------------------------------------------------------
void MapBoxApp::draw() {
    
    // to get transparent view
    ofBackground(0,20);
    ofRect(10, 10, 0, 10, 10);
    ofFill();
    ofPushMatrix();
    // position of red dot
    ofPoint position =  mapKit.getScreenCoordinatesForLocation(userGPSLocation.latitude,userGPSLocation.longitude);
    
    ofFill();
    ofSetColor(255, 0, 0);
    ofCircle(position.x, position.y, 30);
    
    
    ofPopMatrix();
}

//--------------------------------------------------------------
void MapBoxApp::exit() {
    //
}

//--------------------------------------------------------------
void MapBoxApp::touchDown(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void MapBoxApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void MapBoxApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void MapBoxApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void MapBoxApp::lostFocus(){

}

//--------------------------------------------------------------
void MapBoxApp::gotFocus(){

}

//--------------------------------------------------------------
void MapBoxApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void MapBoxApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void MapBoxApp::touchCancelled(ofTouchEventArgs& args){

}

