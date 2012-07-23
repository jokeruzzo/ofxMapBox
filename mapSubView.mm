
//  Created by Martijn Mellema on 20-07-12.
//  Copyright (c) 2012 www.martijnmellema.com All rights reserved.
//  Visual conceptual artist / Interaction designer

//

#import "mapSubView.h"





@implementation mapSubView
@synthesize eagleScrollView;


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
       
  
    }
    return self;
    
}




- (id)initWithFrame:(CGRect)frame andTilesource:(id<RMTileSource>)newTilesource
{
    self = [super initWithFrame:frame andTilesource:newTilesource];
    if (self) {
            

    }
    return self;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // because the gesture events couldn't be subclassed from the RMMview.h, I had to insert them in the scrollView and lock the view on the contentOffset. 
    eagleScrollView.center = CGPointMake(self._mapScrollView.contentOffset.x + ofGetWidth()/2, self._mapScrollView.contentOffset.y + ofGetHeight()/2);  
    
}


@end
