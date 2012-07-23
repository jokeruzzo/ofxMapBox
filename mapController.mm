
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 www.martijnmellema.com All rights reserved.
//  Visual conceptual artist / Interaction designer

//

#import "mapController.h"

@interface mapController (

                          
                          
                          )


@end


@implementation mapController{
    
    
}

@synthesize mapView;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
   
        
       
            NSLog (@"loading online map");
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

        self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:offlineSource]; 
        eagleScrollView = iPhoneGetGLView();
        [self.mapView._mapScrollView addSubview:eagleScrollView ];
        [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
        // for the GLView update
        self.mapView._mapScrollView.delegate = self;
        NSLog(@"loading map");
    

    return self;
}




-(void)loadSource: (RMMBTilesSource *) source{
    NSLog(@"inserting map");
   
   
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


-(mapSubView*) getMapView{
    
    return mapView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // updating GLView
   iPhoneGetOFWindow()->timerLoop(); 
    
    // added to hold GLView into place
     eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ofGetWidth()/2, mapView._mapScrollView.contentOffset.y + ofGetHeight()/2);  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



@end
