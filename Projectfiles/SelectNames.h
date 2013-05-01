//
//  SelectNames.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import "basicGrammarLayer.h"

@interface SelectNames : basicGrammarLayer {
    CCUIViewWrapper *wrapper;
    UIScrollView *scrollview;
    
    CCLabelTTF *team1Name;
    CCLabelTTF *team2Name;
    
    CCSprite * bannerTeam1;
    CCSprite * bannerTeam2;
    CCSprite * ramme;
    
    int currentTeamSelected;
    bool isCurrent;
}

+(id) layerWithLayerNumber:(int)layerNumber;
-(id) initWithLayerNumber:(int)layerNumber;
-(void) goToLayer:(id)sender;
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
