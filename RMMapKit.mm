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
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))


static mapController * mapViewController = nil ;
static RMMapView * mapView = nil ;


RMMapKit::RMMapKit() {
	mapView = NULL;
    offline = false;

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
    [mapView setShowLogoBug:false];
    [ofxiPhoneGetUIWindow() addSubview:mapView];

}





void RMMapKit::onlineMap(string urlVal){
    

        offline = true;
        
        const char * c =  urlVal.c_str();
        NSString *NSMap = [NSString stringWithUTF8String:c];
        NSURL *url = [NSURL URLWithString:NSMap];
        NSLog(@"loading URL: %@",url);
        
        RMMapBoxSource   *onlineSource =    [[RMMapBoxSource alloc] initWithReferenceURL:url ];

        
        mapViewController = [[mapController alloc] initWithFrame: CGRectMake(0, 30,
                                                                             ofGetWidth(),
                                                                             ofGetHeight())
                                                   andTilesource:onlineSource ];
   
        mapView = mapViewController.getMapView;
        [mapView setDelegate :mapViewController];

  
        [ofxiPhoneGetUIWindow() addSubview:mapView];
        

        mapView = mapViewController.getMapView;
        [mapView setDelegate :mapViewController];
        
        CGRect rect =  ofxiPhoneGetGLView().frame;
        cout<< rect.size.width<<endl;
        cout<< rect.size.height<<endl;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = ofGetWidth();
        rect.size.height = ofGetHeight();
        
        cout<<ofGetWidth()<<endl;
        cout<< ofGetHeight()<<endl;
        
        ofxiPhoneGetGLView().frame = rect;
        [ofxiPhoneGetUIWindow() addSubview:mapView];
    
   
    
}


void RMMapKit::close() {
	ofLog(OF_LOG_VERBOSE, "RMMapKit::close()");
	[[mapView superview] removeFromSuperview];
}

#pragma mark -  Zoom

bool RMMapKit::bZoom(){
return  [mapViewController allowZoom];
}

void RMMapKit::allowZoom(bool b){
    [mapViewController setZoom:b];
}

float RMMapKit::getZoom(){
  return  [mapViewController getZoom];
    

}




void RMMapKit::setMapZoom(float zoomLevel, bool animated = true) {

    [mapView setZoom:zoomLevel animated:animated];
}



void RMMapKit::setMinZoom (float minZoom){
	mapView.minZoom = minZoom;
 
    
}
void RMMapKit::setMaxZoom (float maxZoom){
    mapView.maxZoom = maxZoom;
}


#pragma mark - Scroll

void RMMapKit::setAllowScroll(bool b) {
	mapView._mapScrollView.scrollEnabled = b;
}


#pragma mark - Location



ofxLocation RMMapKit::getCenterLocation() {
	return  ofxLocation::ofxLocationMake(mapView.centerCoordinate);
}


// convert location (latitude, longitude) to screen coordinates (i.e. pixels)
ofPoint RMMapKit::getScreenCoordinatesForLocation(double latitude, double longitude) {
    
	CGPoint cgPoint = [mapView coordinateToPixel: makeCLLocation(latitude, longitude)];
    
    if(IS_RETINA)
    {
        return ofPoint(ofGetWidth()/4+(cgPoint.x*2),ofGetHeight()/4+ (cgPoint.y*2), 0);
    } else{
        return ofPoint(cgPoint.x,cgPoint.y, 0);
    }
    
    
}


// convert location (latitude, longitude) to screen coordinates (i.e. pixels)
ofPoint RMMapKit::getScreenCoordinatesForLocation(CLLocationCoordinate2D loc) {
    
	CGPoint cgPoint = [mapView coordinateToPixel: loc];
    // if(bIsRetina){
	return ofPoint(ofGetWidth()/4+(cgPoint.x*2),ofGetHeight()/4+ (cgPoint.y*2));
    // }
}



double RMMapKit::distance(ofxLocation locBegin, ofxLocation locEnd) {
    double theta, dist;
    theta = locBegin.longitude - locEnd.longitude;
    dist = sin(ofDegToRad(locBegin.latitude)) * sin(ofDegToRad(locEnd.latitude)) + cos(ofDegToRad(locBegin.latitude)) * cos(ofDegToRad(locEnd.latitude)) * cos(ofDegToRad(theta));
    dist = acos(dist);
    dist = ofRadToDeg(dist);
    dist = dist * 60 * 1.1515;
    
return  dist ;
}




ofxLocation RMMapKit::getLocationForScreenCoordinates(float x, float y) {
	return ofxLocation::ofxLocationMake([mapView pixelToCoordinate:CGPointMake(x, y) ]);
}


ofxLocation RMMapKit::projectedPointToCoordinate(ofPoint projectedPoint){
    RMProjectedPoint aPoint;
    aPoint.x = projectedPoint.x;
    aPoint.y = projectedPoint.y;
    return ofxLocation::ofxLocationMake([[mapView projection] projectedPointToCoordinate:aPoint]);
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



void RMMapKit::setCenter(double latitude, double longitude, bool animated ) {

	
	[mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) animated:true];
  
}



float RMMapKit::metersPerPixel(){
    
    return [mapView metersPerPixel];
    
}

void RMMapKit::retinaDisplay(bool b){
    mapView.adjustTilesForRetinaDisplay = b;
}

bool RMMapKit:: bisScrollEnabled(){
    return  mapView._mapScrollView.scrollEnabled;
    
}

void RMMapKit::setScrollEnabled(bool b){

     mapView._mapScrollView.scrollEnabled = b;
}

//-----------------------------------------------

ofxLocation RMMapKit::customProjectionPoint(string EPSG, ofPoint location){
    //the coordinates, in wgs84 (4236) mercator
    double xCoord[1] ;
    double yCoord[1];
    string google =     "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs";
    
    string tilestream = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.4 +lon_0=0.0 +x_0=-33.0 +y_0=250.0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs";
    
    //the proj4 representations of the objects
    projPJ source = pj_init_plus((char*)EPSG.c_str());
    projPJ target = pj_init_plus((char*)tilestream.c_str());

    xCoord[0]=  (double)location.x;
    yCoord[0] = (double)location.y;
    

    pj_transform(source,target, 1, 1, xCoord, yCoord, NULL);
 
    RMProjectedPoint p;
    p.x = xCoord[0];
    p.y = yCoord[0];
    
    
    
    CLLocationCoordinate2D coord = [mapView projectedPointToCoordinate:p];
    ofxLocation returnLocation;
    returnLocation.longitude = coord.longitude;
    returnLocation.latitude = coord.latitude;
    pj_free(source);
    pj_free(target);
   
    
    return returnLocation;
}


#pragma mark - Rotation around center point
//-----------------------------------------------


void RMMapKit::rotateUser(UserTrackingMode mode ){
    mapView.userTrackingMode =  RMUserTrackingMode(mode);
}


//-----------------------------------------------
void RMMapKit::rotateMap(double degrees, float seconds)
{
    
    [mapView rotateUser:degrees rotationTime:seconds];
}




//-----------------------------------------------

void RMMapKit::rotateMap(double degrees){
     [mapView rotateUser:degrees];
    
}
BOOL RMMapKit::isRotating(){
    
    return [mapView isRotatingUser];
}


void RMMapKit::setUserPosition( double degrees, float zoom){
    [mapView rotateUser:degrees zoom:zoom];
}

void RMMapKit::setUserPosition( double degrees, ofxLocation loc){
    [mapView rotateUser:degrees :CLLocationCoordinate2DMake(loc.latitude, loc.longitude)];
}
//-----------------------------------------------

// TODO fix this
void RMMapKit::addMarker(ofxLocation coordinate, string routeId){
  
        NSMutableArray * locations = [NSMutableArray new] ;
        
        
   
            [locations addObject:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]] ;
   
        
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                              coordinate:((CLLocation *)[locations objectAtIndex:0]).coordinate
                                                                andTitle:ofxStringToNSString(routeId)];

        annotation.userInfo = locations;
        
        [annotation setBoundingBoxFromLocations:locations];
        
        [mapView addAnnotation:annotation];
        

        annotation = nil;
   
}


// TODO: fix this
void RMMapKit::addImageMarker(ofxLocation coordinate, string routeId, UIImage* image){
    

    cout<<"RMMAPKIT::"<<"Doesn't work yet"<<endl;
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                                                            andTitle:ofxStringToNSString(routeId)];
    

    annotation.annotationIcon = image;
    annotation.badgeIcon = image;
    

    
    [mapView addAnnotation:annotation];
    
    annotation = nil;
    
}




void RMMapKit::addAnnotation(vector<ofxLocation> coordinates, string routeId){
   
        NSMutableArray * locations = [NSMutableArray new] ;
        
        
        for(int i = 0; i<coordinates.size();i++){
            [locations addObject:[[CLLocation alloc] initWithLatitude:coordinates[i].latitude longitude:coordinates[i].longitude]] ;
        }
        
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                              coordinate:((CLLocation *)[locations objectAtIndex:0]).coordinate
                                                                andTitle:ofxStringToNSString(routeId)];
        
        annotation.userInfo = locations;
        
        [annotation setBoundingBoxFromLocations:locations];
        
        [mapView addAnnotation:annotation];
        annotation = nil;
   
}



void RMMapKit::updateAnnotation(ofxLocation coordinates, string name){
   
        NSMutableArray * locations = [NSMutableArray new] ;
        
        
        
            [locations addObject:[[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude]] ;

        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                              coordinate:((CLLocation *)[locations objectAtIndex:0]).coordinate
                                                                andTitle:ofxStringToNSString(name)];
        
        annotation.userInfo = locations;
        
        [annotation setBoundingBoxFromLocations:locations];
        
        [mapView addAnnotation:annotation];

        annotation = nil;
   
}


//-----------------------------------------------
// todo test this
void RMMapKit::setAnnotation(string routeId, bool b){
    for (RMAnnotation *annotation in mapView.annotations)
        if ( ! annotation.isUserLocationAnnotation)
        {
          
            if ([annotation.title  isEqualToString: ofxStringToNSString(routeId)])
                    annotation.layer.hidden = b;
         
        }
}

void RMMapKit::addGeoJSON(string data){
  
   
    
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[ofxStringToNSString(data) dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0
                                                               error:nil];
    
    

    
    vector<NSString*> tempUserNames;
        for (NSUInteger x = 0; x < [[json objectForKey:@"features"] count] ; x++){
            
         
            
            NSString *name = [[[[json objectForKey:@"features"] objectAtIndex: x ] valueForKeyPath:@"properties.name"] mutableCopy];
   
            NSMutableArray *  points = [[[[[[json objectForKey:@"features"] objectAtIndex: x ] objectForKey:@"geometry"] objectForKey:@"coordinates"] objectAtIndex:0] mutableCopy];

            tempUserNames.push_back(name);

        
            for (NSUInteger i = 0; i < [points count]; i++){
                
                [points replaceObjectAtIndex:i
                                   withObject:[[CLLocation alloc] initWithLatitude:[[[points objectAtIndex:i] objectAtIndex:1] doubleValue]
                                                                         longitude:[[[points objectAtIndex:i] objectAtIndex:0] doubleValue]]];
                
            }
            
           
            RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                              coordinate:((CLLocation *)[points objectAtIndex:0]).coordinate
                                                                andTitle:[NSString stringWithFormat:@"%@%@", @"geoJSON:" , name]];
            
            annotation.userInfo = points;
            [mapView addAnnotation:annotation];
        }
    
    
}


bool RMMapKit::isUserLocationUpdating(){
 for (RMAnnotation *annotation in mapView.annotations)
      if ( annotation.isUserLocationAnnotation)
      {
       
          return true;
      }
     
return true;
}
