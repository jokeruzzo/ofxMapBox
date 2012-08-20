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
#import <Foundation/Foundation.h>

#import "ofxJSONElement.h"
#import "RMMapKit.h"



// route me based on YOUR route system from Open streetmaps

@interface readJSON : NSObject

-(void) addLocation : (vector <CLLocationCoordinate2D>) coordinates  instruct:(bool) instruction;

-(id) init;
-(bool) receivedData;
-(vector< vector <CLLocationCoordinate2D > > ) dataValues;
-(void)personLocation : (CLLocationCoordinate2D) coordinates;
-(void) changeLayer : (string)lay;
-(void) transport : (string) way;
@property (nonatomic)  vector < vector <CLLocationCoordinate2D > > value;


@end
