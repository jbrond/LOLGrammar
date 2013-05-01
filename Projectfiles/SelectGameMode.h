//
//  SelectGameMode.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "basicGrammarLayer.h"

@interface SelectGameMode : basicGrammarLayer {
    NSString *name;
    CCSprite * bannerTeam1;
    CCSprite * bannerTeam2;
    CCSprite * cubePractice;
    CCSprite * cubeTime;
    bool isCurrent;
}

+(id) layerWithLayerNumber:(int)layerNumber;
-(id) initWithLayerNumber:(int)layerNumber;
-(void) goToLayer:(id)sender;
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
