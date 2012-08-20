//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands

#import "readJSON.h"


@implementation readJSON{
    
        bool received;
        vector < CLLocationCoordinate2D > values;
        vector<vector <CLLocationCoordinate2D > > receivedData;
   
    CLLocationCoordinate2D  personCoordinates;
    
    string layer;
    string trans;
}

@synthesize value;


- (id)init{
    
    self = [super init];
    if(self)
    {
        received = false;
        layer = "mapnik";
        trans = "motorcar";
        
        //NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
        //[t start];
      
        
    }
    return self;
}

-(void)personLocation : (CLLocationCoordinate2D) coordinates {
    personCoordinates = coordinates;
}

-(void) addLocation : (vector <CLLocationCoordinate2D>) coordinates  instruct:(bool) instruction{
  
    values = coordinates;
    [self performSelectorInBackground:@selector(start) withObject:nil];
    
}

-(void) changeLayer : (string)lay{
    // cn  or mapnik
    layer = lay;
    
}
//motorcar, bicycle or foot
-(void) transport : (string) way{
    if (way == "motorcar"){
        trans = "motorcar";
        
    }
    if (way == "bicycle"){
        trans = "bicycle";
        
    }
    if (way == "foot"){
        trans = "foot";
        
    }
}



-(bool) receivedData{
    if ((received == true) && (receivedData.size() > 0))
        return true;
   // if (received  == false) 
        return false;
}




-(void) start{
    bool instruct;
    instruct = false;
 
    
    ofxJSONElement result;
    
    string personlat = [self toString:personCoordinates.latitude];
    string personlon = [self toString:personCoordinates.longitude];

    
   
    // maxium of two values
    
    for(int  x=0; x< values.size(); x++){
        int counter;
     
        counter = 0;
        receivedData.resize(values.size());
    string pos1lat = [self toString:values[x].latitude];
    string pos1lon = [self toString:values[x].longitude];

    string url;
    if(instruct){
          url = "http://www.yournavigation.org/api/1.0/gosmore.php?format=geojson&flat="+personlat+"&flon="+personlon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v="+trans+"&fast=1&layer="+layer+"&instructions=1";
        
        // Provide cn for using bicycle routing using cycle route
        
        
    }else {
          url = "http://www.yournavigation.org/api/1.0/gosmore.php?format=geojson&flat="+personlat+"&flon="+personlon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v=motorcar&fast=1&layer=mapnik";
        
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
    // if all values are  received, then it's possible
    received = true;
}



-(vector< vector <CLLocationCoordinate2D > > ) dataValues{
    return receivedData;
    
}

-(string)toString: (double) val{
    std::ostringstream strs;
    strs << val;
    std::string str = strs.str();
    
    return str;
    
}




@end
