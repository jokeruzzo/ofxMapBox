//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands


#include "ofMain.h"
#include "RMMapView.h"
#import "RMMBTilesSource.h"
#import "RMMapBoxSource.h"


#include <list>






@class readJSON;

// these are the types you can set for the map



// this is a type, similar to ofPoint, but with better precision for storing latitude and longitude
typedef CLLocationCoordinate2D ofxMapKitLocation;

class RMMapKit  {
public:
	
	RMMapKit();
	virtual ~RMMapKit();
	
	
	// open the mapview
	void open();
    // hide the mapview
	void close();
    
    // offline map
    
	void offlineMap(string map);
    // MBtiles map. If you can host your own map do it with: https://github.com/mapbox/tilestream
    void onlineMap(string url);
    
    void retinaDisplay(bool b);
    
    float metersPerPixel();
    // returns .longitude .latitude
    CLLocationCoordinate2D projectedPointToCoordinate(ofPoint projectedPoint);
	
	// latitude is south/north (-90...90)
	// longitude is east/west (-180...180)
	
	// set center (latitude,longitude) of map
	void setCenter(double latitude, double longitude, bool animated = true);

	
	// enable/disable user interaction
	// if user interaction is not allowed, setAllowZoom / setAllowScroll are ignored
	// if user interaction is allowed, testApp::touchXXXX events will not be called
	void setAllowUserInteraction(bool b);

	// set whether user is allowed to zoom in or not
	void setMapZoom(float zoomLevel);
    
    void setMinZoom (float minZoom);
    void setMaxZoom (float maxZoom);

	// set whether user is allowed to scroll the view or not
	void setAllowScroll(bool b);
    
    void allowZoom(bool b);
	
	// returns whether the user location is visible in the current map region
	bool isUserOnScreen();
	
	// return current center of map (latitude, longitude)
	ofxMapKitLocation getCenterLocation();
	
	
	// convert location (latitude, longitude) to screen coordinates (i.e. pixels)
	ofPoint getScreenCoordinatesForLocation(double latitude, double longitude);
	
	// convert screen coordinates (i.e. pixels) to location (latitude, longitude)
	ofxMapKitLocation getLocationForScreenCoordinates(float x, float y);

	
	
	// convert location (latitude, longitude) and span (in degrees) to screen coordinates (i.e. pixels)
	ofRectangle getScreenRectForRegion(double latitude, double latitudeDelta, double longitudeDelta); 
	
	
	// convert location (latitude, longitude) and span (in meters) to screen coordinates (i.e. pixels)
	ofRectangle getScreenRectForRegionWithMeters(double latitude, double longitude, double metersLatitude, double metersLongitude); 
    
    
    void geoJSON(double fromLatitude, double fromLongitude, double toLatitude, double toLongitude, bool instructions);

	
	// returns whether the map is open or not
	bool isOpen();
	
// listeners
    
   	RMMapView	*getMKMapView();
    
     
    void addMarker(string name, CLLocationCoordinate2D coord, string image);
    // add locations first
    void addRoute(CLLocationCoordinate2D value);
    // start search
    void startRoute();
    
    bool finishRoute();
    vector<CLLocationCoordinate2D> routeData();
    void cleanRoute();
    float getZoom();
    void setScrollEnabled(bool b);
    
protected:
    
    vector <CLLocationCoordinate2D> locationData;
      
    readJSON *jsonRoute;
    RMMBTilesSource *offlineSource;
    RMMapBoxSource *onlineSource;
    bool offline;
    bool initRoute; 
    
    
  
    
	
	CLLocationCoordinate2D makeCLLocation(double latitude, double longitude);
    
  
};

