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


@end


@implementation mapController 

@synthesize setZoom;
@synthesize mapView;
@synthesize freeze;
@synthesize bMovingMap;
@synthesize valueZoom;
@synthesize tapping;
@synthesize permissions;


@synthesize loginButton;

@synthesize              startLocation;
@synthesize              currentLocation;
@synthesize              endLocation;






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
    
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    self.mapView= [[RMMapView  alloc] initWithFrame: frame  andTilesource:source];
         
         if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
             ([UIScreen mainScreen].scale == 2.0)) {
             
        
             self.mapView.adjustTilesForRetinaDisplay = YES;
             [self.mapView setFrame:frame];
             self.mapView.frame = self.view.bounds;
             self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         
         } 

    eagleScrollView = iPhoneGetGLView();
    [self.mapView._mapScrollView addSubview: eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront: eagleScrollView];
         
                   
    // for the GLView update
    
         self.mapView._mapScrollView.delegate = self;
         [self.mapView setZoom:17];
           

         [eagleScrollView release];
     }
    NSLog(@"loading map");
    
    return self;
}

#pragma mark Configuration



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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{  
    
    if (setZoom == true){
        return mapView._tiledLayersSuperview;
    } else{
        return  nil;
    }
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    
    return true;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    cout<<"dragging"<<endl;
  
   //   ofSendMessage("scrollViewStop");
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [eagleScrollView  drawView];
   
    BOOL isRetina, isiPad;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] > 1)
            isRetina = true;
    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            isiPad = true;
    
    [pool release];
    
    
    if (isRetina){
        
        
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + screenBounds.size.width/2,
                                              mapView._mapScrollView.contentOffset.y + screenBounds.size.height/2);
    
    }
    else{
    
        eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ((float)ofGetWidth())/2, mapView._mapScrollView.contentOffset.y + ((float)ofGetHeight())/2);
    }
  
}





- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    ofSendMessage("isZooming");
   //   ofSendMessage("isZooming");
 //   [self.mapView correctPositionOfAllAnnotations];
    
    if (self.mapView._delegateHasAfterMapZoom)
   //     [self.mapView._delegate afterMapZoom:self.mapView];
    [self.mapView scrollViewDidZoom:scrollView];
    
    
    
}


//(void)viewDidLoad
//{
//    // this creates the CCLocationManager that will find your current location
//    CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//    [locationManager startUpdatingLocation];
//}


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

-(bool)isMoving{
    
    return bMovingMap;
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


#pragma mark - Facebook API Calls

@end
pragma mark - Facebook API Calls

@end
