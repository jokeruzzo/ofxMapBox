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
    
    ofRegisterGetMessages(this);
    
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
    mapKit.setMapZoom(20,true);
    mapKit.retinaDisplay(true);
    mapKit.onlineMap("http://api.tiles.mapbox.com/v3/examples.map-zr0njcqy.jsonp");
    mapKit.setCenter(POS2_LATITUDE, POS2_LONGITUDE);
    
    // when rotation modified manually, set rotate to UserTrackingModeNone 
    mapKit.rotateUser(UserTrackingModeNone);
     ofxiPhoneSendGLViewToFront();

    rotateCounter +=90;
    mapKit.rotateMap(rotateCounter);
}

//--------------------------------------------------------------
void MapRouteApp::update(){

    userGPSLocation = CLLocationCoordinate2DMake( coreLocation->getLatitude(), coreLocation->getLongitude());
//    cout<<(int)ofGetFrameRa<<endl;
    if ( (int)ofGetFrameNum()%100 == 99)
    {
        rotateCounter +=90;
        cout<<"rotate::"<<rotateCounter<<endl;
         mapKit.rotateMap(rotateCounter);
    }
}

//--------------------------------------------------------------
void MapRouteApp::draw() {
    
    // to get transparent view
    ofBackground(0,0);
    ofRect(10, 10, 0, 10, 10);
    ofFill();
    ofPushMatrix();
    // position of red dot
    ofPoint position =  mapKit.getScreenCoordinatesForLocation(userGPSLocation.latitude,userGPSLocation.longitude);
    
    ofFill();
    ofSetColor(255, 0, 0);
    ofRect(position.x-15, position.y-15, 30,30);
    
    ofRect(ofGetWidth()/2,ofGetHeight()/2,100,100);
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


//--------------------------------------------------------------
void MapRouteApp::gotMessage(ofMessage& msg) {
    
    
    if(ofIsStringInString(msg.message, "TAP:")){
        vector<string> sp = ofSplitString(msg.message, ":");
        tap = ofPoint(ofGetWidth()+ (ofToFloat(sp[1]) * ((IS_RETINA)? 2:1)),
                      ofGetHeight()+(ofToFloat(sp[2]) * ((IS_RETINA)? 2:1)));
        
    }
    
    
}

