#import "cocos2d.h"

@interface MainLayer : CCLayer {
    
    int currentLayer;
    CCLayerMultiplex *gameLayers;
}

+(id) scene;
-(void) addButtons;
-(void) prevCallback:(id)sender;
-(void) nextCallback:(id)sender;

@end
