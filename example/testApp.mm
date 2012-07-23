#include "testApp.h"


//--------------------------------------------------------------
void testApp::setup() {
	
	ofxiPhoneSetGLViewTransparent(true);
        mapKit.offlineMap("map");
        mapKit.open();


}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw() {
    
    // to get transparent view
	ofBackground(0,0);
    ofFill();
    
 
 ofEllipse(ofGetWidth()/2, ofGetHeight()/2, 50, 50);
          
      
       
   
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






