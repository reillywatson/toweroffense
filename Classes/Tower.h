//
//  Tower.h
//  toweroffense
//
//  Created by Reilly Watson on 12-02-06.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class HelloWorldLayer;

@interface Tower : CCSprite {
	HelloWorldLayer *_layer;
}

-(id)initWithLayer:(HelloWorldLayer *)layer;

@end
