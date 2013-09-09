//
//  ofxLocation.h
//  artpart
//
//  Created by WeKillBombs on 09-09-13.
//
//

#ifndef __artpart__ofxLocation__
#define __artpart__ofxLocation__

#pragma once
#include <iostream>
#include "ofMain.h"
#include <CoreLocation/CoreLocation.h>



class ofxLocation {
public:
	double latitude;
	double longitude;
    
    //--------------------------------------------------------------
    static   ofxLocation ofxLocationMake(double latitude, double longitude){
        class ofxLocation t;
        t.latitude = latitude;
        t.longitude = longitude;
        
        return t;
    }
    
    //--------------------------------------------------------------
    static ofxLocation ofxLocationMake(CLLocationCoordinate2D loc)
    {
        return ofxLocationMake(loc.latitude, loc.longitude);
    }
    
    //--------------------------------------------------------------
    static bool ofxLocation_EQUAL(ofxLocation coord1,ofxLocation coord2)
    {
        return ((coord1.latitude == coord2.latitude) && (coord1.longitude == coord2.longitude)) ? TRUE:FALSE;
    }
    
    //--------------------------------------------------------------
    
    friend ostream& operator<<(ostream& os, const ofxLocation& vec);
	friend istream& operator>>(istream& is, const ofxLocation& vec);
};





#endif /* defined(__artpart__ofxLocation__) */
