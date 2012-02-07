//
//  HelloWorldLayer.h
//  toweroffense
//
//  Created by Reilly Watson on 12-01-31.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCLayerPanZoom.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCTMXLayer *_meta;
    CCLayerPanZoom *_panZoomLayer;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(NSArray *)walkableAdjacentTilesCoordForTileCoordinate
:(CGPoint)tileCoordinate;
-(BOOL)isBaseAtTileCoordinate:(CGPoint)tileCoordinate;
-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate;
-(CGPoint)tileCoordinateForPosition:(CGPoint)position;
-(CGPoint)positionForTileCoordinate:(CGPoint)tileCoordinate;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *meta;

@end
