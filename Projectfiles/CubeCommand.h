//
//  CubeCommand.h
//  LOLGramatik
//
//  Created by Jan Brond on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { msgNone, msgBalance, msgOrientation, msgHit, msgThrow, msgShakeStart, msgShakeEnd, msgShakeDetected,
    msgTiltLeft, msgTiltRight, msgTiltShake } cubeMessage;


@interface CubeCommand : NSObject {
    cubeMessage message;
    float fValue;
    int iValue;
    int cubeId;
}

@property (nonatomic) cubeMessage message;
@property (nonatomic) float fValue;
@property (nonatomic) int iValue;
@property (nonatomic) int cubeId;

@end
