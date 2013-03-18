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


///http://developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/Performance/Performance.html

#include "RMMapKit.h"
#import "proj_api.h"


#pragma mark -  Setup


RMMapKit::RMMapKit() {
	mapView = NULL;
    offline = false;
    bIsRetina = false;
    
}

RMMapKit::~RMMapKit() {
	
	
    
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
    

    mapView = mapViewController.getMapView;
    [mapView setDelegate :mapViewController];
    cout<<"UIWindow size"<<endl;
    cout<< ofGetWidth()<<endl;
    cout<<ofGetHeight()<<endl;
    
    CGRect rect =  ofxiPhoneGetGLView().frame;
    cout<< rect.size.width<<endl;
    cout<< rect.size.height<<endl;
    rect.origin.x = ofGetWidth()/2;
    rect.origin.y = ofGetHeight()/2;
    rect.size.width = ofGetWidth();
    rect.size.height = ofGetHeight();
    
//   CGRect rect2=    ofxiPhoneGetUIWindow().frame;
//    rect2.size.width = ofGetWidth();
//    rect2.size.height = ofGetHeight();
//    ofxiPhoneGetUIWindow().frame = rect2;
   
    cout<<ofxiPhoneGetUIWindow().frame.size.width<<endl;
 //   ofxiPhoneGetGLParentView().frame = rect;
    ofxiPhoneGetGLView().frame = rect;
   // ofxiPhoneGetUIWindow().frame = rect;
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

// zoom levels needs to be fixed


void RMMapKit::setMapZoom(float zoomLevel) {
//	[mapViewController zoom:zoomLevel];
   // mapViewController.zoom = zoomLevel;
    mapView.zoom = zoomLevel;
}



void RMMapKit::setMinZoom (float minZoom){
 //   [mapViewController setMinZoom:minZoom];
	mapView.minZoom = minZoom;
 
    
}
void RMMapKit::setMaxZoom (float maxZoom){
  //  [mapViewController setMaxZoom:maxZoom];
    mapView.maxZoom = maxZoom;
    
}


#pragma mark - rotation of map



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
   // if(bIsRetina){
	return ofPoint(ofGetWidth()/4+(cgPoint.x*2),ofGetHeight()/4+ (cgPoint.y*2));
   // }
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
}


void RMMapKit::setScrollEnabled(bool b){

     mapView._mapScrollView.scrollEnabled = b;
}

//---------------------------

CLLocationCoordinate2D RMMapKit::customProjectionPoint(string EPSG, ofPoint location){
    //the coordinates, in wgs84 (4236) mercator
    double xCoord[1] ;
    double yCoord[1];
    string google =     "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs";
    
    string tilestream = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.4 +lon_0=0.0 +x_0=-33.0 +y_0=250.0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs";
    
    //51,58575, 4,31441 according to google
    //Burgemeester van Loonstraat 87, 4651 CC Steenbergen, Noord-Brabant
    //POINT(80611.568 400184.417)
    
    //POINT(189009.295 427982.276)
    //Berg en Dalseweg 101 + 105, Hunnerberg, Nijmegen
    //51,83998, 5,88020
    //51.6957 5.85877

    //the proj4 representations of the objects
    projPJ source = pj_init_plus((char*)EPSG.c_str());
    projPJ target = pj_init_plus((char*)tilestream.c_str());

    xCoord[0]=  (double)location.x;
    yCoord[0] = (double)location.y;
    
    //xCoord[0] = 189009.295;
    //yCoord[0] = 427982.276;
    
    
   // cout<<location.x<<" : "<<location.y<<endl;
    pj_transform(source,target, 1, 1, xCoord, yCoord, NULL);
   // cout<<xCoord[0]<<" : "<<yCoord[0]<<endl;
    RMProjectedPoint p;
    p.x = xCoord[0];
    p.y = yCoord[0];
    
    
    
    CLLocationCoordinate2D coord = [mapView projectedPointToCoordinate:p];

    pj_free(source);
    pj_free(target);
    
    return coord;
}



void RMMapKit::rotateUser(UserTrackingMode mode ){
    mapView.userTrackingMode =  RMUserTrackingMode(mode);
}



void RMMapKit::rotateMap(double degrees){
     [mapView updateRotation:degrees];
    
}
