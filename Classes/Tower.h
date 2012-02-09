//
//  Tower.h
//  toweroffense
//
//  Created by Reilly Watson on 12-02-06.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Critter.h"

@class HelloWorldLayer;

@interface Tower : CCSprite {
	HelloWorldLayer *_layer;
	Critter *_currentTarget;
}

-(id)initWithLayer:(HelloWorldLayer *)layer;

@end
