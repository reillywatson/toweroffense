//
//  Projectile.m
//  toweroffense
//
//  Created by Reilly Watson on 12-02-07.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"
#import "HelloWorldLayer.h"

@implementation Projectile

-(id)initWithLayer:(HelloWorldLayer*)layer startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint velocity:(double)velocity
{
	if ((self = [super initWithFile:@"Projectile.png"])) {
		_layer = layer;
		_velocity = velocity;
		self.position = startPoint;
		CCMoveTo *moveTo = [CCMoveTo actionWithDuration:ccpDistance(startPoint, endPoint) / velocity position:endPoint];
		[self runAction:moveTo];
		[self schedule:@selector(doHitTest:) interval:0.2];
	}
	return self;
}

-(void)doHitTest:(ccTime)dt
{
	for (CCSprite *critter in [_layer critters]) {
		if (CGRectIntersectsRect([critter boundingBox], [self boundingBox])) {
			NSLog(@"HIT!!!!!!!!!");
			[_layer removeChild:self cleanup:true];
			[self release];
			break;
		}
	}										
}

@end
