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
#import "Critter.h"

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

-(id) init
{
	if( (self=[super init])) {
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        
        _panZoomLayer = [[CCLayerPanZoom node] retain];
        [self addChild: _panZoomLayer];
        [_panZoomLayer addChild:_tileMap z:0 tag: 1];
        _panZoomLayer.minScale = 1.0f;
        _panZoomLayer.rubberEffectRatio = 0.0f;
                
        // TODO figure out the right bounds for the map.
        
        Critter *critter = [[[Critter alloc] initWithLayer:self] autorelease];
        critter.position = ccp(0,200);
        critter.speed = 0.3;
        [_panZoomLayer addChild:critter]; 
        [critter moveToward:[self positionForTileCoordinate:ccp(49,35)]];

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

-(BOOL)isValidTileCoord:(CGPoint)tileCoord
{
    if (tileCoord.x < 0 || tileCoord.y < 0 || 
        tileCoord.x >= _tileMap.mapSize.width ||
        tileCoord.y >= _tileMap.mapSize.height) {
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)tileAtCoordinate:(CGPoint)tileCoordinate hasProperty:(NSString *)property
{
	NSArray *layers = [_tileMap allLayers];
	for (CCTMXLayer *layer in layers) {
		int tileGid = [layer tileGIDAt:tileCoordinate];
		if (tileGid) {
			NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
			if (properties) {
				NSString *value = [properties valueForKey:property];
				if (value) {
					return YES;
				}
			}
		}
	}
	return NO;
}

-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate
{
	return [self tileAtCoordinate:tileCoordinate hasProperty:@"Collidable"];
}

-(BOOL)isBaseAtTileCoordinate:(CGPoint)tileCoordinate
{
	return [self tileAtCoordinate:tileCoordinate hasProperty:@"Base"];
}

-(CGPoint)tileCoordinateForPosition:(CGPoint)position
{
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
}

-(CGPoint)positionForTileCoordinate:(CGPoint)tileCoordinate
{
    int x = (tileCoordinate.x * _tileMap.tileSize.width) + _tileMap.tileSize.width/2;
    int y = (_tileMap.mapSize.height * _tileMap.tileSize.height) - (tileCoordinate.y * _tileMap.tileSize.height) - _tileMap.tileSize.height/2;
    return ccp(x, y);
}

-(NSArray *)walkableAdjacentTilesCoordForTileCoordinate:(CGPoint)tileCoordinate
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:4];
    
    BOOL t = NO;
    BOOL l = NO;
    BOOL b = NO;
    BOOL r = NO;
    
	// Top
	CGPoint p = CGPointMake(tileCoordinate.x, tileCoordinate.y - 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        t = YES;
	}
    
	// Left
	p = CGPointMake(tileCoordinate.x - 1, tileCoordinate.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        l = YES;
	}
    
	// Bottom
	p = CGPointMake(tileCoordinate.x, tileCoordinate.y + 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        b = YES;
	}
    
	// Right
	p = CGPointMake(tileCoordinate.x + 1, tileCoordinate.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        r = YES;
	}
    
    
	// Top Left
	p = CGPointMake(tileCoordinate.x - 1, tileCoordinate.y - 1);
	if (t && l && [self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Bottom Left
	p = CGPointMake(tileCoordinate.x - 1, tileCoordinate.y + 1);
	if (b && l && [self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Top Right
	p = CGPointMake(tileCoordinate.x + 1, tileCoordinate.y - 1);
	if (t && r && [self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Bottom Right
	p = CGPointMake(tileCoordinate.x + 1, tileCoordinate.y + 1);
	if (b && r && [self isValidTileCoord:p] && ![self isWallAtTileCoordinate:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	return [NSArray arrayWithArray:tmp];
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
