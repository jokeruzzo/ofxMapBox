//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands

#include "ofxJSONElement.h"
#include "ofMain.h"
#include "readJSON.h"
#include "ofxiPhoneExtras.h"

#pragma mark - route
class OSMRoute{
public:
    
    vector <CLLocationCoordinate2D> locationData;
    readJSON *jsonRoute;
    bool initRoute ;
    
    
    OSMRoute(){
        initRoute = false;
        
    }
    
    void addRoute(CLLocationCoordinate2D value){
        locationData.push_back(value);
        
    }
    
    // loads a thread
    void startRoute(){
        
        
        jsonRoute = [[readJSON alloc] init];
        
        [jsonRoute addLocation:locationData instruct:false];
        
        initRoute = true;
        
        
        
    }
    
    bool finishRoute(){
        
        // if started routing and 
        if(initRoute) return [jsonRoute receivedData];
        
        return false;
        
        
        
    }
    
    void cleanRoute(){
        
        jsonRoute = nil;
        
    }
    
    
    vector<CLLocationCoordinate2D> routeData(){
        cout<<"found points"<<[jsonRoute dataValues].size()<<endl;
        return  [jsonRoute dataValues];
        
    }

    
    
};