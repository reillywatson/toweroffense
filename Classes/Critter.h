//
//  Critter.h
//  TowerOffense
//
//  Created by Sergey Perunov on 02-05-2012.
//  Copyright 2011 Sergey Perunov. All rights reserved.
//

#import "cocos2d.h"

@class HelloWorldLayer;

@interface Critter : CCSprite {
    HelloWorldLayer * _layer;
    CCAnimate *_curAnimate;
	
@private
	NSMutableArray *spOpenSteps;
	NSMutableArray *spClosedSteps; 
    NSMutableArray *shortestPath;
	CCAction *currentStepAction;
    NSValue *pendingMove;
}

@property double speed;

- (id)initWithLayer:(HelloWorldLayer *)layer;
- (void)moveToward:(CGPoint)target;

@end
