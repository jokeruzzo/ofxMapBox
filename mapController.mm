//
//  mapController.m
//  AH002
//
//  Created by Martijn Mellema on 23-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mapController.h"

@interface mapController (

                          
                          
                          )


@end


@implementation mapController{
    
    RMMBTilesSource  *offlineSource;
}


@synthesize  offlineSource;
@synthesize mapView;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
   
        
        if (offlineSource  == NULL){
            NSLog (@"loading online map");
        self.mapView= [[mapSubView  alloc] initWithFrame: frame];
            
            
            eagleScrollView = iPhoneGetGLView();
            [self.mapView._mapScrollView addSubview:eagleScrollView ];
            [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
            // for the GLView update
            self.mapView._mapScrollView.delegate = self;
        }else {
            self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:offlineSource]; 
            eagleScrollView = iPhoneGetGLView();
            [self.mapView._mapScrollView addSubview:eagleScrollView ];
            [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
            // for the GLView update
            self.mapView._mapScrollView.delegate = self;
            NSLog(@"loading map");
        }
  
    
        

    return self;
}



-(void)loadSource: (RMMBTilesSource *) source{
    NSLog(@"inserting map");
    offlineSource = source;
   
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


-(mapSubView*) getMapView{
    
    return mapView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   iPhoneGetOFWindow()->timerLoop();
     eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ofGetWidth()/2, mapView._mapScrollView.contentOffset.y + ofGetHeight()/2);  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



@end
