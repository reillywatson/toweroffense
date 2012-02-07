//
//  CatSprite.h
//  CatThief
//
//  Created by Ray Wenderlich on 6/7/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "cocos2d.h"
#import <OpenAL/al.h>

@class HelloWorldLayer;

@interface Critter : CCSprite {
    HelloWorldLayer * _layer;
    CCAnimate *_curAnimate;
    int _numBones;
	
@private
	NSMutableArray *spOpenSteps;
	NSMutableArray *spClosedSteps; 
    NSMutableArray *shortestPath;
	CCAction *currentStepAction;
    NSValue *pendingMove;
}

- (id)initWithLayer:(HelloWorldLayer *)layer;
- (void)moveToward:(CGPoint)target;

@end
