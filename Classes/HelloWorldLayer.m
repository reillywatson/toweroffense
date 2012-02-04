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

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize tileMap = _tileMap;
@synthesize background = _background;

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
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        
        _panZoomLayer = [[CCLayerPanZoom node] retain];
        [self addChild: _panZoomLayer];
        [_panZoomLayer addChild:_tileMap z:0 tag: 1];
        _panZoomLayer.minScale = 1.0f;
        _panZoomLayer.rubberEffectRatio = 0.0f;
        
        // I keep getting the wrong coordinates with this nonesense.
        //CGSize mapSize = _tileMap.mapSize;
        //_panZoomLayer.panBoundsRect = CGRectMake(0, 0, mapSize.width, mapSize.height);
        
	}
	return self;
}

-(void)setViewpointCenter:(CGPoint) position
{    
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, windowSize.width / 2);
    int y = MAX(position.y, windowSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) - windowSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - windowSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(windowSize.width/2, windowSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

/*
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
 */

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    self.tileMap = nil;
    self.background = nil;
	[super dealloc];
}
@end
