#include "MapRouteApp.h"


#define POS2_LATITUDE		 51.842867
#define POS2_LONGITUDE		 5.854622


//--------------------------------------------------------------
MapRouteApp :: MapRouteApp () {
    cout << "creating MapRouteApp" << endl;
}

//--------------------------------------------------------------
MapRouteApp :: ~MapRouteApp () {
    cout << "destroying MapRouteApp" << endl;
}

//--------------------------------------------------------------
void MapRouteApp::setup() {
    ofBackground(0, 0);
    
	// initialize the accelerometer
	ofxAccelerometer.setup();
    
    // GPS
    coreLocation = new ofxiPhoneCoreLocation();
    
    
	hasGPS = coreLocation->startLocation();
	
	// dump lots of info to console (useful for debugging)
	ofSetLogLevel(OF_LOG_VERBOSE);
	
	ofEnableAlphaBlending();
	
    // transparency
    ofxiPhoneSendGLViewToFront();
	ofxiPhoneSetGLViewTransparent(true);
    mapKit.setMapZoom(20);
    mapKit.retinaDisplay(true);
    mapKit.onlineMap("http://api.tiles.mapbox.com/v3/examples.map-zr0njcqy.jsonp");
    mapKit.setCenter(POS2_LATITUDE, POS2_LONGITUDE);
    mapKit.rotateUser(UserTrackingModeFollowWithHeading);
     ofxiPhoneSendGLViewToFront();

}

//--------------------------------------------------------------
void MapRouteApp::update(){

    userGPSLocation = CLLocationCoordinate2DMake( coreLocation->getLatitude(), coreLocation->getLongitude());

}

//--------------------------------------------------------------
void MapRouteApp::draw() {
    
    // to get transparent view
    ofBackground(0,20);
    ofRect(10, 10, 0, 10, 10);
    ofFill();
    ofPushMatrix();
    // position of red dot
    ofPoint position =  mapKit.getScreenCoordinatesForLocation(userGPSLocation.latitude,userGPSLocation.longitude);
    
    ofFill();
    ofSetColor(255, 0, 0);
    ofRect(position.x-15, position.y-15, 30,30);
    
    
    ofPopMatrix();
}

//--------------------------------------------------------------
void MapRouteApp::exit() {
    //
}

//--------------------------------------------------------------
void MapRouteApp::touchDown(ofTouchEventArgs &touch){
        cout<<"DOWN"<<endl;
}

//--------------------------------------------------------------
void MapRouteApp::touchMoved(ofTouchEventArgs &touch){
    cout<<"DOWN"<<endl;

}

//--------------------------------------------------------------
void MapRouteApp::touchUp(ofTouchEventArgs &touch){
    cout<<"DOWN"<<endl;

}

//--------------------------------------------------------------
void MapRouteApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void MapRouteApp::lostFocus(){

}

//--------------------------------------------------------------
void MapRouteApp::gotFocus(){

}

//--------------------------------------------------------------
void MapRouteApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void MapRouteApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void MapRouteApp::touchCancelled(ofTouchEventArgs& args){

}

