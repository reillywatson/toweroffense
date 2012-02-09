//
//  Projectile.h
//  toweroffense
//
//  Created by Reilly Watson on 12-02-07.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class HelloWorldLayer;

@interface Projectile : CCSprite {
	HelloWorldLayer *_layer;
	double _velocity;
	double _damage;
}

-(id)initWithLayer:(HelloWorldLayer*)layer startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint velocity:(double)velocity damage:(double)damage;

@end
