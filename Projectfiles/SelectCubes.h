//
//  SelectCubes.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import "basicGrammarLayer.h"

@interface SelectCubes : basicGrammarLayer {
    NSString *name;
    
    CCLabelTTF *team1Cube;
    CCLabelTTF *team2Cube;
    CCUIViewWrapper *wrapper;
    UIScrollView *scrollview;
    
    CCSprite * bannerTeam1;
    CCSprite * bannerTeam2;
    CCSprite * ramme;
    
    int currentTeamSelected;
    bool isCurrent;
    
}

+(id) layerWithLayerNumber:(int)layerNumber;
-(id) initWithLayerNumber:(int)layerNumber;
-(void) goToLayer:(id)sender;
- (void) cubeSelected:(id) sender;
-(void) onExit;
-(void) onEnter;

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
