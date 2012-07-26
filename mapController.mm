
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 www.martijnmellema.com All rights reserved.
//  Visual conceptual artist / Interaction designer

//

#import "mapController.h"
#import "RMFoundation.h"


@interface mapController (
                          
                          )


@end


@implementation mapController{
    
    
}

@synthesize mapView;


- (void)viewDidLoad
{
     // VIEWLOAD any retained subviews of the main view
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
   
    NSLog (@"loading online map");
     [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];    
    self.mapView= [[mapSubView  alloc] initWithFrame: frame];
            
    eagleScrollView = iPhoneGetGLView();
    
    [self.mapView._mapScrollView addSubview:eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
        // for the GLView update
    self.mapView._mapScrollView.delegate = self;


    return self;
}



- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource
{
    self = [super init];
        
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:offlineSource]; 
    eagleScrollView = iPhoneGetGLView();
    [self.mapView._mapScrollView addSubview:eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
        // for the GLView update
    self.mapView._mapScrollView.delegate = self;
    NSLog(@"loading map");
    
    return self;
}

-(mapSubView*) getMapView{
    return mapView;
}




- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return mapView._tiledLayersSuperview;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   iPhoneGetOFWindow()->timerLoop(); 
    
    // added to hold GLView into place
     eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ofGetWidth()/2, mapView._mapScrollView.contentOffset.y + ofGetHeight()/2); 
    
    RMProjectedRect planetBounds = self.mapView._projection.planetBounds;
    self.mapView._metersPerPixel = planetBounds.size.width / self.mapView._mapScrollView.contentSize.width;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (mapView._delegateHasBeforeMapMove)
        [self.mapView._delegate beforeMapMove:self.mapView];
        [self.mapView scrollViewWillBeginDecelerating:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && self.mapView._delegateHasAfterMapMove)
        [self.mapView._delegate afterMapMove:self.mapView];
        [self.mapView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
   
    self.mapView._mapScrollViewIsZooming = YES;
    
    if (self.mapView._delegateHasBeforeMapZoom)
        [self.mapView._delegate beforeMapZoom:self.mapView];
        [self.mapView scrollViewWillBeginZooming:scrollView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    self.mapView._mapScrollViewIsZooming = NO;
    
    [self.mapView correctPositionOfAllAnnotations ];
    [self.mapView scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [self.mapView correctPositionOfAllAnnotations];
    
    if (self.mapView._delegateHasAfterMapZoom)
        [self.mapView._delegate afterMapZoom:self.mapView];
    [self.mapView scrollViewDidZoom:scrollView];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



@end
