//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands


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

#import "RMAbstractWebMapSource.h"


#include "readJSON.h"




static mapController * mapViewController = nil ;
static mapSubView * mapView = nil ;


#pragma mark -  Setup


RMMapKit::RMMapKit() {
	mapView = NULL;
    offline = false;
    
}

RMMapKit::~RMMapKit() {
	[mapView release];
	
    
}


void RMMapKit::open() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::open()");
    cout<<"Welcome! visit my website: www.martijnmellema.com"<<endl;
    
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
  //  [mapView setDelegate :mapViewController];
    [ofxiPhoneGetUIWindow() addSubview:mapView];
    
    
    
}

void RMMapKit::onlineMap(string urlVal){
    
    offline = true;
    const char * c =  urlVal.c_str();
    NSString *NSMap = [NSString stringWithUTF8String:c];
    NSURL *url = [NSURL URLWithString:NSMap];
    NSLog(@"loading URL: %@",url);
    
    RMMapBoxSource   *onlineSource =    [[RMMapBoxSource alloc] initWithReferenceURL:url ];
    
    
    mapViewController = [[mapController alloc] initWithFrame: CGRectMake(0, 0,
                                                                         ofGetWidth(),
                                                                         ofGetHeight())
                                               andTilesource:onlineSource ];
    
    
    mapView = mapViewController.getMapView;
    [mapView setDelegate :mapViewController];
    [ofxiPhoneGetUIWindow() addSubview:mapView];
    
}
void RMMapKit::designatedMap(string map,CLLocationCoordinate2D centerCoordinate, float zoomLevel, float  
                             
                       setMaxZoomLevel,float setMinZoomLevel,UIImage * backgroundImage){
    
    
    const char * c =  map.c_str();
    
    NSString *NSMap = [NSString stringWithUTF8String:c];
    
    NSURL *url = [NSURL URLWithString:NSMap];
    NSLog(@"loading URL: %@",url);
    
    offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:NSMap ofType:@"mbtiles"]]];
    
    
    mapViewController = [[mapController alloc] initWithFrame:
                                                CGRectMake(0, 0,ofGetWidth(),ofGetHeight())
                                               andTilesource:offlineSource
                                            centerCoordinate:centerCoordinate
                                                   zoomLevel:zoomLevel
                                                maxZoomLevel:setMaxZoomLevel
                                                minZoomLevel:setMinZoomLevel
                                             backgroundImage:backgroundImage];
}

// not yet working
void RMMapKit::addMarker(string name, CLLocationCoordinate2D coord, string image){
    const char * c =  image.c_str();
    NSString *NSimage = [NSString stringWithUTF8String:c];
    const char * d =  name.c_str();
    NSString *NSname = [NSString stringWithUTF8String:d];
    [mapViewController addMarker:NSname coordinates:coord image:NSimage];
    
    
}

void RMMapKit::close() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::close()");
	[[mapView superview] removeFromSuperview];
}

#pragma mark -  Zoom

void RMMapKit::allowZoom(bool b){
    [mapViewController setZoom:b];
    mapViewController.setZoom = b;
    
}

float RMMapKit::getZoom(){
  return  [mapViewController getZoom];
    

}

void RMMapKit::setMapZoom(float zoomLevel) {
//	[mapViewController zoom:zoomLevel];
   // mapViewController.zoom = zoomLevel;
}


void RMMapKit::setMinZoom (float minZoom){
    [mapViewController setMinZoom:minZoom];
	
 
    
}
void RMMapKit::setMaxZoom (float maxZoom){
    [mapViewController setMaxZoom:maxZoom];
  
    
}


#pragma mark - Scroll

void RMMapKit::setAllowScroll(bool b) {
	mapView._mapScrollView.scrollEnabled = b;
}

bool RMMapKit::isMoving(){
    
    return [mapViewController isMoving];
    
}

#pragma mark - Location

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


CLLocationCoordinate2D RMMapKit::projectedPointToCoordinate(ofPoint projectedPoint){
    RMProjectedPoint aPoint;
    aPoint.x = projectedPoint.x;
    aPoint.y = projectedPoint.y;
    return [[mapView projection] projectedPointToCoordinate:aPoint];
    
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



void RMMapKit::setCenter(double latitude, double longitude, bool animated) {
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
	[mapView setCenterCoordinate:center animated:animated];
}



float RMMapKit::metersPerPixel(){
    
    return [mapView metersPerPixel] ;
    
}



#pragma mark - Display

void RMMapKit::retinaDisplay(bool b){
    mapView.adjustTilesForRetinaDisplay = b;
    
}


void RMMapKit::setAllowUserInteraction(bool b) {
   
	mapView.userInteractionEnabled = b;
}


void RMMapKit::setScrollEnabled(bool b){
    
     mapView._mapScrollView.scrollEnabled = b;
}



