//
//  HelloWorldLayer.m
//  toweroffense
//
//  Created by Reilly Watson on 12-01-31.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "ccMacros.h"

CCSprite *boy;
CCSprite *girl;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		boy = [CCSprite spriteWithFile:@"Character Boy.png"];
		boy.position = ccp(100,100);
		[self addChild:boy];

		girl = [CCSprite spriteWithFile:@"Character Cat Girl.png"];
		girl.position = ccp(300,200);
		[self addChild:girl];
		[self schedule:@selector(nextFrame:)];
		
	}
	return self;
}

-(void) nextFrame:(ccTime)dt {
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	boy.position = ccp(MAX(0, MIN(boy.position.x + (1000*dt*CCRANDOM_MINUS1_1()), windowSize.width - (boy.contentSize.width / 2))), MAX((boy.contentSize.height / 2), MIN(boy.position.y + (300*dt*CCRANDOM_MINUS1_1()), windowSize.height)));
	if (girl.position.x != boy.position.x) {
		girl.position = ccp(girl.position.x + (boy.position.x > girl.position.x ? 1 : -1) * 10 * dt, girl.position.y);
	}
	if (girl.position.y != boy.position.y) {
		girl.position = ccp(girl.position.x, girl.position.y + (boy.position.y > girl.position.y ? 1 : -1) * 10 * dt);
	}
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
