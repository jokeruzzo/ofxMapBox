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
#include "ofxJSONElement.h"
#include "ofMain.h"
#include "readJSON.h"
#include "ofxiPhoneExtras.h"
#include "ofxXmlSettings.h"

#include "map.h"

#pragma mark - route
class OSMRoute : public ofThread  {
public:
    
    vector <routeData> locationData;
    vector <routeData> values; // cpp
   // vector <CLLocationCoordinate2D> receivedData; //cpp
    string layer; //cpp
    vector< vector < routeData > > receivedData; //cpp
  
    
    string trans;
    readJSON *jsonRoute;
   
    
    vector<CLLocationCoordinate2D> RouteVenue2D;
    vector < int> httpID;
    ofURLFileLoader routeLoader;
    CLLocationCoordinate2D personData;
    CLLocationCoordinate2D personCoordinates;
    bool initRoute ;
    bool getRoutes;
    int index;
    
    
    
    
    OSMRoute(){
        initRoute = false;
        getRoutes = false;
        
        ofRegisterURLNotification(this);
    }
    
    bool ofxStringStartsWith(string &str, string &key) {
        return str.find(key) == 0;
    }
    
    void urlResponse(ofHttpResponse &httpResponse){
        string name = httpResponse.request.name;
            if(httpResponse.status==200  && (name.find("route") != string::npos) ){  // i.e is it ok
                ofRemoveURLRequest(httpResponse.request.getID());
                string result ;
                ofxXmlSettings XML;
                
                
                if(XML.loadFromBuffer(httpResponse.data.getText())){
                    
                    cout<<"RESPONSE-----"<<endl;
                    XML.copyXmlToString(result);
                    
                   // cout<<result <<endl;
                    XML.pushTag("xml");
                    XML.pushTag("kml");
                    XML.pushTag("Document");
                    XML.pushTag("Folder");
                    XML.pushTag("Placemark");
                    XML.pushTag("LineString");
                    
                    string coordinates = XML.getValue("coordinates", "0",0);
                    
                    vector <string> coordSplit = ofSplitString(coordinates, " ");
                    vector <string> nameSplit = ofSplitString(httpResponse.request.name,":route");
                    int index = ofToInt(nameSplit[0]);
                    if (RouteVenue2D.size() == index) ofRemoveAllURLRequests();
                    receivedData[index].clear();
                    receivedData[index].resize(coordSplit.size());
                
                    
                    for(int x=0; x<coordSplit.size(); x++){
                        
                        vector<string >  latLon = ofSplitString(coordSplit[x], ",");
                        if (latLon.size() > 0){
                        double longitude = ofToDouble(latLon[0]);
                        double latitude = ofToDouble(latLon[1]);
                            cout<<latitude<<endl;
                        
                        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
                        receivedData[index][x].location  = coordinates;
                        }
                        
                    }
                    cout<<coordinates<<endl;
                    
                    
                }
               
            }
        }




    void addRoute( vector <routeData> value){
        locationData = value;
        values = value;
        
    }
    
    void addPerson(CLLocationCoordinate2D value){
        lock();
        personData = value;
        personCoordinates = value;
        unlock();
    }
    void RouteVenueData(vector <CLLocationCoordinate2D> data){
        lock();
         RouteVenue2D = data;
        unlock();
        
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
      //  [jsonRoute transport:way];
    
    }
    
    void stopRoute(){
      
        getRoutes = false;
      
        
    }
    
    void closeRoute(){
        
       // stopThread(true);
    }
    
    // loads a thread
    void start(){ //cpp
        startThread(true,false);
    }
    
   void threadedFunction() {
        
        // ofRemoveAllURLRequests();
       while(isThreadRunning()){
        layer = "mapnik";
        trans  = "foot";
        bool instruct;
        instruct = false;
        
        
        ofxJSONElement result;
        string personlat;
        string personlon;
        
        if (personCoordinates.latitude > 0  &&  RouteVenue2D.size() > 0){
            
            personlat =  ofToString(personCoordinates.latitude);
            personlon = ofToString(personCoordinates.longitude);
            
            
            
            // maxium of two values
            
            for(int  x=0; x< RouteVenue2D.size(); x++){
                index = x;
                receivedData.resize(RouteVenue2D.size());
                string pos1lat = ofToString(RouteVenue2D[x].latitude);
                string pos1lon = ofToString(RouteVenue2D[x].longitude);
                string pos2lat = ofToString(RouteVenue2D[x+1].latitude);
                string pos2lon = ofToString(RouteVenue2D[x+1].longitude);
                string url;
                
                
                
                
                // http://yours.ah.waag.org/gosmore.php?format=geojson&flat=52.215676&flon=5.963946&tlat=52.2573&tlon=6.1799&v=motorcar&fast=1&layer=mapnik
                if ( x == 0){
                    url=  "http://yours.ah.waag.org/gosmore.php?format=geoJSON&flat="+personlat+"&flon="+personlon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v=foot&fast=1&layer=mapnik";
                    cout<<"from person to venue"<<endl;
                } else if (x <  RouteVenue2D.size()-1){
                    url=  "http://yours.ah.waag.org/gosmore.php?format=geoJSON&flat="+pos1lat+"&flon="+pos1lon+"&tlat="+pos2lat+"&tlon="+pos2lon+"&v=foot&fast=1&layer=mapnik";
                }
                
                cout<< "URL : "<<url<<endl;
                
                ofURLFileLoader loader;
                ofxXmlSettings XML;
             
                ofBuffer xmlFromServer = loader.get(url);
                   ofSleepMillis(2000);
                
                string result ;
                
                
                
                if(XML.loadFromBuffer(xmlFromServer.getText())){
                    
                    cout<<"RESPONSE-----"<<endl;
                    XML.copyXmlToString(result);
                    
                    // cout<<result <<endl;
                    XML.pushTag("xml");
                    XML.pushTag("kml");
                    XML.pushTag("Document");
                    XML.pushTag("Folder");
                    XML.pushTag("Placemark");
                    XML.pushTag("LineString");
                    
                    string coordinates = XML.getValue("coordinates", "0",0);
                    
                    vector <string> coordSplit = ofSplitString(coordinates, " ");
                    
                    
                    if (RouteVenue2D.size() == index) ofRemoveAllURLRequests();
                    receivedData[index].clear();
                    receivedData[index].resize(coordSplit.size());
                    
                    
                    for(int x=0; x<coordSplit.size(); x++){
                        
                        vector<string >  latLon = ofSplitString(coordSplit[x], ",");
                        if (latLon.size() > 0){
                            double longitude = ofToDouble(latLon[0]);
                            double latitude = ofToDouble(latLon[1]);
                            cout<<latitude<<endl;
                            
                            CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
                            receivedData[index][x].location  = coordinates;
                        }
                        
                    }
                    //cout<<coordinates<<endl;
                    
                    
                }
                
                
            }
        }
       stopThread();
       }
       
        
    }

    
    bool finishRoute(){
        
        // if started routing and
       
          // if values received then send finished
        if (values.size() == index){
        
            return getRoutes = true;
          
        }
        
        return false;
    }
    
    void cleanRoute(){
       
        
        jsonRoute = nil;
        
    }
    
    
    vector<vector < routeData > > routeData(){
      //  cout<<"found points"<<receivedData.size()<<endl;
        lock();
        return  receivedData;
        unlock();
    }

    
    
};