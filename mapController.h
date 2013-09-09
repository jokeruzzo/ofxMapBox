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









@interface mapController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, RMMapScrollViewDelegate, RMMapViewDelegate, UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    RMMapView * mapView;
   
    UIGestureRecognizer *gestureRecognizer;
}



- (id)initWithFrame:(CGRect)frame andOnlineTilesource:onlineSource;
-(void)loadSource: (RMMBTilesSource *) source;
- (id)initWithFrame:(CGRect)frame andTilesource:source;

-(RMMapView*) getMapView;
-(bool)allowZoom;
-(bool)setZoom:(bool) value;
-(void) searchName : (NSString*) name;
-(void)viewDidLoad;
-(float)getZoom;
-(void)setZoomValue:(float) value;
-(bool)isMoving;

@property (nonatomic, strong) RMTileCache *tileCache;
@property (nonatomic, strong)  RMMapView * mapView;
@property (nonatomic, strong)  UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) bool setZoom;

@property (nonatomic) float valueZoom;
@property (nonatomic)  bool tapping;

@end

