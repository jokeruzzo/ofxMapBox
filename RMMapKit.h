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

#pragma once
#include "ofMain.h"
#include "MapBox.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "mapController.h"

#include "ofxLocation.h"





@class readJSON;

// these are the types you can set for the map
// this is a type, similar to ofPoint, but with better precision for storing latitude and longitude
typedef CLLocationCoordinate2D ofxMapKitLocation;

typedef enum : NSUInteger {
    UserTrackingModeNone              = 0,
    UserTrackingModeFollow            = 1,
    UserTrackingModeFollowWithHeading = 2
} UserTrackingMode;




class RMMapKit  {
public:
	
	RMMapKit();
	virtual ~RMMapKit();
    
    
	
	

    // hide the mapview
	void close();
    
    // offline map

	void offlineMap(string map);
    // MBtiles map. If you can host your own map do it with: https://github.com/mapbox/tilestream
    void onlineMap(string url);
    
    void retinaDisplay(bool b);
    
    float metersPerPixel();
    // returns .longitude .latitude
    ofxLocation projectedPointToCoordinate(ofPoint projectedPoint);
	
	// latitude is south/north (-90...90)
	// longitude is east/west (-180...180)
	
	// set center (latitude,longitude) of map
	void setCenter(double latitude, double longitude, bool animated = true);

	// set whether user is allowed to zoom in or not
	void setMapZoom(float zoomLevel,bool animated);
    
    // needs to be fixed
    void setMinZoom (float minZoom);
    // needs to be fixed
    void setMaxZoom (float maxZoom);

	// set whether user is allowed to scroll the view or not
	void setAllowScroll(bool b);
    
    void allowZoom(bool b);
	
	// returns whether the user location is visible in the current map region
	bool isUserOnScreen();
	
	// return current center of map (latitude, longitude)
	ofxLocation getCenterLocation();
	
	
	// convert location (latitude, longitude) to screen coordinates (i.e. pixels)
	ofPoint getScreenCoordinatesForLocation(double latitude, double longitude);
    ofPoint getScreenCoordinatesForLocation(CLLocationCoordinate2D loc);
	
	// convert screen coordinates (i.e. pixels) to location (latitude, longitude)
	ofxLocation getLocationForScreenCoordinates(float x, float y);

	
	
	// convert location (latitude, longitude) and span (in degrees) to screen coordinates (i.e. pixels)
	ofRectangle getScreenRectForRegion(double latitude, double latitudeDelta, double longitudeDelta); 
	
	
	// convert location (latitude, longitude) and span (in meters) to screen coordinates (i.e. pixels)
	ofRectangle getScreenRectForRegionWithMeters(double latitude, double longitude, double metersLatitude, double metersLongitude); 
    
    
    void geoJSON(double fromLatitude, double fromLongitude, double toLatitude, double toLongitude, bool instructions);

	
	// returns whether the map is open or not
	bool isOpen();
	
// listeners
    
   	RMMapView	*getMKMapView();
    
    /*
    For drawing a route 
    */
    void addAnnotation(vector<ofxLocation> coordinates, string routeId);
    
    // not finished yet
    void addImageMarker(ofxLocation coordinate, string routeId, UIImage* image);
    
    
    // just a standard marker
    void addMarker(ofxLocation coordinates, string routeId);
    
    
    // creates route from GEOJSON
    void addGeoJSON(string data);

    // enable/disable annotation
    void setAnnotation(string routeId, bool b);
    
    
    void updateAnnotation(ofxLocation coordinates, string routeId);
    
    // returns if it's possible to zoom
    bool bZoom();
    
    // returns zoom level
    float getZoom();
    // returns if scrolling is enabled
    bool bisScrollEnabled();
    // sets scrolling
    void setScrollEnabled(bool b);
    
    
    void detectRetina();
    double distance(ofxLocation  locBegin, ofxLocation  locEnd);
    
   
    
    
    // projectionPoint converter
    ofxLocation customProjectionPoint(string EPSG,  ofPoint location);

  
    
    bool isUserLocationUpdating();
    ofxLocation getUserLocation();
    void setUserPosition( double degrees, float zoom);
    void setUserPosition( double degrees, ofxLocation loc);
    
    void hideButtons();
    void showButtons();
    
 
    /*
    Rotating the map 
    */
    void rotateMap(double degrees, float seconds);

    void rotateUser(UserTrackingMode mode);
    void rotateMap(double degrees);
    BOOL isRotating();

protected:
    
    vector <CLLocationCoordinate2D> locationData;
      
    readJSON *jsonRoute;
    RMMBTilesSource *offlineSource;
    RMMapBoxSource *onlineSource;
    bool offline;
    bool initRoute;
    
    CLLocationCoordinate2D makeCLLocation(double latitude, double longitude);

};

