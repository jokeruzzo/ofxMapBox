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
#import <UIKit/UIKit.h>

#import "MapBox.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"









@interface mapController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, RMMapScrollViewDelegate, RMMapViewDelegate, UIScrollViewDelegate> {
    NSArray *permissions;
    RMMapView * mapView;
    EAGLView *eagleScrollView;
    UIButton *loginButton;
    UITapGestureRecognizer *tapGestureRecognizer;
    UIGestureRecognizer *gestureRecognizer;
   
         

    
    
}



@property (nonatomic, retain) RMTileCache *tileCache;
@property (nonatomic, retain)  RMMapView * mapView;
@property (nonatomic) bool setZoom;
@property (nonatomic) bool freeze;
@property (nonatomic) bool bMovingMap;
@property (nonatomic) float valueZoom;
@property (nonatomic)  bool tapping;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) UIButton *loginButton;;
@property (nonatomic, retain) NSTimer *timer;


@property (nonatomic) CGPoint                startLocation;
@property (nonatomic) CGPoint                currentLocation;
@property (nonatomic) CGPoint                endLocation;

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, retain) NSMutableArray *mainMenuItems;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIImageView *profilePhotoImageView;



// adds key

- (void) removeWeb;
-(void) addMarker: (NSString*) name coordinates:(CLLocationCoordinate2D) coord image: (NSString *) image;
//-(void) searchIsFinished:(NSArray*) results inBounds:(BBox*) bounds;
- (void) openWebView:(NSURL*) url;
- (void) artpartLogin : (string) fbToken;
-(void ) searchPlace : (NSString *) place;
- (id)initWithFrame:(CGRect)frame andOnlineTilesource:onlineSource;
-(void)loadSource: (RMMBTilesSource *) source;
- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource;
- (id)initWithFrame:(CGRect)frame;
-(RMMapView*) getMapView;
-(bool)setZoom:(bool) value;
-(void) searchName : (NSString*) name;
-(void)viewDidLoad;
-(float)getZoom;
-(void)setZoomValue:(float) value;


-(bool)isMoving;
@end

