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
    CLLocationCoordinate2D personData;
    bool initRoute ;
    bool getRoutes;
    
    OSMRoute(){
        initRoute = false;
        getRoutes = false;
    }
    
    void addRoute( vector <CLLocationCoordinate2D> value){
        locationData = value;
        
    }
    
    void addPerson(CLLocationCoordinate2D value){
        personData = value;
        
    }
    
    bool gettingRoutes(){
        return getRoutes;
        
    }
    
    // cn  or mapnik
    void cycleRoutes( bool b){
        if (b){
            [jsonRoute changeLayer:"cn"];
        } else{
            [jsonRoute changeLayer:"mapnik"];
        }
    }
    //motorcar, bicycle or foot
    void transport (string way){
        [jsonRoute transport:way];
    
    }
    
    // loads a thread
    void startRoute(){
        
        
        jsonRoute = [[readJSON alloc] init];
        [jsonRoute personLocation:personData];
        [jsonRoute addLocation:locationData instruct:false];
        
        initRoute = true;
        getRoutes = true;
        
        
    }
    
    bool finishRoute(){
        
        // if started routing and 
        if(initRoute) return [jsonRoute receivedData];
        getRoutes = false;
        
        return false;
        
        
        
    }
    
    void cleanRoute(){
       
        
        jsonRoute = nil;
        
    }
    
    
    vector<vector < CLLocationCoordinate2D > > routeData(){
        cout<<"found points"<<[jsonRoute dataValues].size()<<endl;
        return  [jsonRoute dataValues];
        
    }

    
    
};