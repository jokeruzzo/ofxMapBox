/***********************************************************************
 
 Copyright (c) 2008, 2009, Memo Akten, www.memo.tv, Douglas Edric Stanley, www.abstractmachine.net
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/ 


#include "RMMapKit.h"
#include "ofxiPhoneExtras.h"
#include "mapController.h"
#include "mapSubView.h"


static mapController * mapViewController = nil ;
static mapSubView * mapView = nil ;





RMMapKit::RMMapKit() {
	mapView = NULL;
    offline = false;
   }

RMMapKit::~RMMapKit() {
	[mapView release];
	
  
}


void RMMapKit::open() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::open()");
        //removes main view.. or else it's double
    


    
     //   [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    if (offline  == false){   
    mapViewController =    [[mapController alloc] initWithFrame: CGRectMake(0, 0, 
                                                                            ofGetWidth(),
                                                                            ofGetHeight())]; 
     mapView = mapViewController.getMapView;
    [mapView setDelegate :mapViewController]; 
    [ofxiPhoneGetUIWindow() addSubview:mapView];
    }
   

}

void RMMapKit::offlineMap(string map){
    const char * c = map.c_str();
    NSString *NSMap = [NSString stringWithUTF8String:c];
        
    offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:NSMap ofType:@"mbtiles"]]];
        
    offline = true;
    
    mapViewController = [[mapController alloc] initWithFrame: CGRectMake(0, 0, 
                                                                            ofGetWidth(),
                                                                            ofGetHeight()) 
                                                  andTilesource:offlineSource ]; 
    
    mapView = mapViewController.getMapView;
    [mapView setDelegate :mapViewController]; 
    [ofxiPhoneGetUIWindow() addSubview:mapView];
    
    

}


void RMMapKit::close() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::close()");
	[[mapView superview] removeFromSuperview];
}



void RMMapKit::setCenter(double latitude, double longitude, bool animated) {
	CLLocationCoordinate2D center = makeCLLocation(latitude, longitude);
	[mapView setCenterCoordinate:center animated:animated]; 
}

//
//void RMMapKit::setSpan(double latitudeDelta, double longitudeDelta, bool animated) {
//	_setRegion(mapView.center, makeMKCoordinateSpan(latitudeDelta, longitudeDelta), animated);
//}

void RMMapKit::setSpanWithMeters(double metersLatitude, double metersLongitude, bool animated) {
	CGPoint currentCenter	= mapView.center;
	//_setRegion(currentCenter, MKCoordinateRegionMakeWithDistance(currentCenter, metersLatitude, metersLongitude).span, animated);
}
//
//void RMMapKit::setRegion(double latitude, double longitude, double latitudeDelta, double longitudeDelta, bool animated) {
//	_setRegion( makeCLLocation(latitude, longitude), makeMKCoordinateSpan(latitudeDelta, longitudeDelta), animated);
//}


void RMMapKit::setRegionWithMeters(double latitude, double longitude, double metersLatitude, double metersLongitude, bool animated) {
	CLLocationCoordinate2D newCenter = makeCLLocation(latitude, longitude);
//	_setRegion(newCenter,
//               RMProjectedSizeMake(metersLatitude, metersLongitude), animated);
}


void RMMapKit::_setRegion(CLLocationCoordinate2D center, RMProjectedSize span, bool animated) {
    ///RMProjectedRect = 
    //	RMProjectedPoint origin;
	//RMProjectedSize size;
    //CLLocationCoordinate2D centerProjection
	//RMProjectedRect currentRegion = { center, span };
	//[mapView setProjectedBounds:currentRegion animated:animated];
}

//void RMMapKit::setType(RMMapKitType type) {
//	ofLog(OF_LOG_VERBOSE, "RMMapKit::setType");
//	mapView.mapType = type;
//}

void RMMapKit::setShowUserLocation(bool b) {
//	mapView.showsUserLocation = b;
}

void RMMapKit::setAllowUserInteraction(bool b) {
	mapView.userInteractionEnabled = b;
}

void RMMapKit::setAllowZoom(bool b) {
//	mapView.zoomEnabled = b;
}

void RMMapKit::setAllowScroll(bool b) {
	mapView._mapScrollView.scrollEnabled = b;
}

bool RMMapKit::isUserOnScreen() {
//	return mapView.userLocationVisible;
}


CLLocationCoordinate2D RMMapKit::getCenterLocation() {
	return mapView.centerCoordinate;
}


// convert location (latitude, longitude) to screen coordinates (i.e. pixels)
ofPoint RMMapKit::getScreenCoordinatesForLocation(double latitude, double longitude) {
	CGPoint cgPoint = [mapView coordinateToPixel: makeCLLocation(latitude, longitude) ];
	return ofPoint(cgPoint.x, cgPoint.y);
}


ofxMapKitLocation RMMapKit::getLocationForScreenCoordinates(float x, float y) {
	return [mapView pixelToCoordinate:CGPointMake(x, y) ];
}



// convert location (latitude, longitude) and span (in degrees) to screen coordinates (i.e. pixels)
ofRectangle RMMapKit::getScreenRectForRegion(double latitude, double latitudeDelta, double longitudeDelta) {
	ofRectangle r;
	//	- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(UIView *)view
	//	CGRect	cgRect = [mapView convertRegion:
	return r;
}


// convert location (latitude, longitude) and span (in meters) to screen coordinates (i.e. pixels)
ofRectangle RMMapKit::getScreenRectForRegionWithMeters(double latitude, double longitude, double metersLatitude, double metersLongitude) {
	ofRectangle r;
	return r;
}




#define MAX_LATITUDE	89.999
#define MAX_LONGITUDE	179.999

CLLocationCoordinate2D RMMapKit::makeCLLocation(double latitude, double longitude) {
	CLLocationCoordinate2D center = { 
		CLAMP(latitude, -MAX_LATITUDE, MAX_LATITUDE),
		CLAMP(longitude, -MAX_LONGITUDE, MAX_LONGITUDE)		
	};
	return center;
}

//MKCoordinateSpan RMMapKit::makeMKCoordinateSpan(double latitudeDelta, double longitudeDelta) {
//	//MKCoordinateSpan span = { latitudeDelta, longitudeDelta };
//	//return span;
//}


