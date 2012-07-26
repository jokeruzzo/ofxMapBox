
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 www.martijnmellema.com All rights reserved.
//  Visual conceptual artist / Interaction designer


#include "RMMapKit.h"
#include "ofxiPhoneExtras.h"
#include "mapController.h"
#include "mapSubView.h"

#import "RMOpenStreetMapSource.h"
#import "RMOpenSeaMapLayer.h"
#import "RMMapView.h"
#import "RMMarker.h"
#import "RMCircle.h"
#import "RMProjection.h"
#import "RMAnnotation.h"
#import "RMQuadTree.h"
#import "RMCoordinateGridSource.h"
#import "RMOpenCycleMapSource.h"


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
    
    if (offline  == false){   
    mapViewController =    [[mapController alloc] initWithFrame: CGRectMake(0, 0,                     ofGetWidth(),                  ofGetHeight())]; 
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

void RMMapKit::onlineMap(string urlVal){
 
    offline = true;
    const char * c =  urlVal.c_str();
    NSString *NSMap = [NSString stringWithUTF8String:c];
    NSURL *url = [NSURL URLWithString:NSMap];
    NSLog(@"loading URL: %@",url);
    onlineSource = [[RMMapBoxSource alloc] initWithReferenceURL:(url)];
    
    mapViewController = [[mapController alloc] initWithFrame: CGRectMake(0, 0, 
                                                                         ofGetWidth(),
                                                                         ofGetHeight()) 
                                               andTilesource:onlineSource ]; 

    
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

float RMMapKit::metersPerPixel(){
    
    return [mapView metersPerPixel] ;   

}

CLLocationCoordinate2D RMMapKit::projectedPointToCoordinate(ofPoint projectedPoint){
    RMProjectedPoint aPoint;
    aPoint.x = projectedPoint.x;
    aPoint.y = projectedPoint.y;
    return [[mapView projection] projectedPointToCoordinate:aPoint];
    
}

void RMMapKit::setAllowUserInteraction(bool b) {
	mapView.userInteractionEnabled = b;
}

void RMMapKit::setZoom(float zoomLevel) {
	mapView.zoom = zoomLevel;
}


void RMMapKit::setMinZoom (float minZoom){
    mapView.minZoom=minZoom;
    
}
void RMMapKit::setMaxZoom (float maxZoom){
    mapView.maxZoom = maxZoom;
    
}
void RMMapKit::setAllowScroll(bool b) {
	mapView._mapScrollView.scrollEnabled = b;
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


#define MAX_LATITUDE	89.999
#define MAX_LONGITUDE	179.999

CLLocationCoordinate2D RMMapKit::makeCLLocation(double latitude, double longitude) {
	CLLocationCoordinate2D center = { 
		CLAMP(latitude, -MAX_LATITUDE, MAX_LATITUDE),
		CLAMP(longitude, -MAX_LONGITUDE, MAX_LONGITUDE)		
	};
	return center;
}


