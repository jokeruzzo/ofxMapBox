//
//  mapController.h
//  AH002
//
//  Created by Martijn Mellema on 23-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapSubView.h"
#import "ofxiPhoneExtras.h"
#import "ofMain.h"
#import "RMMBTilesSource.h"
#import "RMMapViewDelegate.h"






@interface mapController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, RMMapScrollViewDelegate, RMMapViewDelegate> {
    
    mapSubView * mapView;
    EAGLView *eagleScrollView;
}

@property (nonatomic, retain) IBOutlet mapSubView * mapView;


-(void)loadSource: (RMMBTilesSource *) source;
- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource;
- (id)initWithFrame:(CGRect)frame;
-(mapSubView*) getMapView;
-(void)viewDidLoad;
@end

