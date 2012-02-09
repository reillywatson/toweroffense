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
#import "Tower.h"
#import "toweroffenseAppDelegate.h"

@interface CCArray (PrivateExtensions)
-(CCArray *)arrayWithMembersOfClass:(Class)class;
@end

@implementation CCArray (PrivateExtensions)

-(CCArray *)arrayWithMembersOfClass:(Class)class
{
	CCArray *array = [[CCArray new] autorelease];
	for (id i in self) {
		if ([i isKindOfClass:class]) {
			[array addObject:i];
		}
	}
	return array;
}
@end

@interface CCTMXTiledMap (PrivateExtensions)
-(void)setTile:(NSString*)name onLayer:(CCTMXLayer *)layer at:(CGPoint)coords;
@end

@implementation CCTMXTiledMap (PrivateExtensions)
// If this turns out to be too slow, we can cache the results, because Name isn't going to change
-(void)setTile:(NSString*)name onLayer:(CCTMXLayer *)layer at:(CGPoint)coords
{
	NSArray *tileGIDs = [tileProperties_ allKeys];
	for (NSNumber *gid in tileGIDs) {
		NSString *tileName = [[tileProperties_ objectForKey:gid] valueForKey:@"Name"];
		if ([tileName isEqualToString:name]) {
			[layer setTileGID:[gid intValue] at:coords];
			break;
		}
	}
}
@end

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


-(void)updateCritterPaths
{
	for (Critter *critter in [self critters]) {
		[critter updatePath];
	}
}

-(CCLayer *)panZoomLayer
{
	return _panZoomLayer;
}

-(CCArray *)critters
{
	return [_panZoomLayer.children arrayWithMembersOfClass:[Critter class]];
}

-(CCArray *)towers
{
	return [_panZoomLayer.children arrayWithMembersOfClass:[Tower class]];
}

-(BOOL)towerAtTileCoordinate:(CGPoint)coords
{
	coords = [self positionForTileCoordinate:coords];
	for (Tower *tower in [self towers]) {
		if (CGRectContainsPoint([tower boundingBox], coords)) {
			return YES;
		}
	}
	return NO;
}

-(BOOL)canPlaceTowerAtTileCoordinate:(CGPoint)coords
{
	return ![self towerAtTileCoordinate:coords] && ![self tileAtCoordinate:coords hasProperty:@"Collidable"];
}

-(void)placeTowerAtTileCoordinate:(CGPoint)coords
{
	if ([self canPlaceTowerAtTileCoordinate:coords]) {
		Tower *tower = [[Tower alloc] initWithLayer:self];
		tower.position = ccp((coords.x * 32) + 16, self.background.contentSize.height - (coords.y * 32) - 16);
		[_panZoomLayer addChild:tower z:1];
		
		[self updateCritterPaths];
	}
	else {
		NSLog(@"Tower already at coordinate %@", NSStringFromCGPoint(coords));
	}
}

-(void)addCritter
{
	Critter *critter = [[[Critter alloc] initWithLayer:self] autorelease];
	critter.position = ccp(0,200);
	critter.speed = 0.3;
	[_panZoomLayer addChild:critter];
	NSLog(@"suspcicious!");
	[critter moveToward:[self positionForTileCoordinate:ccp(49,35)]];	
	NSLog(@"confirmed!");
}

-(id) init
{
	if( (self=[super init])) {
        _towers = [NSMutableArray new];
		_projectiles = [NSMutableArray new];
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        
        _panZoomLayer = [[CCLayerPanZoom node] retain];
        [self addChild: _panZoomLayer];
        [_panZoomLayer addChild:_tileMap z:0 tag: 1];
        _panZoomLayer.minScale = 1.0f;
        _panZoomLayer.rubberEffectRatio = 0.0f;
		
		UILongPressGestureRecognizer* recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressFrom:)];
		recognizer.minimumPressDuration = 2.0; // seconds
		[[((toweroffenseAppDelegate*)([[UIApplication sharedApplication] delegate]))->viewController view] addGestureRecognizer:recognizer];
        // TODO figure out the right bounds for the map.
		[self schedule:@selector(addCritter) interval:3];
	}
	return self;
}

-(void)handleLongPressFrom:(UIGestureRecognizer *)recognizer
{
	CGPoint rawLocation = [recognizer locationInView:[((toweroffenseAppDelegate*)([[UIApplication sharedApplication] delegate]))->viewController view]];
	CGPoint location = [_panZoomLayer convertToNodeSpace:[[CCDirector sharedDirector] convertToGL: rawLocation]];
	CGPoint tileCoord = [self tileCoordinateForPosition:location];
	[self placeTowerAtTileCoordinate:tileCoord];
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

-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate
{
	return [self towerAtTileCoordinate:tileCoordinate] || [self tileAtCoordinate:tileCoordinate hasProperty:@"Collidable"];
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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    self.tileMap = nil;
    self.background = nil;
	[_towers release];
	[_projectiles release];
	[super dealloc];
}
@end
