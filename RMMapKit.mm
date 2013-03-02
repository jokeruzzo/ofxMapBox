//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands
// www.martijnmellema.nl


#include "RMMapKit.h"
#include "readJSON.h"

#pragma mark -  Setup


RMMapKit::RMMapKit() {
	mapView = NULL;
    offline = false;
    bIsRetina = false;
    
}

RMMapKit::~RMMapKit() {
	
	
    
}


void RMMapKit::open() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::open()");
    cout<<"Welcome! visit my website: www.martijnmellema.com"<<endl;
    detectRetina();
    if (offline  == false){
        mapViewController =    [[mapController alloc] initWithFrame: CGRectMake(0, 0,
                                                                                ofGetWidth(),
                                                                                ofGetHeight())];
        mapView = mapViewController.getMapView;
        [mapView setDelegate :mapViewController];
        [ofxiPhoneGetUIWindow() addSubview:mapView];


    }
}



void RMMapKit::removeWebView(){
    [mapViewController removeWeb];
}

RMMapView   *RMMapKit::getMKMapView(){
    
    return mapView;
}

void RMMapKit::detectRetina(){
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) {
        // RETINA DISPLAY
        cout<< " [UIScreen mainScreen] bounds] IS RETINA " <<endl;
        screenSize.size.width = screenSize.size.width * [[UIScreen mainScreen] scale];
        screenSize.size.height = screenSize.size.height * [[UIScreen mainScreen] scale];
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
    [ofxiPhoneGetUIWindow() addSubview:mapView];

}





void RMMapKit::onlineMap(string urlVal){
    
    if ( ofGetWidth() == 640) bIsRetina = true;
    
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


void RMMapKit::close() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::close()");
	[[mapView superview] removeFromSuperview];
}

#pragma mark -  Zoom

void RMMapKit::allowZoom(bool b){
    [mapViewController setZoom:b];
    //mapViewController.setZoom = b;
    
}

float RMMapKit::getZoom(){
  return  [mapViewController getZoom];
    

}

void RMMapKit::setMapZoom(float zoomLevel) {
//	[mapViewController zoom:zoomLevel];
   // mapViewController.zoom = zoomLevel;
}


void RMMapKit::setMinZoom (float minZoom){
 //   [mapViewController setMinZoom:minZoom];
	
 
    
}
void RMMapKit::setMaxZoom (float maxZoom){
  //  [mapViewController setMaxZoom:maxZoom];
  
    
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
    
	CGPoint cgPoint = [mapView coordinateToPixel: makeCLLocation(latitude, longitude)];
    if(bIsRetina){
	return ofPoint(cgPoint.x*2, cgPoint.y*2);
    }
}

#define pi 3.14159265358979323846

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::  This function converts decimal degrees to radians             :*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
double deg2rad(double deg) {
    return (deg * pi / 180);
}

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::  This function converts radians to decimal degrees             :*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
double rad2deg(double rad) {
    return (rad * 180 / pi);
}

double RMMapKit::distance(double lat1, double lon1, double lat2, double lon2, char unit) {
    double theta, dist;
    theta = lon1 - lon2;
    dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    switch(unit) {
        case 'M':
            break;
        case 'K':
            dist = dist * 1.609344;
            break;
        case 'N':
            dist = dist * 0.8684;
            break;
    }
    return (dist);
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
  //  mapView.adjustedZoomForRetinaDisplay = b;
   
    
}


void RMMapKit::setAllowUserInteraction(bool b) {
   
 //   mapView.enableBouncing = b;
  //  mapView.enableDragging = b;
  //  mapView.enableClustering = b;
 //   mapView.zoomingInPivotsAroundCenter = b;
    

}


void RMMapKit::setScrollEnabled(bool b){
  //  cout<<"setScrollEnabled(bool b)"<<b<<endl;
     mapView._mapScrollView.scrollEnabled = b;
}

bool tapOnce = false;

bool RMMapKit::isTapping(){
    
    if ( tapOnce){
        mapViewController.tapping = FALSE;
        tapOnce = false;
        return false;
        
    }
    
    
    if (mapViewController.tapping ){
        
        tapOnce = true;
        return true;
    }
    
    return  false;
}

CGPoint RMMapKit::tapPosition(){
   
  return  mapViewController.startLocation;
   
}


void RMMapKit::artPartLogin(string token){
    [mapViewController artpartLogin: token];
}


