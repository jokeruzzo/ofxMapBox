//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands

#import <UIKit/UIKit.h>

#import "mapSubView.h"
#import "ofxiPhoneExtras.h"
#import "ofMain.h"
#import "RMMBTilesSource.h"
#import "RMMapViewDelegate.h"

#import "RMMapBoxSource.h"



@interface mapController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, RMMapScrollViewDelegate, RMMapViewDelegate> {
    
    mapSubView * mapView;
    EAGLView *eagleScrollView;
   
  
    
    
    
}

@property (nonatomic, retain) IBOutlet mapSubView * mapView;
@property (nonatomic) bool stopZoom;
// adds key
-(void) cloudeMadeAPIKey:(NSString *) key;
-(void) addMarker: (NSString*) name coordinates:(CLLocationCoordinate2D) coord image: (NSString *) image;
//-(void) searchIsFinished:(NSArray*) results inBounds:(BBox*) bounds;

-(void ) searchPlace : (NSString *) place;

-(void)loadSource: (RMMBTilesSource *) source;
- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource;
- (id)initWithFrame:(CGRect)frame;
-(mapSubView*) getMapView;

-(void) searchName : (NSString*) name;
-(void)viewDidLoad;
@end

