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
#import "RMFoundation.h"



#import "RMAnnotation.h"
#import "RMMBTilesSource.h"

#include "map.h"


@interface mapController()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end


@implementation mapController 

@synthesize setZoom;
@synthesize mapView;
@synthesize freeze;
@synthesize bMovingMap;
@synthesize valueZoom;
@synthesize tapping;
@synthesize permissions;
@synthesize timer;


@synthesize              startLocation;
@synthesize              currentLocation;
@synthesize              endLocation;



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
    tapping = false;
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
           //  CGRect rect =  CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height);
             [self.mapView setFrame:frame];
             self.mapView.frame = self.view.bounds;
             self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         
         }  else{
             
             isRetina = false;
         }

    eagleScrollView = iPhoneGetGLView();
         
   
         
    [self.mapView._mapScrollView addSubview: eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront: eagleScrollView]; 

         self.mapView._mapScrollView.delegate = self;
         self.mapView._mapScrollView.userInteractionEnabled=YES;
        // ofxiPhoneGetGLView().delegate = self;
         
         [self.mapView setZoom:17];
         [eagleScrollView release];
     }
    NSLog(@"loading map");
    
    return self;
}

#pragma mark Configuration


- (void)viewDidAppear:(BOOL)animated
{
    cout<<"VIEW DID APPEAR"<<endl;
    [super viewDidAppear:animated];
    
   
}



#pragma mark - WebView


-(RMMapView*) getMapView{
    return mapView;
}


-(void)handleTap:(UIGestureRecognizer *) gr{
  
    if([gr state] == UIGestureRecognizerStateRecognized){
        NSLog(@"tap!");
        tapping = TRUE;
        startLocation = [gr locationInView:self.mapView];
        cout<<startLocation.x<<endl;
         cout<<startLocation.y<<endl;
    }
    
}


#pragma mark - MapView stuff

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    [eagleScrollView  drawView];
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [eagleScrollView  drawView];
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    [eagleScrollView  drawView];
    return YES;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{  
    [eagleScrollView  drawView];
    
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
    
  
   //   ofSendMessage("scrollViewStop");
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isRetina){
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + screenBounds.size.width/2,
                                              mapView._mapScrollView.contentOffset.y + screenBounds.size.height/2);
    }
    else{
        eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ((float)ofGetWidth())/2, mapView._mapScrollView.contentOffset.y + ((float)ofGetHeight())/2);
    }
    
  
}


// Override
- (void)setContentOffset:(CGPoint)contentOffset {
    // UIScrollView uses UITrackingRunLoopMode.
	// NSLog([[NSRunLoop currentRunLoop] currentMode]);
    
	// If we're dragging, mainLoop is going to freeze.
	if (self.mapView._mapScrollView.dragging && !self.mapView._mapScrollView.decelerating) {
      
		// Make sure we haven't already created our timer.
		if (timer == nil) {
//            CCDirector* director = [CCDirector sharedDirector];
//            director.animationInterval = director.animationInterval * 2.0f;
//			// Schedule a new UITrackingRunLoopModes timer, to fill in for CCDirector while we drag.
//			timer = [NSTimer scheduledTimerWithTimeInterval:[eagleScrollView animationInterval] target:self selector:@selector(animateWhileDragging) userInfo:nil repeats:YES];
//            
//            // This could also be NSRunLoopCommonModes
//			[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopModes];
		}
	}
    
	// If we're decelerating, mainLoop is going to stutter.
	if (self.mapView._mapScrollView.dragging && !self.mapView._mapScrollView.decelerating) {
            cout<<"DRAGGING"<<endl;
            cout<<"decelating"<<endl;
		// Make sure we haven't already created our timer.
		if (timer == nil) {
//            
//			// Schedule a new UITrackingRunLoopMode timer, to fill in for CCDirector while we decellerate.
//			timer = [NSTimer scheduledTimerWithTimeInterval:[[CCDirector sharedDirector] animationInterval] target:self selector:@selector(animateWhileDecellerating) userInfo:nil repeats:YES];
//			[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
		}
	}
    
	[super setContentOffset:contentOffset];
}

- (void)animateWhileDragging {
    
	// Draw.
	//[[CCDirector sharedDirector] drawScene];
    
	if (!self.mapView._mapScrollView.dragging) {
        
		// Don't need this timer anymore.
		[timer invalidate];
		timer = nil;
	}
}

- (void)animateWhileDecellerating {
    
	// Draw.
	//[[CCDirector sharedDirector] drawScene];
    
	if (!self.mapView._mapScrollView.decelerating) {
        
		// Don't need this timer anymore.
		[timer invalidate];
		timer = nil;
	}
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [eagleScrollView  drawView];
    
   
   //   ofSendMessage("isZooming");
 //   [self.mapView correctPositionOfAllAnnotations];
    
    if (self.mapView._delegateHasAfterMapZoom)
   //     [self.mapView._delegate afterMapZoom:self.mapView];
    [self.mapView scrollViewDidZoom:scrollView];
    
    
    
}

// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    self.mapView._mapScrollView.delegate = self;
    [geoCoder start];
}

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}


// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
   // NSString *city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
}



// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
 //   ofSendMessage("scrollViewStop");
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale

{
    ofSendMessage("stopsZooming");
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    bMovingMap = false;
    
      //ofSendMessage("scrollViewStop");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


#pragma mark - rotation user




-(bool)isMoving{
    
    return bMovingMap;
}



@end
