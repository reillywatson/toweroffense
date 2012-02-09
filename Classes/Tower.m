//
//  Tower.m
//  toweroffense
//
//  Created by Reilly Watson on 12-02-06.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Tower.h"
#import "Projectile.h"
#import "HelloWorldLayer.h"

@implementation Tower

// number of seconds between shots
-(double)firingFrequency {
	return 0.3;
}

// pixel firing radius
-(double)range {
	return 500;
}

// pixels-per-second of fired projectiles
-(double)firingVelocity {
	return 150;
}


-(id)initWithLayer:(HelloWorldLayer *)layer
{
	if ((self = [super initWithFile:@"teslacoil.png"])) {
		_layer = layer;
	}
	[self schedule:@selector(updateTargeting:) interval:[self firingFrequency]];
	return self;
}

- (Critter *)getClosestTarget {
	Critter *closest = nil;
	double maxDistance = INT_MAX;
	for (Critter *target in [_layer critters]) {	
		double distance = ccpDistance(self.position, target.position);
		if (distance < maxDistance) {
			closest = target;
			maxDistance = distance;
		}
	}
	if (maxDistance <= [self range]) {
		return closest;
	}
	return nil;
}

-(void)fireProjectileAt:(CGPoint)position {
	CGRect rect = [self boundingBox];
	CGPoint center = CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2));
	[[Projectile alloc] initWithLayer:_layer startPoint:center endPoint:position velocity:[self firingVelocity]];
}

-(void)updateTargeting:(ccTime)dt
{
	if (_currentTarget == nil || ccpDistance(self.position, _currentTarget.position) > [self range]) {
		_currentTarget = [self getClosestTarget];
	}
	if (_currentTarget) {
		[self fireProjectileAt:_currentTarget.position];
	}
}


@end
