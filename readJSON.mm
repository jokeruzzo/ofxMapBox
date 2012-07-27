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
        vector<CLLocationCoordinate2D> receivedData;
}

@synthesize value;


- (id)init{
    
    self = [super init];
    if(self)
    {
        received = false;
        
        //NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
        //[t start];
        
    }
    return self;
}


-(void) addLocation : (vector <CLLocationCoordinate2D>) coordinates  instruct:(bool) instruction{
  
    values = coordinates;
    [self performSelectorInBackground:@selector(start) withObject:nil];
    
}

-(bool) receivedData{
    if ((received == true) && (receivedData.size() > 0))
        return true;
   // if (received  == false) 
        return false;
}




-(void) start{
    
    int counter;
    bool instruct;
    bool parsingSuccessful;
    counter = 0;
    instruct = false;
    parsingSuccessful = false;
    
    ofxJSONElement result;
    

    
   
    // maxium of two values
    string pos0lat = [self toString:values[0].latitude];
    string pos0lon = [self toString:values[0].longitude];
    string pos1lat = [self toString:values[1].latitude];
    string pos1lon = [self toString:values[1].longitude];

    string url;
    if(instruct){
          url = "http://www.yournavigation.org/api/1.0/gosmore.php?format=geojson&flat="+pos0lat+"&flon="+pos0lon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v=motorcar&fast=1&layer=mapnik&instructions=1";
        
        
    }else {
      url = "http://www.yournavigation.org/api/1.0/gosmore.php?format=geojson&flat="+pos0lat+"&flon="+pos0lon+"&tlat="+pos1lat+"&tlon="+pos1lon+"&v=motorcar&fast=1&layer=mapnik";
        
    }
    
    if (result.size() == 0) parsingSuccessful = result.open(url);
    
    int numCoordinates = result["coordinates"].size();
    if(numCoordinates != counter){
        if ( parsingSuccessful  )
        {
            
            
            if (counter == numCoordinates) counter = 0;
            for(int i=0; i<numCoordinates; i++)
            {
                int position = 0;
                double longitude = result["coordinates"][i][position++].asDouble();
                double latitude = result["coordinates"][i][position].asDouble();
                
                CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
                receivedData.push_back(coordinates);
                counter++;
            }
        }
        else
        {
            cout  << "Failed to parse COORDINATES" << endl;
        }
    }
    // if all values are  received, then it's possible
    received = true;
}



-(vector<CLLocationCoordinate2D> ) dataValues{    
    return receivedData;
    
}

-(string)toString: (double) value{
    std::ostringstream strs;
    strs << value;
    std::string str = strs.str();
    
    return str;
    
}




@end
