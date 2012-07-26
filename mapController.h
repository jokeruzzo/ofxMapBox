
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 www.martijnmellema.com All rights reserved.
//  Visual conceptual artist / Interaction designer


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


-(void)loadSource: (RMMBTilesSource *) source;
- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource;
- (id)initWithFrame:(CGRect)frame;
-(mapSubView*) getMapView;
-(void)viewDidLoad;
@end

