//
//  Tower.m
//  toweroffense
//
//  Created by Reilly Watson on 12-02-06.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Tower.h"


@implementation Tower

-(id)initWithLayer:(HelloWorldLayer *)layer
{
	if ((self = [super initWithFile:@"Player.png"])) {
		_layer = layer;
	}
	return self;
}

@end
