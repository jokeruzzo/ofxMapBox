//
//  mapSubView.m
//  ProgrammaticMap
//
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mapSubView.h"





@implementation mapSubView

@synthesize eagleScrollView;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        eagleScrollView = iPhoneGetGLView();
        [self._mapScrollView addSubview:eagleScrollView ];
        [self._mapScrollView bringSubviewToFront:eagleScrollView];

        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame andTilesource:(id<RMTileSource>)newTilesource
{
    self = [super initWithFrame:frame andTilesource:newTilesource];
    if (self) {
        eagleScrollView = iPhoneGetGLView();
        [self._mapScrollView addSubview:eagleScrollView ];
        [self._mapScrollView bringSubviewToFront:eagleScrollView];

    }
    return self;
}


   
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    eagleScrollView.center = CGPointMake(self._mapScrollView.contentOffset.x + ofGetWidth()/2, self._mapScrollView.contentOffset.y + ofGetHeight()/2);  
       
}
@end
