
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 www.martijnmellema.com All rights reserved.
//  Visual conceptual artist / Interaction designer



#include "ofMain.h"

#include "RMMapView.h"
#import "RMMBTilesSource.h"

// these are the types you can set for the map



// this is a type, similar to ofPoint, but with better precision for storing latitude and longitude
typedef CLLocationCoordinate2D ofxMapKitLocation;

class RMMapKit  {
public:
	
	RMMapKit();
	virtual ~RMMapKit();
	
	
	// open the mapview
	void open();
	void offlineMap(string map);
	// hide the mapview
	void close();

	
	// latitude is south/north (-90...90)
	// longitude is east/west (-180...180)
	
	// set center (latitude,longitude) of map
	void setCenter(double latitude, double longitude, bool animated = true);
	
	// set span of map (in degrees)
	void setSpan(double latitudeDelta, double longitudeDelta, bool animated = true);
	
	// set span of map (in meters)
	void setSpanWithMeters(double metersLatitude, double metersLongitude, bool animated = true);

	// set center (latidude, longitude) and span (in degrees)
	void setRegion(double latitude, double longitude, double latitudeDelta, double longitudeDelta, bool animated = true);
	
    void _setRegion(CLLocationCoordinate2D center, RMProjectedSize span, bool animated);
    
	// set center (latidude, longitude) and span (in meters)
	void setRegionWithMeters(double latitude, double longitude, double metersLatitude, double metersLongitude, bool animated = true);
	
	// set the map type (see RMMapKitType above)
	void setType(RMMapKit type );
	
	// set whether user location is visible on the map (as a blue dot)
	void setShowUserLocation(bool b);
	
	// enable/disable user interaction
	// if user interaction is not allowed, setAllowZoom / setAllowScroll are ignored
	// if user interaction is allowed, testApp::touchXXXX events will not be called
	void setAllowUserInteraction(bool b);

	// set whether user is allowed to zoom in or not
	void setAllowZoom(bool b);

	// set whether user is allowed to scroll the view or not
	void setAllowScroll(bool b);
	
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

	
	// returns whether the map is open or not
	bool isOpen();
	
//	void addListener(RMMapKitListener* l);	
//	void removeListener(RMMapKitListener* l);

	void regionWillChange(bool animated);
	void regionDidChange(bool animated);
	void willStartLoadingMap();
	void didFinishLoadingMap();
	void errorLoadingMap(string errorDescription);
	

	// return instance to MKMapView
	RMMapView	*getMKMapView();
	
protected:
	
    RMMBTilesSource *offlineSource;
    bool offline;
	
	CLLocationCoordinate2D makeCLLocation(double latitude, double longitude);
	//MKCoordinateSpan makeMKCoordinateSpan(double latitudeDelta, double longitudeDelta);
	
	//void _setRegion(CLLocationCoordinate2D center, MKCoordinateSpan span, bool animated);
};

