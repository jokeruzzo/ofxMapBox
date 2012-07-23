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
    
}


@end
