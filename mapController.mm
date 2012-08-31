//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands

#import "mapController.h"
#import "RMFoundation.h"



#import "RMAnnotation.h"
#import "RMMBTilesSource.h"


@interface mapController (
                          
                          
                          
                          )


@end


@implementation mapController{
    
    
}
@synthesize setZoom;
@synthesize mapView;
@synthesize freeze;
@synthesize bMovingMap;



- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
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
    setZoom = true;
    NSLog (@"loading online map");
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    self.mapView= [[mapSubView  alloc] initWithFrame: frame];
    
    eagleScrollView = iPhoneGetGLView();
    
    [self.mapView._mapScrollView addSubview:eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
    // for the GLView update
    self.mapView._mapScrollView.delegate = self;
    
    [self.mapView._mapScrollView release] ;

    
    
    return self;
}


-(bool)setZoom:(bool) value
{
    setZoom = value;
    
}

-(float)getZoom
{
  return  self.mapView.zoom;
    
}


- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource
{
    self = [super init];
    setZoom = true;
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:offlineSource];
    eagleScrollView = iPhoneGetGLView();
    [self.mapView._mapScrollView addSubview: eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront: eagleScrollView];
    // for the GLView update
    self.mapView._mapScrollView.delegate = self;
      
    [self.mapView._mapScrollView release] ;
    
    NSLog(@"loading map");
    
    return self;
}



- (id)initWithFrame:(CGRect)frame andOnlineTilesource:onlineSource
{
    self = [super init];
    setZoom = true;
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    
    self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:onlineSource];
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

-(void) addMarker: (NSString*) name coordinates:(CLLocationCoordinate2D) coord image: (NSString *) image
{
    RMAnnotation *Annotation = [RMAnnotation annotationWithMapView:mapView coordinate:coord andTitle: name];
    Annotation.annotationIcon = [UIImage imageNamed: image];
    [mapView addAnnotation:Annotation];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [eagleScrollView touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [eagleScrollView touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [eagleScrollView touchesEnded:touches withEvent:event];
    
}


// zooming sollution
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    // for zoom stop
    
  //  cout<<setZoom<<endl;
    
    // allow zooming
  
    
    if (setZoom == true){
        return mapView._tiledLayersSuperview;
    } else{
        return  nil;
    }
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    iPhoneGetOFWindow()->timerLoop();
  

//
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
//        && [[UIScreen mainScreen] scale] == 2.0) {
//         eagleScrollView.center = CGPointMake(roundf(mapView._mapScrollView.contentOffset.x + ofGetWidth()/4), roundf(mapView._mapScrollView.contentOffset.y + ofGetHeight()/4));
//    } else {
//         eagleScrollView.center = CGPointMake(roundf(mapView._mapScrollView.contentOffset.x + ofGetWidth()/2), roundf(mapView._mapScrollView.contentOffset.y + ofGetHeight()/2));
//    }
    

    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ofGetWidth()/4, mapView._mapScrollView.contentOffset.y + ofGetHeight()/4);
    } else {
        eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ofGetWidth()/2, mapView._mapScrollView.contentOffset.y + ofGetHeight()/2);
    }
    
   
    
//    RMProjectedRect planetBounds = self.mapView._projection.planetBounds;
//    self.mapView._metersPerPixel = planetBounds.size.width / self.mapView._mapScrollView.contentSize.width;
    
    
    
    
  
}




- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
      ofSendMessage("isZooming");
    [self.mapView correctPositionOfAllAnnotations];
    
    if (self.mapView._delegateHasAfterMapZoom)
        [self.mapView._delegate afterMapZoom:self.mapView];
    [self.mapView scrollViewDidZoom:scrollView];
    
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
     ofSendMessage("scrollViewStop");
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale

{
    ofSendMessage("scrollViewStop");
    
}

-(bool)isMoving{
    
    return bMovingMap;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    bMovingMap = false;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



@end
