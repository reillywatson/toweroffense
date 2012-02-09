//
//  Projectile.m
//  toweroffense
//
//  Created by Reilly Watson on 12-02-07.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"
#import "HelloWorldLayer.h"
#import "Critter.h"

@implementation Projectile

-(id)initWithLayer:(HelloWorldLayer*)layer startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint velocity:(double)velocity damage:(double)damage
{
	if ((self = [super initWithFile:@"Projectile.png"])) {
		_layer = layer;
		[[_layer panZoomLayer] addChild:self z:2];
		_velocity = velocity;
		_damage = damage;
		self.position = startPoint;
		id actionMove = [CCMoveTo actionWithDuration:ccpDistance(startPoint, endPoint) / velocity position:endPoint];
		id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSelf:)];
		[self runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
		[self schedule:@selector(doHitTest:) interval:0.2];
	}
	return self;
}

-(void)removeSelf:(id)_
{
	[[_layer panZoomLayer] removeChild:self cleanup:true];
	[self release];
}

-(void)hitCritter:(Critter *)critter
{
	[critter takeDamage:_damage];
}

-(void)doHitTest:(ccTime)dt
{
	for (Critter *critter in [_layer critters]) {
		if (CGRectIntersectsRect([critter boundingBox], [self boundingBox])) {
			[self hitCritter:critter];
			[self removeSelf:nil];
			break;
		}
	}										
}

@end
