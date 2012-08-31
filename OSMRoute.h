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
class OSMRoute : public ofThread {
public:
    
    vector <CLLocationCoordinate2D> locationData;
    vector <CLLocationCoordinate2D> values; // cpp
   // vector <CLLocationCoordinate2D> receivedData; //cpp
    string layer; //cpp
    vector< vector <CLLocationCoordinate2D > > receivedData; //cpp
    
    string trans;
    readJSON *jsonRoute;
    CLLocationCoordinate2D personData;
    CLLocationCoordinate2D personCoordinates;
    bool initRoute ;
    bool getRoutes;
    
    OSMRoute(){
        initRoute = false;
        getRoutes = false;
    }
    
    void addRoute( vector <CLLocationCoordinate2D> value){
        locationData = value;
        values = value;
        
    }
    
    void addPerson(CLLocationCoordinate2D value){
        personData = value;
        personCoordinates = value;
        
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
        trans  = way;
        [jsonRoute transport:way];
    
    }
    
    void stopRoute(){
        getRoutes = false;
        
    }
    
    void closeRoute(){
        
        stopThread(true);
    }
    
    // loads a thread
    void OSMRoute::threadedFunction(){ //cpp
        while(isThreadRunning()) {
    
          layer = "mapnik";
        trans  = "foot";
        bool instruct;
        instruct = false;
        
   
        ofxJSONElement result;
        string personlat;
        string personlon;
        
        if (personCoordinates.latitude > 0  &&  values.size() > 0){
      
        personlat =  ofToString(personCoordinates.latitude);
        personlon = ofToString(personCoordinates.longitude);
   
        
        
        // maxium of two values
        
        for(int  x=0; x< values.size(); x++){
            int counter;
            
            counter = 0;
            receivedData.resize(values.size());
            string pos1lat = ofToString(values[x].latitude);
            string pos1lon = ofToString(values[x].longitude);
            
            string url;
            if(instruct){
                url = "http://www.yournavigation.org/api/1.0/gosmore.php?format=geojson&flat="+personlat+"&flon="+personlon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v="+trans+"&fast=1&layer="+layer+"&instructions=1";
                
                // Provide cn for using bicycle routing using cycle route
                
                
            }else {
                url = "http://www.yournavigation.org/api/1.0/gosmore.php?format=geojson&flat="+personlat+"&flon="+personlon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v="+trans+"&fast=1&layer="+layer;
                
            }
            cout<<url<<endl;
            bool parsingSuccessful;
            parsingSuccessful = result.open(url);
            
            int numCoordinates = result["coordinates"].size();
            if(numCoordinates != counter){
                if ( parsingSuccessful  )
                {
                    receivedData[x].resize(numCoordinates);
                    for(int i=0; i<numCoordinates; i++)
                    {
                        
                        int position = 0;
                        double longitude = result["coordinates"][i][position++].asDouble();
                        double latitude = result["coordinates"][i][position].asDouble();
                        
                        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
                        receivedData[x][i]  = coordinates;
                        
                    }
                }
                else
                {
                    cout  << "Failed to parse COORDINATES" << endl;
                }
            }
        }
            getRoutes = true;
             }
        
        }
        
    }
    
    bool finishRoute(){
        
        // if started routing and 
       
        
        return getRoutes;
        
        
        
    }
    
    void cleanRoute(){
       
        
        jsonRoute = nil;
        
    }
    
    
    vector<vector < CLLocationCoordinate2D > > routeData(){
      //  cout<<"found points"<<receivedData.size()<<endl;
        return  receivedData;
        
    }

    
    
};