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

#import "mapController.h"



#include "map.h"


@interface mapController(){
   

}

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end


@implementation mapController

@synthesize setZoom;
@synthesize mapView;


@synthesize valueZoom;
@synthesize tapping;
@synthesize tapGestureRecognizer;





bool isRetina;


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


-(bool)allowZoom{
    
    return setZoom;
}

-(bool)setZoom:(bool) value
{
    setZoom = value;
    return setZoom;
}

-(float)getZoom
{
  return  self.mapView.zoom;
    
}

-(void)setZoomValue:(float) value
{
    
    valueZoom = value;
}


- (id)initWithFrame:(CGRect)frame andTilesource:source
{
    self = [super init];
    setZoom = true;
  

     if (self) {
         
         [self.mapView._mapScrollView setContentOffset:CGPointZero];
         [self.segmentedControl addTarget:self action:@selector(toggleMode:) forControlEvents:UIControlEventValueChanged];
         [self.segmentedControl setSelectedSegmentIndex:0];
         
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
         
         self.mapView= [[RMMapView  alloc] initWithFrame: frame  andTilesource:source];
         
      
         // detects if there's a retina screen
         
         if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
             ([UIScreen mainScreen].scale == 2.0)) {
             isRetina = true;
             
             self.mapView.adjustTilesForRetinaDisplay = YES;
         
             self.mapView.frame = self.view.bounds;
             self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         
         }  else{
             
             isRetina = false;
         }

     
      
         
         iPhoneGetGLView().userInteractionEnabled = NO;
         [self.mapView._mapScrollView addSubview: iPhoneGetGLView() ];
         [self.mapView._mapScrollView bringSubviewToFront:  iPhoneGetGLView()]; 
        
         self.mapView._mapScrollView.delegate = self;
         self.mapView._mapScrollView.userInteractionEnabled=YES;
         [self.mapView setShowsUserLocation:false];
    
         
         [self.mapView setZoom:17];
         if(isInProduction())
         [self.mapView setMinZoom:17];
         
         [self.view endEditing:YES];
         [self.mapView endEditing:YES];
         
         
         // tap gestures
         
         /* Create the Tap Gesture Recognizer */
         self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
         
         /* The number of fingers that must be on the screen */
         self.tapGestureRecognizer.numberOfTouchesRequired = 1;
         /* The total number of taps to be performed before the gesture is recognized */
         self.tapGestureRecognizer.numberOfTapsRequired = 1;
         
         /* Add this gesture recognizer to our view */
         [self.view addGestureRecognizer:self.tapGestureRecognizer];
         
       
     }
    NSLog(@"loading map");
 
  
    return self;
}





- (void) handleTaps:(UITapGestureRecognizer*)paramSender{
    NSUInteger touchCounter = 0;
    for (touchCounter = 0; touchCounter < paramSender.numberOfTouchesRequired; touchCounter++)
    {
        CGPoint touchPoint = [paramSender locationOfTouch:touchCounter inView:paramSender.view];
        NSLog(@"Touch #%lu: %@", (unsigned long)touchCounter+1, NSStringFromCGPoint(touchPoint));
    }
}




//--------------------------------------------------------------
#pragma mark Configuration


- (void)viewDidAppear:(BOOL)animated
{
    cout<<"VIEW DID APPEAR"<<endl;
    [super viewDidAppear:animated];
  
    
    [super viewWillAppear:animated];
   
}

//--------------------------------------------------------------

- (void)viewWillDisappear:(BOOL)animated
{
  
    
    [super viewWillDisappear:animated];
}


//--------------------------------------------------------------



#pragma mark - WebView


-(RMMapView*) getMapView{
    return mapView;
}





#pragma mark - MapView stuff

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
       UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
       if( (appState != UIApplicationStateBackground) && (appState != UIApplicationStateInactive))
        {
    [ iPhoneGetGLView()  drawView];
            
        }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    if( (appState != UIApplicationStateBackground) && (appState != UIApplicationStateInactive))
    {
    [ iPhoneGetGLView()  drawView];
    }
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    if( (appState != UIApplicationStateBackground) && (appState != UIApplicationStateInactive))
    {
    [ iPhoneGetGLView()  drawView];
    }
    return YES;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    if( (appState != UIApplicationStateBackground) && (appState != UIApplicationStateInactive))
    {
    if ( iPhoneGetGLView())
    [ iPhoneGetGLView() drawView];
    }
    if (setZoom == true){
        return mapView._tiledLayersSuperview;
    } else{
        return  nil;
    }
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
   // [eagleScrollView  drawView];
    
    return true;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
   
   // [eagleScrollView  drawView];
    
  
   //  ofSendMessage("scrollViewStop");
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (isRetina){
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
         iPhoneGetGLView().center = CGPointMake(mapView._mapScrollView.contentOffset.x + screenBounds.size.width/2,
                                              mapView._mapScrollView.contentOffset.y + screenBounds.size.height/2);
    }
    else{
         iPhoneGetGLView().center = CGPointMake(mapView._mapScrollView.contentOffset.x + ((float)ofGetWidth())/2, mapView._mapScrollView.contentOffset.y + ((float)ofGetHeight())/2);
    }
    
  
}
#pragma  mark Annotations

// TODO annotation layer, check this stuff
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
                
    
    return  nil;
}


//--------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------
// when difficulties receiving taps on map, use ofGetMessage

- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
        RMMBTilesSource *tileSource = (RMMBTilesSource *)map.tileSource;
        string msg = "TAP:"+ofToString(point.x)+":"+ofToString(point.y);
    
        ofSendMessage(msg);

    if ([tileSource respondsToSelector:@selector(supportsInteractivity)] && [tileSource supportsInteractivity])
    {
        NSString *content = [tileSource formattedOutputOfType:RMInteractiveSourceOutputTypeTeaser forPoint:point inMapView:map];
        NSLog(@" YAAY");
        [map deselectAnnotation:map.selectedAnnotation animated:(content == nil)];
        [map removeAllAnnotations];
        
        if (content)
        {
            NSString *title = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] objectAtIndex:0];
            
            RMAnnotation *annotation = [RMAnnotation annotationWithMapView:map coordinate:[map pixelToCoordinate:point] andTitle:title];
            
            annotation.userInfo = content;
            
            [map addAnnotation:annotation];
            
            [map selectAnnotation:annotation animated:YES];
        }
    }
}


//------------------------------------------

- (void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    
  

}




- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [ iPhoneGetGLView()  drawView];

}



// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}




-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
 //   ofSendMessage("scrollViewStop");
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale

{
   // ofSendMessage("stopsZooming");
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
    
      //ofSendMessage("scrollViewStop");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



@end
