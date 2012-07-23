//
//  mapSubView.h
//  ProgrammaticMap
//
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"

#import "ofMain.h"
#import "ofxiPhoneExtras.h"




@interface mapSubView : RMMapView<UIScrollViewDelegate, UIGestureRecognizerDelegate, RMMapScrollViewDelegate>{

    
}

@property (nonatomic, retain) IBOutlet EAGLView *eagleScrollView;

@end

